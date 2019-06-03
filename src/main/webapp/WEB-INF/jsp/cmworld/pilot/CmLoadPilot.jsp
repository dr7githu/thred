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

<script type="text/javascript">
	var cmworld;
	
	window.onload = function() {
		var canvas = document.querySelector("#cmworldCanvas");
		
		cmworld = new CMWORLD.CmWorld3(canvas, 127, 38,	CMWORLD.cm_const.EarthRadius);
		
		cmworld.setWindowResizeCallback(function ()	{
			// canvas의 좌상단 기준으로 canvas의 크기를 계산해서 넣어줘야 한다.
			var gap = 0;
			var width = window.innerWidth - 100 - gap;
			var height = window.innerHeight - 300 - gap;
			return { width: width, height: height };
		});
		
		loop();
		
		function loop() {
			requestAnimationFrame(loop);
			cmworld.update();
		}
	};
</script>

<div class="panel pad-all">
	<div class="panel-heading">
		<h3 class="panel-title">Load CM World</h3>
	</div>
	<!--Panel body-->
	<div class="panel-body">
		<div class="row" style="overflow: hidden">
			<div class="pad-right">
				<canvas id="cmworldCanvas"></canvas>
			</div>
		</div>
	</div>
</div>