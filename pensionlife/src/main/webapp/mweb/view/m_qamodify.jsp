<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="model.dbconfig" %>
<%
	//Update 사용하여 수정하는 jsp
	HttpSession se = request.getSession();
	String user_id = (String)se.getAttribute("user_id");
	String user_name = (String)se.getAttribute("user_name");
	
	String qidx = request.getParameter("qidx");
	Connection con = null;
	PreparedStatement pst = null;
	ResultSet rs = null;
	boolean mod = false;
	//문의유형에 onselect를 적용하기 위해 만든 리스트
	List<String> pt = new ArrayList<String>();
	for(int f=0; f<6; f++){
		pt.add("");
	}
	//첨부파일 갯수
	int file_ea = 0;
	//첨부파일관련 변수
	String qfile = "";
	String qfile1 = null;
	String qfile2 = null;
	String dbqfile1 = "";
	String dbqfile2 = "";
	if(qidx != null){
		dbconfig db = new dbconfig();
		con = db.getdbconfig();
		String sql = "select * from qa_board where qidx=?";
		pst = con.prepareStatement(sql);
		pst.setString(1, qidx);
		rs = pst.executeQuery();
		rs.next();
		//db에 저장된 문의유형
		String qh = rs.getString("qhead");
		qfile = rs.getString("qfile");
		
		//db에 저장된 파일url에서 파일명만 갖고옴
		//파일이 두개인 경우
		if(qfile.contains(",")){
			file_ea = 2;
			int id = qfile.indexOf(",");
			dbqfile1 = qfile.substring(0,id);
			dbqfile2 = qfile.substring(id+1);
			qfile1 = dbqfile1.substring(dbqfile1.lastIndexOf("_")+1);
			qfile2 = dbqfile2.substring(dbqfile2.lastIndexOf("_")+1);
		}
		//파일이 한개인 경우
		else if(qfile != ""){
			file_ea = 1;
			dbqfile1 = qfile;
			qfile1 = qfile.substring(qfile.lastIndexOf("_")+1);
		}
	}else{
		//수정버튼이 아닌 주소로 직접 접근 막음
		out.print("<script>alert('올바른 접근이 아닙니다.');</script>");
	}
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>호텔 & 펜션 예약시스템</title>
    <link rel="stylesheet" type="text/css" href="../css/m_index.css?v=2">
    <link rel="stylesheet" type="text/css" href="../css/m_sub.css?v=3">
    <link rel="stylesheet" type="text/css" href="../css/m_qaboard.css?v=3">
    <script src="../js/jquery.js"></script>
    <script src="../js/m_index.js"></script>
    <script src="../js/m_qamodify.js?v=2"></script>
</head>
<body> 
<!-- 상단 시작 -->
<%@ include file="../top.jsp" %>
<!-- 상단 끝 -->
<main>
<!-- 배너 -->
<%@ include file="../banner.jsp" %>
<!-- 배너 끝-->
<!-- 중단 -->
<section class="subpage">
<form id="frm">
    <div class="member_agree">
        <p>1:1 문의게시판(문의수정)</p>
        <span class="sub_titles">빠르게 궁금한 사항을 답변 드리도록 하겠습니다.</span>
        <ul class="write_ul">
        	<input type="hidden" value="<%=qidx %>" name="qidx">
        	<input type="hidden" value="<%=rs.getString("qhead") %>" name="qhead">
            <li class="cate_txt">질문항목 : <%=rs.getString("qhead") %></li>
            <li><input type="text" class="w_input1 w_bg" name="user_name" value="<%=rs.getString("user_name") %>" readonly></li>
            <li><input type="text" class="w_input1 w_bg" name="user_tel" value="<%=rs.getString("user_tel") %>" readonly></li>
            <li><input type="text" class="w_input1 w_bg" name=user_email value="<%=rs.getString("user_email") %>" readonly></li>
            <li><input type="text" class="w_input1" id="qtitle" name="qtitle" value="<%= rs.getString("qtitle")%>" placeholder="질문 제목"></li>
            <li><textarea class="w_input2" id="qtext" name="qtext" placeholder="질문 내용"><%=rs.getString("qtext")%></textarea></li>
            
	        <!-- 첫번째 첨부파일 -->
	        <%if(qfile1 != null){ %>
	        <input type="hidden" value="N" id="file1_del" name="file1_del">
	        <input type="hidden" value="<%=qfile1 %>" name="qfile1_val">
			<li id="qfileview1a" style="display:none"><input type="file" id="qfile1" name="qfile1" class="w_li"> * 최대 2MB까지 가능</li>
			<li class="fileview" id="qfileview1b" >첨부파일 : <a href="<%out.print(dbqfile1);%>" target="_blank"><%out.print(qfile1); %></a> 
			&nbsp;&nbsp;&nbsp;&nbsp;<input type="button" value="삭제" onclick="filedel_btn(1)"> </li>
			<%}else{ %>
			<li id="qfileview1a"><input type="file" id="qfile1" name="qfile1" class="w_li"> * 최대 2MB까지 가능</li>
			<%} %>
			
			<!-- 두번째 첨부파일 -->
			<%if(qfile2 != null){ %>
			<input type="hidden" value="N" id="file2_del" name="file2_del">
			<input type="hidden" value="<%=qfile2 %>" name="qfile2_val">
			<li id="qfileview2a" style="display:none"><input type="file" id="qfile2" name="qfile2" class="w_li"> * 최대 2MB까지 가능</li>
			<li class="fileview" id="qfileview2b">첨부파일 : <a href="<%out.print(dbqfile2);%>" target="_blank"><%out.print(qfile2); %></a> 
			&nbsp;&nbsp;&nbsp;&nbsp;<input type="button" value="삭제" onclick="filedel_btn(2)"> </li>
			<%}else{ %>
			<li id="qfileview2a" ><input type="file" id="qfile2" name="qfile2" class="w_li"> * 최대 2MB까지 가능</li>
			<%} %>
			
            <li>※ 첨부파일은 이미지만 등록 가능합니다.</li>
        </ul>
        <div class="member_agreebtn" id="modify_btn">문의수정</div>
        <div class="member_agreebtn" id="delete_btn" style="background-color: darkblue; color:white;">문의삭제</div>
    </div>  
</form>
</section>
<!-- 하단 시작 -->
<%@ include file="../Qmenu.jsp" %>
</main>
<%@ include file="../copyright.jsp" %>
</body>
</html>