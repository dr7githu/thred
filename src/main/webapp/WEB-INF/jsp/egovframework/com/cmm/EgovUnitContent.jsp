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

<!DOCTYPE html>
<html lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><spring:message code="comCmm.unitContent.1"/></title>
</head>
<body>
	<hr class="new-section-sm bord-no">
	<div class="row">
		<div class="col-lg-8 col-lg-offset-2">
			<div class="panel panel-body text-center">
				<div class="panel-heading">
					<h3>
						3차원 입체격자체계 기반 국토 통합관리 지원 기술 개발
						<%-- <c:if test="${loginVO != null}">
								${loginVO.name }<spring:message code="comCmm.unitContent.2" />
							<a href="${pageContext.request.contextPath }/uat/uia/actionLogout.do"><spring:message code="comCmm.unitContent.3" /></a>
						</c:if>
						<c:if test="${loginVO == null }">
							<jsp:forward page="/uat/uia/egovLoginUsr.do" />
						</c:if> --%>
						<br />
					</h3>
				</div>

				<div class="panel-body">
					<div class="bord-no text-lg-left mar-top">
						<p>
							<b><img src="${pageContext.request.contextPath }/images/egovframework/com/cmm/icon/tit_icon.png"> 연구개발 목표</b>
							<p /><!-- 화면 설명 -->
							본 연구는 3차원 입체격자체계 기반 연구, 3차원 입체격자체계 핵심기술개발, 3차원 입체격자 통합운영 지원 기술 개발 및 실증서비스 연구를 수행함으로써 최종적으로 미래 지능사회 지원을 위한 새로운 패러다임의 3차원 입체격자체계 기반 국토 공간 통합관리 원천기술을 개발하는 것을 목표로 함.
							<p />
							<!-- 왼쪽 메뉴는 메뉴와 관련된 컴포넌트(메뉴관리, 사이트맵 등)들의 영향을 받지 않으며, -->
							<spring:message code="comCmm.unitContent.7" />
							<p />
							<!-- 각 컴포넌트를 쉽게 찾아볼 수 있는 바로 가기 링크페이지입니다. -->
						</p>
					</div>
					<div class="bord-no text-lg-left mar-top">
						<b><img src="${pageContext.request.contextPath }/images/egovframework/com/cmm/icon/tit_icon.png"> 연구개발 내용</b>
						<p />
						3차원 입체격자체계 기반 국토 통합관리 지원 기술 개발은 총 3차년도 연구로 진행되며, 주요 연구개발 내용은 다움과 같음
						<p />
						<br />
						3차원 입체격자 활용방안 및 실증서비스 연구
						<ul>
							<li>3차원 입체격자 타장성 연구, 3차원 입체격자 제도개선(안) 연구를 통해 실용화 방안 제시, 3차원 입체격자를 활용하는 실증서비스 발굴을 통해 다양한 서비스 모델 제시</li>
						</ul>
						3차원 입체격자체계 데이터 연계 기술개발
						<ul>
							<li>다중 공간정보 관련기관에서 활용 중인 정보를 DB to DB, TCP, 오프라인 등을 통해 수집하여 연계할 수 있는 모듈 개발, 실시간 생성되는 정보를 3차원 입체격자체계에 맞춰 갱신할 수 있는 모듈 개발</li>
						</ul>						
						3차원 입체격자체계 활용을 위한 통합운영 기술 개발
						<ul>
							<li>3차원 입체격자 가시화 기술, 공간 속성정보 조회 기술 등을 통해 다양한 정보를 3차원 입체격자를 기반으로 활용할 수 있는 핵심 기술 개발</li>
							<li>개발 성과물은 3차원 입체격자 기술을 용용하는 실증서비스 연구에서 연계·활용</li>
						</ul>
				</div>
				</div>
			</div>
		</div>
	</div>
</body>
</html>