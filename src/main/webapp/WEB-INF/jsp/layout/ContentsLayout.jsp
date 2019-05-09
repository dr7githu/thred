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

<!DOCTYPE HTML>
<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta http-equiv="X-UA-Compatible" content="IE=edge">

<title><tiles:insertAttribute name="title" ignore="true" /></title>

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
<script type="text/javascript" src="<%=bootstrapNfittyHome%>plugins/gauge-js/gauge.min.js"></script>
<script type="text/javascript" src="<%=jqueryJs%>"></script>
<script type="text/javascript" src="<%=bootstrapJs%>"></script>
<script type="text/javascript" src="<%=bootstrapNfittyJs%>"></script>
<script type="text/javascript" src="<%=bootstrapNfittyPaceJs%>"></script>
<%-- <script type="text/javascript" src="<%=bootstrapNfittyHome%>js/demo/nifty-demo.min.js"></script> --%>
<script type="text/javascript" src="<%=bootstrapNfittyHome%>plugins/morris-js/morris.min.js"></script>
<script type="text/javascript" src="<%=bootstrapNfittyHome%>plugins/morris-js/raphael-js/raphael.min.js"></script>
<script type="text/javascript" src="<%=bootstrapNfittyHome%>plugins/flot-charts/jquery.flot.min.js"></script>
<script type="text/javascript" src="<%=bootstrapNfittyHome%>plugins/flot-charts/jquery.flot.resize.min.js"></script>
<script type="text/javascript" src="<%=bootstrapNfittyHome%>plugins/skycons/skycons.min.js"></script>
<script type="text/javascript" src="<%=bootstrapNfittyHome%>plugins/easy-pie-chart/jquery.easypiechart.min.js"></script>
<script type="text/javascript" src="<%=bootstrapNfittyHome%>js/demo/widgets.js"></script>

<script type="text/javascript">
	var bootstrapNfittyHome = "<%=bootstrapNfittyHome%>";
</script>
</head>
<body>
	<!-- START OF CONTAINER -->
	<div id="container" class="effect aside-float aside-bright mainnav-lg">

		<!--Brand logo & name-->
		<!--================================-->
		<div class="navbar-header">
			<a href="index.html" class="navbar-brand"> <img src="<c:out value='${bootstrapNfittyHome}'/>img/logo.png" alt="3 Dimention S" class="brand-icon">
				<div class="brand-title">
					<span class="brand-text">3 Dimention S</span>
				</div>
			</a>
		</div>
		<!--================================-->
		<!--End brand logo & name-->

		<tiles:insertAttribute name="header" ignore="false" />

		<div class="boxed">
			<!--CONTENT CONTAINER-->
			<!--===================================================-->
			<div id="content-container">
				<div id="page-head">

					<!--Page Title-->
					<!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
					<div id="page-title">
						<h1 class="page-header text-overflow">Page Title</h1>
					</div>
					<!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
					<!--End page title-->


					<!--Breadcrumb-->
					<!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
					<ol class="breadcrumb">
						<li><a href="#"> <i class="demo-pli-home"></i>
						</a></li>
						<li class="active">Lv1</li>
						<li class="active">Lv2</li>
					</ol>
					<!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
					<!--End breadcrumb-->

				</div>


				<!--Page content-->
				<!--===================================================-->
				<div id="page-content">
					<tiles:insertAttribute name="contents" ignore="true" />
				</div>
				<!--===================================================-->
				<!--End page content-->
			</div>
			<!--===================================================-->
			<!--END CONTENT CONTAINER-->

			<!-- ASIDE -->
			<!--===================================================-->
			<tiles:insertAttribute name="aside" ignore="true" />
			<!--===================================================-->
			<!-- ASIDE -->

			<!--MAIN NAVIGATION-->
			<!--===================================================-->
			<nav id="mainnav-container">
				<div id="mainnav">


					<!--OPTIONAL : ADD YOUR LOGO TO THE NAVIGATION-->
					<!--It will only appear on small screen devices.-->
					<!--================================
                    <div class="mainnav-brand">
                        <a href="index.html" class="brand">
                            <img src="${bootstrapNfittyHome}img/logo.png" alt="Nifty Logo" class="brand-icon">
                            <span class="brand-text">Nifty</span>
                        </a>
                        <a href="#" class="mainnav-toggle"><i class="pci-cross pci-circle icon-lg"></i></a>
                    </div>
                    -->

					<tiles:insertAttribute name="menu" ignore="true" />
				</div>
			</nav>
			<!--===================================================-->
			<!--END MAIN NAVIGATION-->

			<tiles:insertAttribute name="footer" ignore="true" />
		</div>

		<!-- SCROLL PAGE BUTTON -->
		<!--===================================================-->
		<button class="scroll-top btn">
			<i class="pci-chevron chevron-up"></i>
		</button>
		<!--===================================================-->
	</div>
	<!--===================================================-->
	<!-- END OF CONTAINER -->

</body>
</html>