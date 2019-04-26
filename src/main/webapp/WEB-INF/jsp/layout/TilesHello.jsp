<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%
	request.setCharacterEncoding("UTF-8");
	response.setCharacterEncoding("UTF-8");
%>
<!DOCTYPE HTML>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title><tiles:insertAttribute name="title" ignore="true" /></title>
</head>
<body>
<head>
<tiles:insertAttribute name="head" ignore="true" />
</head>
<menu>
	<tiles:insertAttribute name="menu" ignore="true" />
</menu>
<div id="warp">
	<tiles:insertAttribute name="contents" ignore="true" />
</div>
<footer>
	<tiles:insertAttribute name="footer" ignore="true" />
</footer>
</body>
</html>