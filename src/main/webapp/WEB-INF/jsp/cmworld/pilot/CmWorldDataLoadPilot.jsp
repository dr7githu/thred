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
	var gui;

	var colorindex = 0;
	var UserLayer;

	onupdateobject = function() {
	}

	WalkingMode = function(walkingmode) {
		cmworld.setWalkingMode(walkingmode);
	}

	InitializeView = function() {
		var eye_x = 127.02762574045866;
		var eye_y = 37.497958562411924;
		var eye_h = 257;
		var look_x = 127.02862574045866;
		var look_y = 37.497858562411924;
		var look_h = 150;

		cmworld.gotoLookAt(eye_x, eye_y, eye_h, look_x, look_y, look_h);
	}

	example = function() {
		InitializeView();

		// 객체를 만들어서 테스트 해보자.

		var geometry = new THREE.PlaneGeometry(10, 10);
		if (geometry.boundingSphere == null)
			geometry.computeBoundingSphere();

		var material = new THREE.MeshBasicMaterial({
			color : 0xffff00,
			side : THREE.DoubleSide
		});
		var plane = new THREE.Mesh(geometry, material);
		plane.position.set(0, -1, 7);
		plane.rotateX(-5.0 * CMWORLD.cm_const.Deg2Rad);
		plane.updateMatrix();
		plane.updateMatrixWorld();

		plane.visible = true;
		var sphere = new THREE.Sphere(new THREE.Vector3(0, 0, 10), 5);

		var ret = CMWORLD.CameraUtil.collionCheck(sphere, [ plane ]);
		console.log(ret);
	}

	window.onload = function() {
		var canvas = document.querySelector("#cmworldCanvas");

		cmworld = new CMWORLD.CmWorld3(canvas, 127, 38,
				CMWORLD.cm_const.EarthRadius, {
					toptilespan : 36
				});
		cmworld.option.worldTimer.setStartDateTime(2015, 7, 12, 14, 0, 0, 0);

		cmworld
				.addTileImageLayer(
						"base",
						"http://xdworld.vworld.kr:8080/XDServer/requestLayerNode?APIKey=767B7ADF-10BA-3D86-AB7E-02816B5B92E9&Layer=tile_mo_HD&Level={z}&IDX={x}&IDY={y}",
						0, 15, 90, -90, -180, 180, "jpg", false);
		cmworld
				.addTerrainLayer(
						"terrain",
						"http://xdworld.vworld.kr:8080/XDServer/requestLayerNode?APIKey=767B7ADF-10BA-3D86-AB7E-02816B5B92E9&Layer=dem&Level={z}&IDX={x}&IDY={y}",
						0, 15, 90, -90, -180, 180, "");

		cmworld
				.addReal3DLayer(
						"facility_build",
						"http://xdworld.vworld.kr:8080/XDServer/requestLayerNode?Layer=facility_build&Level={z}&IDX={x}&IDY={y}&APIKey=767B7ADF-10BA-3D86-AB7E-02816B5B92E9",
						"http://xdworld.vworld.kr:8080/XDServer/requestLayerObject?APIKey=767B7ADF-10BA-3D86-AB7E-02816B5B92E9&Layer=facility_build&Level={z}&IDX={x}&IDY={y}&DataFile={f}",
						"facility_build", 0, 15, 90, -90, -180, 180, "dat");

		cmworld.option.showFPS(true);

		example();
	};
</script>
<div class="row">
<%-- 	<div class="panel">
		<div class="panel-heading">
			<h3 class="panel-title">Walking Mode</h3>
		</div>

		<!--Panel body-->
		<div class="panel-body">
			<div class="row">
				<div class="col-lg-6 text-xs">
					이동: 키보드 방향키<br> 방향전환: 마우스 버튼누르고 회전<br>
				</div>
				<div class="col-lg-6 text-right">
					<button class="btn btn-success" onclick="WalkingMode(true);">Walking Mode On</button>
					<button class="btn btn-mint" onclick="WalkingMode(false);">Walking Mode Off</button>
				</div>
			</div>
			<div class="row">
				<div class="row" style="overflow: hidden">
					<div class="pad-right">

						<canvas id="cmworldCanvas" class="col-lg-5 mar-ver"></canvas>
					</div>
				</div>
			</div>

		</div>
	</div>
</div> --%>

<div class="panel pad-all">
	<div class="panel-heading">
		<h3 class="panel-title">Walking Mode</h3>
	</div>
	<!--Panel body-->
	<div class="panel-body">
		<div class="row" style="overflow: hidden">
			<div class="row">
				<div class="col-lg-6 text-xs">
					이동: 키보드 방향키<br> 방향전환: 마우스 버튼누르고 회전<br>
				</div>
				<div class="col-lg-6 text-right">
					<button class="btn btn-success" onclick="WalkingMode(true);">Walking Mode On</button>
					<button class="btn btn-mint" onclick="WalkingMode(false);">Walking Mode Off</button>
				</div>
			</div>
		</div>
		<div class="row mar-top" style="overflow: hidden">
			<div class="pad-right">
				<canvas id="cmworldCanvas"></canvas>
			</div>
		</div>
	</div>
</div>

