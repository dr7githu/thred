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


<script src="/skeleton/cmworld3/Utilities/dat.gui.min.js"></script>

<script>
        var cmworld;
        var gui;
        
        var m_FloorLayerName = "floor";
        var volumnOption;
        var Volumn3D;
        var m_ptlist = [];


        var options = function () {
            this.opacity = 0.5;
            this.floodingHeight = 50;
            this.color = "#0000ff";
        };
        
        function SetOption() {
            if (Volumn3D) {
                Volumn3D.material.opacity = volumnOption.opacity
                var color = parseInt(volumnOption.color.replace(/^#/, ''), 16);
                Volumn3D.material.color.setHex(color);
                Volumn3D.material.emissive.setHex(color);
                SetHeight(volumnOption.floodingHeight);
            }
        }
        
        function SetHeight(height) {
            if (m_ptlist.length < 1) return;

            var ptlist = m_ptlist; //이전에 scale이 이미 곱해져 있음.
            var scale = 10000.0;
            var earthRadius = CMWORLD.cm_const.EarthRadius;
            var origin = CMWORLD.CmMathEngine.Geo2Cartesian(ptlist[0].x / scale, ptlist[0].y / scale, ptlist[0].z + earthRadius);

            var shape = new THREE.Shape(ptlist);
            var extrudeSettings = { amount: height, bevelEnabled: false, bevelSegments: 2, steps: 1, bevelSize: 1, bevelThickness: 1 };

            var basegeo = new THREE.ExtrudeGeometry(shape, extrudeSettings);

            var pt;
            for (var i = 0; i < basegeo.vertices.length; i++) {
                pt = CMWORLD.CmMathEngine.Geo2Cartesian(basegeo.vertices[i].x / scale, basegeo.vertices[i].y / scale, basegeo.vertices[i].z + earthRadius);
                
                Volumn3D.geometry.vertices[i].x = pt.x - origin.x;
                Volumn3D.geometry.vertices[i].y = pt.y - origin.y;
                Volumn3D.geometry.vertices[i].z = pt.z - origin.z;
            }

            Volumn3D.geometry.verticesNeedUpdate = true;
        }

        function MakeVolumn(ptlist) {
            var scale = 10000.0;
            var earthRadius = CMWORLD.cm_const.EarthRadius;
            var origin = CMWORLD.CmMathEngine.Geo2Cartesian(ptlist[0].x, ptlist[0].y, ptlist[0].z + earthRadius);

            for (var i = 0; i < ptlist.length; i++) {
                ptlist[i].x *= scale;
                ptlist[i].y *= scale;
            }

            var clr = 0x0000ff;
            var height = 70;

            if (volumnOption) {
                clr = parseInt(volumnOption.color.replace(/^#/, ''), 16);
                height = volumnOption.floodingHeight;
            }

            var shape = new THREE.Shape(ptlist);
            var extrudeSettings = { amount: height, bevelEnabled: false, bevelSegments: 2, steps: 1, bevelSize: 1, bevelThickness: 1 };

            var basegeo = new THREE.ExtrudeGeometry(shape, extrudeSettings);

            var pt;
            for (var i = 0; i < basegeo.vertices.length; i++) {
                pt = CMWORLD.CmMathEngine.Geo2Cartesian(basegeo.vertices[i].x / scale, basegeo.vertices[i].y / scale, basegeo.vertices[i].z + earthRadius);

                basegeo.vertices[i].x = pt.x - origin.x;
                basegeo.vertices[i].y = pt.y - origin.y;
                basegeo.vertices[i].z = pt.z - origin.z;
            }

            Volumn3D = new THREE.Mesh(basegeo, new THREE.MeshToonMaterial({ color: clr, emissive: clr }));
            
            Volumn3D.material.transparent = true;
            Volumn3D.material.opacity = 0.5;
            
            var obj = new CMWORLD.UserObject("floor", Volumn3D, new THREE.Vector3(ptlist[0].x / scale, ptlist[0].y / scale, 0));
            
            var userLayer = getUserLayer(m_FloorLayerName);
            userLayer.add(obj);
        }

        function getUserLayer(layerName) {
            var layer = cmworld.getLayer(layerName);
            if (layer) {
                return layer;
            }

            // 없으면 만들어서 추가한다.
            var userLayer = new CMWORLD.UserObjectLayer(layerName);
            cmworld.addLayer(userLayer);
            return userLayer;
        }

        window.onload = function () {
            var canvas = document.querySelector("#cmworldCanvas");

            cmworld = new CMWORLD.CmWorld3(canvas, 127, 38, CMWORLD.cm_const.EarthRadius * 2.5, { toptilespan: 36 });
            
    		cmworld.setWindowResizeCallback(function ()	{
    			// canvas의 좌상단 기준으로 canvas의 크기를 계산해서 넣어줘야 한다.
    			var gap = 0;
    			var width = window.innerWidth - 100 - gap;
    			var height = window.innerHeight - 330 - gap;
    			return { width: width, height: height };
    		});
    		
            cmworld.option.worldTimer.setStartDateTime(2015, 7, 12, 14, 0, 0, 0);
            
            cmworld.addTileImageLayer("base", "http://xdworld.vworld.kr:8080/XDServer/requestLayerNode?APIKey=767B7ADF-10BA-3D86-AB7E-02816B5B92E9&Layer=tile_mo_HD&Level={z}&IDX={x}&IDY={y}", 0, 15, 90, -90, -180, 180, "jpg", false);
            cmworld.addTerrainLayer("terrain", "http://xdworld.vworld.kr:8080/XDServer/requestLayerNode?APIKey=767B7ADF-10BA-3D86-AB7E-02816B5B92E9&Layer=dem&Level={z}&IDX={x}&IDY={y}", 0, 15, 90, -90, -180, 180, "");

            cmworld.addReal3DLayer("facility_build", "http://xdworld.vworld.kr:8080/XDServer/requestLayerNode?Layer=facility_build&Level={z}&IDX={x}&IDY={y}&APIKey=767B7ADF-10BA-3D86-AB7E-02816B5B92E9",
                "http://xdworld.vworld.kr:8080/XDServer/requestLayerObject?APIKey=767B7ADF-10BA-3D86-AB7E-02816B5B92E9&Layer=facility_build&Level={z}&IDX={x}&IDY={y}&DataFile={f}", "facility_build", 0, 15, 90, -90, -180, 180, "dat");

            var eye_x = 126.873;
            var eye_y = 37.495;
            var eye_h = 1400;
            var look_x = 126.87109037612153;
            var look_y = 37.50091923499337;
            var look_h = 50;


            var agt = navigator.userAgent.toLowerCase();
            if (agt.indexOf("trident") > 0) { //IE 경우
                cmworld.gotoLookAt(look_x, look_y, 2500, look_x, look_y, 50);
            } else {
                cmworld.gotoLookAt(eye_x, eye_y, eye_h, look_x, look_y, look_h);
            }

            volumnOption = new options();

            gui = new dat.GUI();
            gui.add(volumnOption, 'opacity', 0, 1.0).onChange(SetOption);
            gui.add(volumnOption, 'floodingHeight', 0, 70).onChange(SetOption);
            gui.addColor(volumnOption, 'color').onChange(SetOption);

            gui.open();

            gui.domElement.parentElement.style.zIndex = 10000;

            m_ptlist.push({ x: 126.87126385502455, y: 37.51085388130343, z: 0 });
            m_ptlist.push({ x: 126.86831394754071, y: 37.50605724612568, z: 0 });
            m_ptlist.push({ x: 126.86684541141935, y: 37.50072997343536, z: 0 });
            m_ptlist.push({ x: 126.86675593221260, y: 37.49678349689347, z: 0 });
            m_ptlist.push({ x: 126.86857197735128, y: 37.49018277977640, z: 0 });
            m_ptlist.push({ x: 126.87410198191692, y: 37.49013446266565, z: 0 });
            m_ptlist.push({ x: 126.87254557125800, y: 37.49703052158998, z: 0 });
            m_ptlist.push({ x: 126.87301987234820, y: 37.49954011169555, z: 0 });
            m_ptlist.push({ x: 126.87568275758409, y: 37.50636756854979, z: 0 });
            m_ptlist.push({ x: 126.87804955601680, y: 37.51020810449385, z: 0 });
            m_ptlist.push({ x: 126.87243930866391, y: 37.51296345846592, z: 0 });
            
            MakeVolumn(m_ptlist);
        };

</script>

<div class="row">
	<div class="col-lg-10">
		<div class="panel pad-all">
			<!-- 
	<div class="panel-heading">
		<h3 class="panel-title">Load CM World</h3>
	</div>
	 -->
			<!--Panel body-->
			<div class="panel-body">
				<div class="row" style="overflow: hidden">
					<div class="pad-right">
						<canvas id="cmworldCanvas"></canvas>
					</div>
				</div>
			</div>
		</div>
	</div>

	<div class="col-lg-2">
		<div class="row">
			<div class="col-sm-12 col-lg-12">

				<!--Sparkline Area Chart-->
				<div class="panel panel-success panel-colorful">
					<div class="pad-all">
						<p class="text-lg text-semibold">
							<i class="wi wi-rain icon-fw"></i> 강수량
						</p>
						<p class="mar-no">
							<span class="pull-right text-bold">132㎜</span> Total Precipitation
						</p>
						<p class="mar-no">
							<span class="pull-right text-bold">1.45㎜</span> Hourly Precipitation
						</p>
					</div>
					<div class="pad-all">
						<p class="text-semibold text-uppercase text-main">Tips</p>
						<p class="text-muted mar-top">일간 8회 3시간 간격</p>
					</div>
					<div class="pad-top text-center">
						<!--Placeholder-->
						<div id="demo-sparkline-area" class="sparklines-full-content"></div>
					</div>
				</div>
				
			</div>
		</div>
		<div class="row">
		
			<div class="col-sm-6 col-lg-6">

				<!--Sparkline Line Chart-->
				<div class="panel panel-info panel-colorful">
					<div class="pad-all">
						<p class="text-lg text-semibold">풍속</p>
						<p class="mar-no">
							<span class="pull-right text-bold">$764</span> Today
						</p>
						<p class="mar-no">
							<span class="pull-right text-bold">$1,332</span> Last 7 Day
						</p>
					</div>
					<div class="pad-top text-center">

						<!--Placeholder-->
						<div id="demo-sparkline-line" class="sparklines-full-content"></div>

					</div>
				</div>
			</div>
			<div class="col-sm-6 col-lg-6">

				<!--Sparkline bar chart -->
				<div class="panel panel-purple panel-colorful">
					<div class="pad-all">
						<p class="text-lg text-semibold">
							<i class="demo-pli-basket-coins icon-fw"></i> 대기확산지수
						</p>
						<p class="mar-no">
							<span class="pull-right text-bold">$764</span> Today
						</p>
						<p class="mar-no">
							<span class="pull-right text-bold">$1,332</span> Last 7 Day
						</p>
					</div>
					<div class="text-center">

						<!--Placeholder-->
						<div id="demo-sparkline-bar" class="box-inline"></div>

					</div>
				</div>
			</div>
		</div>
		<div class="row">
			<div class="col-sm-12 col-lg-12">

				<!--Sparkline pie chart -->
				<div class="panel panel-warning panel-colorful">
					<div class="pad-all">
						<p class="text-lg text-semibold">Task Progress</p>
						<p class="mar-no">
							<span class="pull-right text-bold">34</span> Completed
						</p>
						<p class="mar-no">
							<span class="pull-right text-bold">79</span> Total
						</p>
					</div>
					<div class="pad-all">
						<div class="pad-btm">
							<div class="progress progress-sm">
								<div style="width: 45%;" class="progress-bar progress-bar-light">
									<span class="sr-only">45%</span>
								</div>
							</div>
						</div>
						<div class="pad-btm">
							<div class="progress progress-sm">
								<div style="width: 89%;" class="progress-bar progress-bar-light">
									<span class="sr-only">89%</span>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>

	</div>
</div>