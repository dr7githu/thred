<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
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
<html lang="en">

<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta http-equiv="X-UA-Compatible" content="IE=edge">

<title>asdf</title>

<!-- IMPORT CSS -->
<link href="http://fonts.googleapis.com/css?family=Open+Sans:300,400,600,700&amp;subset=latin" rel="stylesheet">
<!--Open Sans Font [ OPTIONAL ] -->
<link rel="stylesheet" type="text/css" href="<%=bootstrapCss%>">
<link rel="stylesheet" type="text/css" href="<%=bootstrapNfittyCss%>">
<link rel="stylesheet" type="text/css" href="<%=bootstrapNfittyPaceCss%>">
<!--Pace - Page Load Progress Par [OPTIONAL]-->
<link rel="stylesheet" type="text/css" href="<%=bootstrapNfittyDemoPluginsFontAwesomeCss%>">
<link rel="stylesheet" type="text/css" href="http://fonts.googleapis.com/css?family=Open+Sans:300,400,600,700&amp;subset=latin">
<link rel="stylesheet" type="text/css" href='https://fonts.googleapis.com/css?family=Open+Sans:400,300,600,700'	rel='stylesheet' type='text/css'>
<link rel="stylesheet" type="text/css"
	href="${bootstrapNfittyHome}css/demo/nifty-demo-icons.min.css"
	rel="stylesheet">
<link rel="stylesheet" type="text/css"
	href="${bootstrapNfittyHome}css/demo/nifty-demo.min.css"
	rel="stylesheet">
<link
	href="<%=bootstrapNfittyHome%>premium/icon-sets/icons/line-icons/premium-line-icons.min.css"
	rel="stylesheet">
<link
	href="<%=bootstrapNfittyHome%>premium/icon-sets/icons/solid-icons/premium-solid-icons.min.css"
	rel="stylesheet">
<link href="<%=bootstrapNfittyHome%>css/pace.min.css" rel="stylesheet">
<style>
.demo-my-bg {
	background-image: url("<%=bootstrapNfittyHome%>img/balloon.jpg");
}
</style>

<!-- IMPORT JS -->
<script type="text/javascript" src="<%=jqueryJs%>"></script>
<script type="text/javascript" src="<%=bootstrapJs%>"></script>
<script type="text/javascript" src="<%=bootstrapNfittyJs%>"></script>
<script type="text/javascript" src="<%=bootstrapNfittyPaceJs%>"></script>
<script src="<%=bootstrapNfittyHome%>js/pace.min.js"></script>
<script type="text/javascript">
		var bootstrapNfittyHome = "<%=bootstrapNfittyHome%>";
</script>

</head>
<body>
	<div id="container" class="cls-container">
		<tiles:insertAttribute name="contents" ignore="true" />
	</div>
</body>
</html>
