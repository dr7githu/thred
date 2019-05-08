<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.com.cmm.service.EgovProperties"%>
<%@ page import="egovframework.com.cmm.LoginVO"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<%
	String jqueryJs = EgovProperties.getProperty("jquery.js");
	String bootstrapNfittyHome = EgovProperties.getProperty("bootstrap.nfitty.home");
	String bootstrapCss = EgovProperties.getProperty("bootstrap.css");
	String bootstrapJs = EgovProperties.getProperty("bootstrap.js");
	String bootstrapNfittyCss = EgovProperties.getProperty("bootstrap.nfitty.css");
	String bootstrapNfittyJs = EgovProperties.getProperty("bootstrap.nfitty.js");
	String bootstrapNfittyPaceCss = EgovProperties.getProperty("bootstrap.nfitty.pace.css");
	String bootstrapNfittyPaceJs = EgovProperties.getProperty("bootstrap.nfitty.pace.js");
	String bootstrapNfittyDemoPluginsFontAwesomeCss = EgovProperties.getProperty("bootstrap.nfitty.demo.plugins.fontawesome.css");
%>

<c:set var="bootstrapNfittyHome" scope="session" value="<%=bootstrapNfittyHome%>" />

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta http-equiv="X-UA-Compatible" content="IE=edge">

<title><tiles:insertAttribute name="title" ignore="true"/></title>

<link rel="shortcut icon" href="/images/comm/3d_16px.png">

<!-- Font -->
<link rel="stylesheet" type="text/css" href="http://fonts.googleapis.com/css?family=Open+Sans:300,400,600,700&amp;subset=latin">

<!-- IMPORT CSS -->
<link rel="stylesheet" type="text/css" href="<%=bootstrapCss%>">
<link rel="stylesheet" type="text/css" href="<%=bootstrapNfittyCss%>">
<link rel="stylesheet" type="text/css" href="<%=bootstrapNfittyPaceCss%>">
<link rel="stylesheet" type="text/css" href="<%=bootstrapNfittyDemoPluginsFontAwesomeCss%>">
<link rel="stylesheet" type="text/css" href="<%=bootstrapNfittyHome%>css/demo/nifty-demo-icons.min.css">
<link rel="stylesheet" type="text/css" href="<%=bootstrapNfittyHome%>css/demo/nifty-demo.min.css">
<link rel="stylesheet" type="text/css" href="<%=bootstrapNfittyHome%>premium/icon-sets/icons/line-icons/premium-line-icons.min.css">
<link rel="stylesheet" type="text/css" href="<%=bootstrapNfittyHome%>premium/icon-sets/icons/solid-icons/premium-solid-icons.min.css">

<!-- IMPORT JS -->
<script type="text/javascript" src="<%=jqueryJs%>"></script>
<script type="text/javascript" src="<%=bootstrapJs%>"></script>
<script type="text/javascript" src="<%=bootstrapNfittyJs%>"></script>
<script type="text/javascript" src="<%=bootstrapNfittyPaceJs%>"></script>
<%-- <script type="text/javascript" src="<%=bootstrapNfittyHome%>js/demo/nifty-demo.min.js"></script> --%>
<script type="text/javascript" src="<%=bootstrapNfittyHome%>plugins/morris-js/morris.min.js"></script>
<script type="text/javascript" src="<%=bootstrapNfittyHome%>plugins/morris-js/raphael-js/raphael.min.js"></script>

</head>

<body>
	<div id="container" class="cls-container">
		<tiles:insertAttribute name="contents" ignore="true" />
	</div>
</body>
</html>
