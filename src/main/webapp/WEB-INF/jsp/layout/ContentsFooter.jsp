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
<!-- FOOTER -->
<!--===================================================-->
<footer id="footer">

	<!-- Visible when footer positions are fixed -->
	<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<div class="show-fixed pad-rgt pull-right">
		You have
		<a href="#" class="text-main">
			<span class="badge badge-danger">3</span> pending action.
		</a>
	</div>



	<!-- Visible when footer positions are static -->
	<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<div class="hide-fixed pull-right pad-rgt">
		<c:out value="${pageContext.session.id}"/> : <strong><c:out value="${pageContext.session.creationTime}"/></strong>.
	</div>



	<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<!-- Remove the class "show-fixed" and "hide-fixed" to make the content always appears. -->
	<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

	<p class="pad-lft">&#0169; 2019 Podo.inc</p>



</footer>
<!--===================================================-->
<!-- END FOOTER -->>
