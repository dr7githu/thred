<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.com.cmm.service.EgovProperties"%>
<%@ page import="egovframework.com.cmm.LoginVO"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<!DOCTYPE html>
<html lang="ko">
<body>
	<div id="bg-overlay" class="bg-img" style="background-image: url(<c:out value='${bootstrapNfittyHome}'/>img/bg-img-3.jpg)"></div>


	<div class="cls-content mar-all">
		<div class="cls-content-lg panel">

			<div class="panel-body">
				<div class="mar-ver pad-btm">
					<h1 class="h3">3차원 입체격자체계 기반 국토 통합관리 실증서비스 모듈 설계</h1>
					<p>Design of Integrated National Land Management Demonstration Service Module based on 3 Dimensional Geo-Spatial grid system</p>
				</div>
				<div class="mar-ver pad-btm">
					<div class="mar-all">
						<img src="/images/comm/3d_256px.png" alt="3D Grid system">
					</div>
				</div>
			</div>

			<div class="pad-all">
				<a href="#" class="btn-link mar-rgt"><spring:message code="comUatUia.loginForm.idPwSearch" /></a> 
				<a href="#" class="btn-link mar-lft"><spring:message code="comUatUia.loginForm.regist" /></a>

				<div class="media pad-top bord-top">
					<div class="pull-right">
						<a href="#" class="pad-rgt"><i class="psi-facebook icon-lg text-primary"></i></a> 
						<a href="#" class="pad-rgt"><i class="psi-twitter icon-lg text-info"></i></a> 
						<a href="#" class="pad-rgt"><i class="psi-google-plus icon-lg text-danger"></i></a>
					</div>
					<div class="media-body text-left text-bold text-main">
						<a href="/uat/uia/actionLogin.do" class="pad-rgt">Login</a>
					</div>
				</div>
			</div>
		</div>
	</div>
</body>
</html>