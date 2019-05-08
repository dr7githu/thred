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
						<c:if test="${loginVO != null}">
								${loginVO.name }<spring:message code="comCmm.unitContent.2" />
							<a href="${pageContext.request.contextPath }/uat/uia/actionLogout.do"><spring:message code="comCmm.unitContent.3" /></a>
						</c:if>
						<c:if test="${loginVO == null }">
							<jsp:forward page="/uat/uia/egovLoginUsr.do" />
						</c:if>
						<br />
					</h3>
				</div>

				<div class="panel-body">
					<div class="bord-all text-lg-left">
						<b><spring:message code="comCmm.unitContent.4" /><br />
						<br />
						<!-- 실행 시 오류 사항이 있으시면 표준프레임워크센터로 연락하시기 바랍니다. -->
					</div>
					<div class="bord-all text-lg-left">
						<p>
							<b><img src="${pageContext.request.contextPath }/images/egovframework/com/cmm/icon/tit_icon.png"> <spring:message code="comCmm.unitContent.5" /></b>
							<p /><!-- 화면 설명 -->
							<spring:message code="comCmm.unitContent.6" />
						<p />
						<!-- 왼쪽 메뉴는 메뉴와 관련된 컴포넌트(메뉴관리, 사이트맵 등)들의 영향을 받지 않으며, -->
						<spring:message code="comCmm.unitContent.7" />
						<p />
						<!-- 각 컴포넌트를 쉽게 찾아볼 수 있는 바로 가기 링크페이지입니다. -->
						</p>
					</div>
					<div class="bord-all text-lg-left">
						<p>
							<b><img src="${pageContext.request.contextPath }/images/egovframework/com/cmm/icon/tit_icon.png"> egovframework.com.cmm.web.EgovComIndexController.java</b>
						<p />

						<spring:message code="comCmm.unitContent.8" />
						<p />
						<!-- 컴포넌트 설치 후 설치된 컴포넌트들을 IncludedInfo annotation을 통해 찾아낸 후 -->
						<spring:message code="comCmm.unitContent.9" />
						<p />
						<br />
						<!-- 화면에 표시할 정보를 처리하는 Controller 클래스입니다. -->
						<spring:message code="comCmm.unitContent.10" />
						<p />
						<!-- 개발 시 메뉴 구조가 잡히기 전에 배포 파일들에 포함된 공통 컴포넌트들의 목록성 화면에 URL을 제공하여 -->
						<spring:message code="comCmm.unitContent.11" />
						<p />
						<!-- 개발자가 편리하게 활용할 수 있도록 작성되었습니다. -->
						<spring:message code="comCmm.unitContent.12" />
						<p />
						<!-- 운영 시에 본 컨트롤을 사용하여 메뉴를 구성하는 경우, -->
						<spring:message code="comCmm.unitContent.13" />
						<p />
						<!-- 성능 문제를 일으키거나 사용자별 메뉴 구성에 오류를 발생할 수 있기 때문에 -->
						<spring:message code="comCmm.unitContent.14" />
						<p />
						<!-- 실 운영 시에는 삭제해서 배포하는 것을 권장해 드립니다. -->
						</p>
					</div>
				</div>
			</div>
		</div>
	</div>
</body>
</html>