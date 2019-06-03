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

<script type="text/javascript" src="/skeleton/three/examples/js/libs/dat.gui.min.js"></script>

<script type="text/javascript">
	var cmworld;
	var gui;
	var userLayer;
	var userObj;
	var animatepass;
	var flypass;
	var animaterunning = false;
	var flyrunning = false;
	var flyrunningWithCamera = false;
	var runningtime = 0;
	var flyrunningtime = 0;
	var flyrunningCameraPosition;
	var oldMode = false;

	var terrainEnabled = true;
	var buildingEnabled = true;
	var subwayEnabled = true;
	var pipeEnabled = true;
	var clippingcenter = null;
	var flycenter = null;

	var undergroundCubeLayer;
	var vectorlayer;
	var flyCubeLayer;

	loadPipeline = function() {
		//var filename = ".//model//GangnamPipe//GangnamPipe.obj";
		//var mtlname = ".//model//GangnamPipe//GangnamPipe.mtl";

		//var filename = "./model/GangnamPipe/GangnamPipe01.obj";
		//var mtlname = "./model/GangnamPipe/GangnamPipe01.mtl";

		var filename = "/skeleton/cmworld3/model/Drone-MQ27/MQ-27.obj";
		var mtlname = "/skeleton/cmworld3/model/Drone-MQ27/MQ-27.mtl";

		var loader = new THREE.OBJLoader();
		loader.load(filename, function(object) {

			//var origin = new THREE.Vector3(127.0243307481833, 37.49700125656423, 150);
			var origin = new THREE.Vector3(127.02433, 37.4950, -10);

			var obj = new CMWORLD.UserObject("pipeline", object, origin);
			obj.clipApply = false;
			obj.rotate4GlobeEarth();
			//obj.object.rotateZ(-90 * CMWORLD.cm_const.Deg2Rad);
			obj.object.rotateX(-90 * CMWORLD.cm_const.Deg2Rad);
			obj.object.rotateY(-20 * CMWORLD.cm_const.Deg2Rad);

			obj.object.traverse(function(child) {
				if (child instanceof THREE.Mesh) {

					child.geometry.computeVertexNormals();

					var r = Math.random() * 2;
					r = Math.round(r);

					if (r == 0.0) {
						child.material.emissive.setHex(0x00FF00);
						child.material.color.setHex(0x00FF00);
					} else if (r == 1.0) {
						child.material.emissive.setHex(0x0000FF);
						child.material.color.setHex(0x00FF00);
					} else {
						child.material.emissive.setHex(0xFF0000);
						child.material.color.setHex(0x00FF00);
					}

					CMWORLD.Material.addClippingAttri(child.material);
				}
			});

			//computeNormal(obj.object);
			userLayer.add(obj);
		});
	}

	loadgangnam = function() {
		var siteRootFolder = CMWORLD.Compile.getSiteRootUrl();

		var onLoad3dsfinished = function(name, url, meshArray) {

			if (meshArray == null)
				return;

			var B1Bottom = 9;
			var B2Bottom = 5;
			var FloorHeight = 3;

			var alt = 0;
			if (url != null) {

				if (url.indexOf("AF01_CL.3DS") > 0) {
					alt = 17;
				} else if (url.indexOf("AF01_FC.3DS") > 0) {
					alt = 17;
				} else if (url.indexOf("AB01_AB02.3DS") > 0) {
					// 1,2층 계단.
					alt = B2Bottom;
				} else if (url.indexOf("AB01_AF01.3DS") > 0) {
					// 출입구에서 내려오는 계단.
					alt = B1Bottom + 0.5;
				} else if (url.indexOf("AB01_CL.3DS") > 0) {
					alt = B1Bottom + FloorHeight;
				} else if (url.indexOf("AB01_FC.3DS") > 0) {
					alt = B1Bottom - 0.2;
				} else if (url.indexOf("AB01_FL.3DS") > 0) {
					// 출입구에서 내려오는 계단 손잡이 벽.
					alt = B1Bottom - 0.4;
				} else if (url.indexOf("AB01_WL.3DS") > 0) {
					alt = B1Bottom;
				} else if (url.indexOf("AB02_CL.3DS") > 0) {
					// 천장.
					alt = B2Bottom + FloorHeight;
				} else if (url.indexOf("AB02_FC.3DS") > 0) {
					// 지하철 타는곳의 자판기 소화전 같은 시설물
					alt = B2Bottom;
				} else if (url.indexOf("AB02_FL.3DS") > 0) {
					// 바닥.
					alt = B2Bottom;
				} else if (url.indexOf("AB02_WL.3DS") > 0) {
					// 벽
					alt = B2Bottom;
				}
			}

			for (var i = 0; i < meshArray.length; i++) {

				var mesh = meshArray[i];
				var lon = 127.0278005279;
				var lat = 37.4979705289;

				// vworld 모델 데이터 기준으로 지구 중심축 방향으로 세웠다.
				var quaternionX = new THREE.Quaternion();
				var quaternionY = new THREE.Quaternion();

				// 좌표의 시작이 -Z축부터 CCW 방향으로 돈다.
				quaternionY.setFromAxisAngle(new THREE.Vector3(0, 1, 0),
						-(180 - lon) * CMWORLD.CmMathEngine.Deg2Rad);
				quaternionX.setFromAxisAngle(new THREE.Vector3(1, 0, 0), -lat
						* CMWORLD.CmMathEngine.Deg2Rad);
				var quaternion_Rotate = THREE.Quaternion.prototype
						.multiplyQuaternions(quaternionY, quaternionX);
				mesh.quaternion.copy(quaternion_Rotate);

				{
					var material = null;
					var fileurl = null;
					{
						if (mesh.material.type == 'MultiMaterial') {
							material = mesh.material.materials[0];
						} else {
							material = mesh.material;
						}

						var imageName = material.imageName;
						fileurl = siteRootFolder + "/model/gangnam_station/"
								+ imageName;
						var loader = new THREE.TextureLoader();
						loader.setCrossOrigin("Anonymous");
						var tex = loader.load(fileurl);

						tex.minFilter = THREE.LinearFilter;
						tex.needUpdate = true;
						tex.imageName = material.imageName;
						// 맨처음에는 0부터 시작이다.
						//tex.level = 0;
						// 가지고 있는 가장 높은 레벨을 기록한다.
						// 모르면, 가장 높을것 같은 수치.
						//tex.endlevel = 10;

						var mat = new THREE.MeshPhongMaterial({
							map : tex,
							specular : 0,
							shininess : 0
						});
						mat.needsUpdate = true;
						mat.side = THREE.DoubleSide;

						mat["clippingPlanes"] = cmworld.clipBox.localPlanes;
						mat["clipIntersection"] = cmworld.clipBox.clipIntersection;
						mesh.material = mat;
					}
				}

				mesh.onBeforeRender = function(renderer, scene, camera,
						geometry, material, group) {

				}
				var obj = new CMWORLD.UserObject("subway", mesh,
						new THREE.Vector3(lon, lat, alt), null);
				userLayer.add(obj);
			}
		};

		var modelresoucrFolder = "/model/";
		//CMWORLD.CmWorld3.load3DS(siteRootFolder + modelresoucrFolder + "GN1_486.3ds", siteRootFolder + modelresoucrFolder, onLoad3dsfinished);

		// 강남 좌표x
		var modelresoucrFolder = "/model/gangnam_station/";
		var model;
		var lon = 127.0278005279;
		var lat = 37.4979705289;

		CMWORLD.CmWorld3.load3DS(siteRootFolder + modelresoucrFolder
				+ "AB01_AB02.3DS", siteRootFolder + modelresoucrFolder,
				onLoad3dsfinished);
		CMWORLD.CmWorld3.load3DS(siteRootFolder + modelresoucrFolder
				+ "AB01_AF01.3DS", siteRootFolder + modelresoucrFolder,
				onLoad3dsfinished);
		CMWORLD.CmWorld3.load3DS(siteRootFolder + modelresoucrFolder
				+ "AB01_CL.3DS", siteRootFolder + modelresoucrFolder,
				onLoad3dsfinished);
		//CMWORLD.CmWorld3.load3DS(siteRootFolder + modelresoucrFolder + "AB01_FC.3DS", siteRootFolder + modelresoucrFolder, onLoad3dsfinished);
		CMWORLD.CmWorld3.load3DS(siteRootFolder + modelresoucrFolder
				+ "AB01_FL.3DS", siteRootFolder + modelresoucrFolder,
				onLoad3dsfinished);
		CMWORLD.CmWorld3.load3DS(siteRootFolder + modelresoucrFolder
				+ "AB01_WL.3DS", siteRootFolder + modelresoucrFolder,
				onLoad3dsfinished);
		CMWORLD.CmWorld3.load3DS(siteRootFolder + modelresoucrFolder
				+ "AB02_CL.3DS", siteRootFolder + modelresoucrFolder,
				onLoad3dsfinished);
		//CMWORLD.CmWorld3.load3DS(siteRootFolder + modelresoucrFolder + "AB02_FC.3DS", siteRootFolder + modelresoucrFolder, onLoad3dsfinished);
		CMWORLD.CmWorld3.load3DS(siteRootFolder + modelresoucrFolder
				+ "AB02_FL.3DS", siteRootFolder + modelresoucrFolder,
				onLoad3dsfinished);
		CMWORLD.CmWorld3.load3DS(siteRootFolder + modelresoucrFolder
				+ "AB02_WL.3DS", siteRootFolder + modelresoucrFolder,
				onLoad3dsfinished);
		CMWORLD.CmWorld3.load3DS(siteRootFolder + modelresoucrFolder
				+ "AF01_CL.3DS", siteRootFolder + modelresoucrFolder,
				onLoad3dsfinished);
		//CMWORLD.CmWorld3.load3DS(siteRootFolder + modelresoucrFolder + "AF01_FC.3DS", siteRootFolder + modelresoucrFolder, onLoad3dsfinished);
	}

	setClipState = function(obj, enabled) {
		if (obj) {
			if (obj instanceof THREE.Object3D) {
				obj
						.traverse(function(child) {
							if (child instanceof THREE.Mesh) {
								var mat = child.material;

								mat["clipping"] = enabled;
								if (enabled == true) {
									mat["clippingPlanes"] = cmworld.clipBox.localPlanes;
									mat["clipIntersection"] = cmworld.clipBox.clipIntersection;
								} else {
									mat["clippingPlanes"] = cmworld.clipBox.hidePlanes;
									mat["clipIntersection"] = cmworld.clipBox.clipIntersection;
								}

								mat.needsUpdate = true;
								child.needsUpdate = true;
							}
						});
			}
		}
	}

	createCube3DLayer = function() {

		undergroundCubeLayer = cmworld
				.addCube3DLayer(
						"underground",
						"http://demo.cmworld.net/cube3d/cbr/{z}/{y}/{x}/{y}_{x}_{f}.cbr",
						0, 14, -10, 10000, 4194304, "raster", "cbr");

		undergroundCubeLayer.renderFrame = true;

		undergroundCubeLayer.pointColors[0] = new THREE.Color(0x47cc00);
		undergroundCubeLayer.pointColors[1] = new THREE.Color(0xeb9600);
		undergroundCubeLayer.pointColors[2] = new THREE.Color(0x3901ad);
		undergroundCubeLayer.pointColors[3] = new THREE.Color(0x47cc00);
		undergroundCubeLayer.pointColors[4] = new THREE.Color(0xeb1100);
		undergroundCubeLayer.pointColors[5] = new THREE.Color(0xeb9600);
		undergroundCubeLayer.pointColors[6] = new THREE.Color(0x3901ad);
		undergroundCubeLayer.pointColors[7] = new THREE.Color(0x47cc00);
		undergroundCubeLayer.pointColors[8] = new THREE.Color(0x6a3b37);
		undergroundCubeLayer.pointColors[9] = new THREE.Color(0x47cc00);
		undergroundCubeLayer.pointColors[10] = new THREE.Color(0xeb1100);
		undergroundCubeLayer.pointColors[11] = new THREE.Color(0xeb9600);
		undergroundCubeLayer.pointColors[12] = new THREE.Color(0x3901ad);
		undergroundCubeLayer.pointColors[13] = new THREE.Color(0x6a3b37);

		undergroundCubeLayer.pointColors[21] = new THREE.Color(0xff0000);
		undergroundCubeLayer.pointColors[22] = new THREE.Color(0x00ff00);
		undergroundCubeLayer.pointColors[23] = new THREE.Color(0x0000ff);
		undergroundCubeLayer.pointColors[24] = new THREE.Color(0xffff00);
		undergroundCubeLayer.pointColors[25] = new THREE.Color(0x00ffff);
		undergroundCubeLayer.pointColors[26] = new THREE.Color(0xff00ff);

		// 사용자 객체를 만들자
		var geo = new THREE.SphereGeometry(1);
		var material = new THREE.MeshBasicMaterial({
			color : 0xff0000
		});
		var mesh = new THREE.Mesh(geo, material);
		mesh.frustumCulled = false;

		clippingcenter = new CMWORLD.UserObject("center", mesh,
				new THREE.Vector3(127.02757826432276, 37.49802454065084,
						13.42819338105619), null);
		userLayer.add(clippingcenter);

		//undergroundCubeLayer.addTargetCamera("camera", 14, 100);
		undergroundCubeLayer.addTargetObject("center", clippingcenter, 13, 5);

		/*
		지표 = 0

		하늘 = 1

		바다 = -2

		땅속 = 21 ~ 26
		 */
	}

	createCube3DLayer2 = function() {
		flyCubeLayer = cmworld
				.addCube3DLayer(
						"fly",
						"http://demo.cmworld.net/cube3d/cbr_vector/{z}/{y}/{x}/{y}_{x}_{f}.cbr",
						0, 14, -10, 100000, 4194304, "vector", "cbr");

		flyCubeLayer.renderFrame = true;
		flyCubeLayer.renderOnlyFrame = true;

		// 사용자 객체를 만들자
		var geo = new THREE.SphereGeometry(10);
		var material = new THREE.MeshBasicMaterial({
			color : 0xff0000
		});
		var mesh = new THREE.Mesh(geo, material);

		flycenter = new CMWORLD.UserObject("fly", mesh, new THREE.Vector3(
				127.02992490492944, 37.49314254229226, 20), null);
		userLayer.add(flycenter);

		//undergroundCubeLayer.addTargetCamera("camera", 14, 100);
		flyCubeLayer.addTargetObject2("fly0", flycenter, 0, 10000,
				new THREE.Color(0, 0, 0.5));
		flyCubeLayer.addTargetObject2("fly1", flycenter, 1, 10000,
				new THREE.Color(0, 0, 0.5));
		flyCubeLayer.addTargetObject2("fly2", flycenter, 2, 10000,
				new THREE.Color(0, 0, 0.5));
		flyCubeLayer.addTargetObject2("fly3", flycenter, 3, 10000,
				new THREE.Color(0, 0, 0.5));
		flyCubeLayer.addTargetObject2("fly4", flycenter, 4, 10000,
				new THREE.Color(0, 0, 0.5));
		flyCubeLayer.addTargetObject2("fly5", flycenter, 5, 10000,
				new THREE.Color(0, 0, 0.5));
		flyCubeLayer.addTargetObject2("fly6", flycenter, 6, 10000,
				new THREE.Color(0, 0, 0.5));
		flyCubeLayer.addTargetObject2("fly7", flycenter, 7, 10000,
				new THREE.Color(0, 0, 0.5));
		flyCubeLayer.addTargetObject2("fly8", flycenter, 8, 10000,
				new THREE.Color(0, 0, 0.5));
		flyCubeLayer.addTargetObject2("fly9", flycenter, 9, 5000,
				new THREE.Color(0, 0, 0.2));
		flyCubeLayer.addTargetObject2("fly10", flycenter, 10, 2000,
				new THREE.Color(0, 0.5, 0.5));
		flyCubeLayer.addTargetObject2("fly11", flycenter, 11, 1280,
				new THREE.Color(0, 0.5, 0.8));
		flyCubeLayer.addTargetObject2("fly12", flycenter, 12, 640,
				new THREE.Color(0, 0.5, 1));
		flyCubeLayer.addTargetObject2("fly13", flycenter, 13, 320,
				new THREE.Color(0.5, 0.5, 0.1));
		flyCubeLayer.addTargetObject2("fly14", flycenter, 14, 160,
				new THREE.Color(0.5, 0.8, 0));
		flyCubeLayer.addTargetObject2("fly15", flycenter, 15, 80,
				new THREE.Color(1, 0.5, 0));
		flyCubeLayer.addTargetObject2("fly16", flycenter, 16, 40,
				new THREE.Color(1, 0.2, 0));
		flyCubeLayer.addTargetObject2("fly17", flycenter, 17, 30,
				new THREE.Color(1, 0, 0));
		flyCubeLayer.addTargetObject2("fly", flycenter, 18, 20,
				new THREE.Color(1, 1, 1));
	}

	window.onload = function() {
		var canvas = document.querySelector("#cmworld3Canvas");

		cmworld = new CMWORLD.CmWorld3(canvas, 127, 38,
				CMWORLD.cm_const.EarthRadius * 2.5, {
					toptilespan : 36
				});
		cmworld.option.worldTimer.setStartDateTime(2015, 7, 12, 14, 0, 0, 0);
		
		cmworld.setWindowResizeCallback(function() {
			var gap = 0;
			var width = window.innerWidth - 100 - gap;
			var height = window.innerHeight = 250 - gap;
			
			return {width: width, height: height };
		});

		// 여기에 transparancy 추가...
		// 투명 값은 여기서 설정
		cmworld.option.terrainTransparency = false;
		cmworld.option.terrainOpacity = 1;

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

		// Opacity를 위한 User Interface 용
		var params = {
			terrain : true,
			building : true,
			subway : true,
			pipeline : true,
			clipIntersection : cmworld.clipBox.clipIntersection,
			animate : animaterunning,
			opacity : 1.0,
			animatefly : flyrunning,
			animateflyWithCamera : flyrunningWithCamera,
			oldMode : false
		};

		gui = new dat.GUI();
		var folder = gui.addFolder("Layer Clipping");

		folder.add(params, 'terrain').onChange(function(v) {
			terrainEnabled = v;
		});
		folder.add(params, 'building').onChange(function(v) {
			buildingEnabled = v;
			var layer = cmworld.getLayer("facility_build");

			if (layer != null) {
				layer.visible = v;
			}

		});
		folder.add(params, 'subway').onChange(function(v) {
			subwayEnabled = v;
			var obj = UserLayer.getObject('subway');
			setClipState(obj.object, v);

		});
		folder.add(params, 'pipeline').onChange(function(v) {
			pipeEnabled = v;

			var obj = UserLayer.getObject('pipeline');
			setClipState(obj.object, v);
		});

		var folder2 = gui.addFolder("Clipping Setting");

		folder2.add(params, 'animate').name('animate clipbox').onChange(
				function(value) {
					animaterunning = value;
					checkAnimate();
				});

		folder2.add(params, 'clipIntersection').name('clip intersection')
				.onChange(function(value) {
					cmworld.clipBox.clipIntersection = value;
				});

		folder2.add(params, 'opacity', 0, 1).name("terrain opacity").onChange(
				function() {
					if (cmworld) {
						cmworld.setTerrainTransparancy(params.opacity);
					}
				});

		var folder3 = gui.addFolder("vector Cube Setting");

		folder3.add(params, 'animatefly').name('fly obj').onChange(
				function(value) {
					flyrunning = value;
					checkFly();
				});

		folder3.add(params, 'animateflyWithCamera').name('with camera')
				.onChange(
						function(value) {
							flyrunningWithCameraPosition = cmworld.getCamera()
									.getPositionGeo();
							flyrunningWithCamera = value;
						});

		folder3
				.add(params, 'oldMode')
				.name('No Volumetric')
				.onChange(
						function(value) {
							oldMode = value;

							if (oldMode == false) {
								flyCubeLayer.targetObject["fly7"].visible = true;
								flyCubeLayer.targetObject["fly8"].visible = true;
								flyCubeLayer.targetObject["fly9"].visible = true;
								flyCubeLayer.targetObject["fly10"].visible = true;
								flyCubeLayer.targetObject["fly11"].visible = true;
								flyCubeLayer.targetObject["fly12"].visible = true;
								flyCubeLayer.targetObject["fly13"].visible = true;
								flyCubeLayer.targetObject["fly14"].visible = true;
								flyCubeLayer.targetObject["fly15"].visible = true;
								flyCubeLayer.targetObject["fly16"].visible = true;
								flyCubeLayer.targetObject["fly17"].visible = true;
								flyCubeLayer.targetObject["fly"].visible = true;
							} else {
								cmworld.gotoLookAt(126.5, 37, 500000,
										127.02992490492944, 37.49314254229226,
										400000);

								var nLevel = 7;

								if (pt.z > 16384)
									nLevel = 8;
								else if (pt.z > 8192)
									nLevel = 9;
								else if (pt.z > 4096)
									nLevel = 10;
								else if (pt.z > 2048)
									nLevel = 11;
								else if (pt.z > 1024)
									nLevel = 12;
								else if (pt.z > 512)
									nLevel = 13;
								else if (pt.z > 256)
									nLevel = 14;
								else if (pt.z > 128)
									nLevel = 15;

								var nScale = 1;
								if (pt.z > 1024)
									nScale = 30;
								flycenter.setScale(nScale, nScale, nScale);

								flyCubeLayer.targetObject["fly"].visible = false;
								for (var i = nLevel; i < 18; i++) {
									flyCubeLayer.targetObject["fly"
											+ i.toString()].visible = false;
								}
							}
						});

		gui.open();

		userLayer = new CMWORLD.UserObjectLayer("lines");
		cmworld.addLayer(userLayer);

		loadPipeline();

		loadgangnam();

		//createCube3DLayer();
		createCube3DLayer2();

		var eye_x = 127.0294353974798;//126.92287806018567;
		var eye_y = 37.493689215013305; //37.52385624604935;
		var startHeight = 10000000;
		var look_x = 127.02992490492944;
		var look_y = 37.49314254229226;
		var endHeight = 50;
		var splitCount = 300;

		var ptList = getSplinePath(eye_x, eye_y, startHeight, look_x, look_y,
				1000000, splitCount);
		Array.prototype.push.apply(ptList, getSplinePath(eye_x, eye_y, 100000,
				look_x, look_y, 1000, 200));

		cmworld.preUpdateEvent.addEventListener(preUpdate, this);

		var cnt = 0;

		function preUpdate(params, owner) {
			if (ptList.length > 1) {
				cmworld.gotoLookAt(ptList[0].x, ptList[0].y, ptList[1].z,
						ptList[1].x, ptList[1].y, endHeight);
				$('#txtLabel').text(
						"현재고도 " + numberWithCommas(ptList[0].z.toFixed(1))
								+ " m");

				// 위의 getSplinePath에서 나온값이 이상해서 따로 계산했다.
				//startHeight = startHeight - stepHeight;

				// 마지막일때.
				if (ptList.length == 2) {
					cmworld.gotoLookAt(eye_x, eye_y, 500, look_x, look_y,
							endHeight);
					$('#txtLabel').text(
							"현재고도 " + numberWithCommas(ptList[0].z.toFixed(1))
									+ " m");
					ptList.shift();
				}
				ptList.shift();
				cnt = cnt + 1;
			}

			if (cmworld.clipBox) {
				if (animaterunning == true) {
					runningtime += 0.0005;
					if (runningtime > 1.0)
						runningtime = 0.0;

					pt = animatepass.getPoint(runningtime);
					// 이게 해당지점

					if (clippingcenter)
						clippingcenter.setPosition(pt.x, pt.y, pt.z);
					cmworld.clipBox.setLocalPosition(pt.y, pt.x, pt.z);
				}
			}

			if (flyrunning == true) {
				flyrunningtime += 0.0005;
				if (flyrunningtime > 1)
					flyrunningtime = 0.0;

				pt = flypass.getPoint(flyrunningtime);
				// 이게 해당지점

				if (flycenter) {
					flycenter.setPosition(pt.x, pt.y, pt.z);
					$('#txtLabel').text(
							"현재고도 " + numberWithCommas(pt.z.toFixed(1)) + " m");

					if (flyrunningWithCamera == true) {
						//cmworld.gotoLookAt(pt.x - 0.1, pt.y, pt.z * 2, 127.02992490492944, 37.49314254229226, 100);

						if (pt.z > 3000)
							cmworld.gotoLookAt(flyrunningWithCameraPosition.x,
									flyrunningWithCameraPosition.y, pt.z * 3,
									pt.x, pt.y, pt.z);
					}

					if (oldMode == true) {
						if (pt.z > 32768)
							flyCubeLayer.targetObject["fly7"].visible = false;
						else if (pt.z > 16384)
							flyCubeLayer.targetObject["fly8"].visible = false;
						else if (pt.z > 8192)
							flyCubeLayer.targetObject["fly9"].visible = false;
						else if (pt.z > 4096)
							flyCubeLayer.targetObject["fly10"].visible = false;
						else if (pt.z > 2048)
							flyCubeLayer.targetObject["fly11"].visible = false;
						else if (pt.z > 1024) {
							flyCubeLayer.targetObject["fly12"].visible = false;
							if (flycenter.getMesh().scale.x < 30)
								flycenter.setScale(30, 30, 30);
						} else if (pt.z > 512)
							flyCubeLayer.targetObject["fly13"].visible = false;
						else if (pt.z > 256)
							flyCubeLayer.targetObject["fly14"].visible = false;
						else if (pt.z > 128) {
							flyCubeLayer.targetObject["fly"].visible = false;
							flyCubeLayer.targetObject["fly17"].visible = false;
							flyCubeLayer.targetObject["fly16"].visible = false;
							flyCubeLayer.targetObject["fly15"].visible = false;
						}

						if (pt.z < 128) {
							flyCubeLayer.targetObject["fly"].visible = true;
							flyCubeLayer.targetObject["fly17"].visible = true;
							flyCubeLayer.targetObject["fly16"].visible = true;
							flyCubeLayer.targetObject["fly15"].visible = true;
						} else if (pt.z < 256)
							flyCubeLayer.targetObject["fly14"].visible = true;
						else if (pt.z < 512) {
							flyCubeLayer.targetObject["fly13"].visible = true;
							if (flycenter.getMesh().scale.x >= 20)
								flycenter.setScale(1, 1, 1);
						} else if (pt.z < 1024) {
							flyCubeLayer.targetObject["fly12"].visible = true;
							if (flycenter.getMesh().scale.x >= 30)
								flycenter.setScale(20, 20, 20);
						} else if (pt.z < 2048)
							flyCubeLayer.targetObject["fly11"].visible = true;
						else if (pt.z < 4096)
							flyCubeLayer.targetObject["fly10"].visible = true;
						else if (pt.z < 8192)
							flyCubeLayer.targetObject["fly9"].visible = true;
						else if (pt.z < 16384)
							flyCubeLayer.targetObject["fly8"].visible = true;
						else if (pt.z < 32768)
							flyCubeLayer.targetObject["fly7"].visible = true;
					}
				}
			}
		}
	};

	makeClipbox = function() {
		var localgeo = new THREE.BoxGeometry(100, 100, 100);
		var localmesh = new THREE.Mesh(localgeo, new THREE.MeshPhongMaterial({
			color : 0xffffff,
			opacity : 0.2,
			transparent : true
		}));

		cmworld.clipBox.localMesh = localmesh;
		cmworld.clipBox.setLocalPosition(37.498077610324195, 127.0274561940137,
				62.15379375000016);
		cmworld.clipBox.needLocalClipboxUpdate = true;
		cmworld.rootScene.add(cmworld.clipBox.localMesh);

		cmworld.clipBox.localClipboxEnabled = true;
	}

	checkFly = function() {
		if (flypass == undefined) {
			var pathpoints = [];

			cmworld.gotoLookAt(126.5, 37, 500000, 127.02992490492944,
					37.49314254229226, 400000);

			pathpoints.push(new THREE.Vector3(127.02992490492944,
					37.49314254229226, 20));
			pathpoints.push(new THREE.Vector3(127.02992490492944,
					37.49314254229226, 500));
			pathpoints.push(new THREE.Vector3(127.02992490492944,
					37.49314254229226, 2000));
			pathpoints.push(new THREE.Vector3(127.02992490492944,
					37.49314254229226, 5000));
			pathpoints.push(new THREE.Vector3(127.02992490492944,
					37.49314254229226, 10000));
			pathpoints.push(new THREE.Vector3(127.02992490492944,
					37.49314254229226, 15000));
			pathpoints.push(new THREE.Vector3(127.02992490492944,
					37.49314254229226, 20000));
			pathpoints.push(new THREE.Vector3(127.02992490492944,
					37.49314254229226, 25000));
			pathpoints.push(new THREE.Vector3(127.02992490492944,
					37.49314254229226, 30000));
			pathpoints.push(new THREE.Vector3(127.02992490492944,
					37.49314254229226, 35000));
			pathpoints.push(new THREE.Vector3(127.02992490492944,
					37.49314254229226, 40000));

			pathpoints.push(new THREE.Vector3(127.02992490492944,
					37.49314254229226, 40000));
			pathpoints.push(new THREE.Vector3(127.02992490492944,
					37.49314254229226, 35000));
			pathpoints.push(new THREE.Vector3(127.02992490492944,
					37.49314254229226, 30000));
			pathpoints.push(new THREE.Vector3(127.02992490492944,
					37.49314254229226, 25000));
			pathpoints.push(new THREE.Vector3(127.02992490492944,
					37.49314254229226, 20000));
			pathpoints.push(new THREE.Vector3(127.02992490492944,
					37.49314254229226, 15000));
			pathpoints.push(new THREE.Vector3(127.02992490492944,
					37.49314254229226, 10000));
			pathpoints.push(new THREE.Vector3(127.02992490492944,
					37.49314254229226, 5000));
			pathpoints.push(new THREE.Vector3(127.02992490492944,
					37.49314254229226, 2000));
			pathpoints.push(new THREE.Vector3(127.02992490492944,
					37.49314254229226, 200));
			pathpoints.push(new THREE.Vector3(127.02992490492944,
					37.49314254229226, 20));

			flypass = new THREE.CatmullRomCurve3(pathpoints);
		}
	}

	checkAnimate = function() {
		if (animatepass == undefined) {
			var pathpoints = [];

			pathpoints.push(new THREE.Vector3(127.0274561940137,
					37.498077610324195, 62.15379375000016)), pathpoints
					.push(new THREE.Vector3(127.0274561940137,
							37.498077610324195, 30)), pathpoints
					.push(new THREE.Vector3(127.0274561940137,
							37.498077610324195, 0)), pathpoints
					.push(new THREE.Vector3(127.0274561940137,
							37.498077610324195, 50)), pathpoints
					.push(new THREE.Vector3(127.0274561940137,
							37.498077610324195, 100)), pathpoints
					.push(new THREE.Vector3(127.0274561940137,
							37.498077610324195, 17.770679811947048)),
					pathpoints.push(new THREE.Vector3(127.02419248142476,
							37.49716467964495, 12.214464443735778)), pathpoints
							.push(new THREE.Vector3(127.0228035873738,
									37.49983570161439, 12.821062065660954)),
					pathpoints.push(new THREE.Vector3(127.028660924021,
							37.50111859808611, 36.06227322015911)), pathpoints
							.push(new THREE.Vector3(127.03020520787288,
									37.496981317930754, 28.27079238090664)),
					pathpoints.push(new THREE.Vector3(127.02899277466136,
							37.4960762939164, 18.820372722111642)), pathpoints
							.push(new THREE.Vector3(127.02726693707825,
									37.494954961783975, 16.878087333403528)),
					pathpoints.push(new THREE.Vector3(127.02611874148117,
							37.49615467408969, 15.145359858870506)), pathpoints
							.push(new THREE.Vector3(127.02608512216023,
									37.49859802318132, 16.248056579381227)),
					pathpoints.push(new THREE.Vector3(127.02700778314758,
							37.49820433203146, 17.17902781162411)), pathpoints
							.push(new THREE.Vector3(127.0274561940137,
									37.498077610324195, 17.770679811947048)),

					animatepass = new THREE.CatmullRomCurve3(pathpoints);
		}
	}

	function getSplinePath(sx, sy, sh, ex, ey, eh, nCount) {
		//
		var curve = new THREE.SplineCurve3([ new THREE.Vector3(sx, sy, sh),
				new THREE.Vector3(ex, ey, eh) ]);
		var geometry = new THREE.Geometry();
		geometry.vertices = curve.getPoints(nCount);
		return geometry.vertices;
	}

	//숫자 1000 이상은 콤바 표시
	function numberWithCommas(x) {
		return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
	}
</script>

<div class="panel pad-all">
	<div class="panel-heading">
		<h3 class="panel-title">Camera Move</h3>
	</div>
	<div class="row">
		<div class="col-lg-12 text-left">
			<button id="txtLabel" class="btn btn-warning" onclick="WalkingMode(true);">현재고도: 10,000,000 m</button>
		</div>
	</div>
	<!--Panel body-->
	<div class="panel-body">
		<div class="row" style="overflow: hidden">
			<div class="pad-right">
				<canvas id="cmworld3Canvas"></canvas>
			</div>
		</div>
	</div>
</div>