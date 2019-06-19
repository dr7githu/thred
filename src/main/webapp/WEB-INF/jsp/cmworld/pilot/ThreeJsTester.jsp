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



	<script src="/skeleton/three/examples/js/GPUParticleSystem.js" charset="utf-8"></script>
	<script src="/skeleton/three/examples/js/renderers/CSS3DRenderer.js" charset="utf-8"></script>
	<script src="/skeleton/three/examples/js/libs/stats.min.js" charset="utf-8"></script>


	<script>
		var cmworld;
		var gui;
		var canvasLeft;
		var canvasTop;
		var font = null;
		var clock = new THREE.Clock(true);
		var tick = 0;
		var selectedUserObject = null;


		function loadFont() {
			if (font)
				return;

			var fontName = "optimer";
			var fontWeight = "bold";

			var loader = new THREE.FontLoader();
			loader.load('fonts/' + fontName + '_' + fontWeight + '.typeface.js', function (response) {
				font = response;
			});
		}

		text3DExam = function (event) {

			cmworld.gotoGeo(127, 37.44, 5000);
			var userLayer = getUserLayer();
			userLayer.clear();

			// text
			if (font) {
				var size = 100;
				var height = 100;
				var curveSegments = 4;
				var bevelThickness = 2;
				var bevelSize = 1.5;
				var bevelSegments = 3;
				var bevelEnabled = true;


				var textGeo = new THREE.TextGeometry("hello CmWorld!", {
					font: font,
					size: size,
					height: height,
					curveSegments: curveSegments,
					bevelThickness: bevelThickness,
					bevelSize: bevelSize,
					bevelEnabled: bevelEnabled,
					material: 0,
					extrudeMaterial: 1
				});
				textGeo.computeBoundingBox();
				textGeo.computeVertexNormals();


				var material = new THREE.MultiMaterial([
			  new THREE.MeshPhongMaterial({ color: 0xff00ff, shading: THREE.FlatShading }), // front
			  new THREE.MeshPhongMaterial({ color: 0xffff00 }) // side
				]);


            textMesh1 = new THREE.Mesh(textGeo, material);
            textMesh1.castShadow = true;
            textMesh1.receiveShadow = true;

				var cmObj1 = new CMWORLD.UserObject("text", textMesh1, new THREE.Vector3(127, 37.44, 300), null);
				// cmworld 표면에 맞도록 회전.
				cmObj1.rotate4GlobeEarth();
				userLayer.add(cmObj1);
			}
		}


		/*경위도 좌표를 지정하면 해당 좌표를 해석해서 World상에 띄워주는 예제*/
		worldPositionMeshExam = function () {

			cmworld.gotoGeo(126.5, 37, 10000);
			var userLayer = getUserLayer();
			userLayer.clear();

			var koreaGeoPts = [];
			koreaGeoPts.push(new THREE.Vector3(126, 37.5, 2000));
			koreaGeoPts.push(new THREE.Vector3(126.5, 37.5, 2000));
			koreaGeoPts.push(new THREE.Vector3(126.5, 37, 2000));
			koreaGeoPts.push(new THREE.Vector3(126, 37, 2000));
			koreaGeoPts.push(new THREE.Vector3(126, 37.5, 2000));
			var worldObject1 = CMWORLD.UserObject.createWorldObject("경위도객체", koreaGeoPts);
			worldObject1.setColor(new THREE.Color(0x0000ff));
			userLayer.add(worldObject1);

			var height = 300;
			koreaGeoPts = [];
			koreaGeoPts.push(new THREE.Vector3(126.898928125386, 37.478929623555, height));
			koreaGeoPts.push(new THREE.Vector3(126.912296639136, 37.486764135483, height));
			koreaGeoPts.push(new THREE.Vector3(126.923839170275, 37.489966187241, height));
			koreaGeoPts.push(new THREE.Vector3(126.935188229246, 37.484670281940, height));
			koreaGeoPts.push(new THREE.Vector3(126.939753157593, 37.477429318870, height));
			koreaGeoPts.push(new THREE.Vector3(126.953298308903, 37.470519181850, height));
			koreaGeoPts.push(new THREE.Vector3(126.963788404524, 37.440777281156, height));
			koreaGeoPts.push(new THREE.Vector3(126.940515487588, 37.436270416243, height));
			koreaGeoPts.push(new THREE.Vector3(126.932121196329, 37.444703622515, height));
			koreaGeoPts.push(new THREE.Vector3(126.923331339960, 37.454186192875, height));
			koreaGeoPts.push(new THREE.Vector3(126.914186804293, 37.460325661522, height));
			koreaGeoPts.push(new THREE.Vector3(126.910515503574, 37.478120753542, height));
			koreaGeoPts.push(new THREE.Vector3(126.898928125386, 37.478929623555, height));

			var worldObject2 = CMWORLD.UserObject.createWorldObject("경위도객체2", koreaGeoPts);
			worldObject2.setColor(new THREE.Color(0x00ff00));
			userLayer.add(worldObject2);

			for (var p in koreaGeoPts) {
				koreaGeoPts[p].x += 0.001;
				koreaGeoPts[p].y += 0.001;
				koreaGeoPts[p].z += 1;
			}

			var worldObject3 = CMWORLD.UserObject.createWorldObject("경위도라인객체3", koreaGeoPts, true);
			worldObject3.setColor(new THREE.Color(0xff0000));
			userLayer.add(worldObject3);
		}



		/*사용자 레이어를 얻자.*/
		getUserLayer = function () {
			var layerName = "testUserObjectLayer";
			var layer = cmworld.getLayer(layerName);
			if (layer) {
				return layer;
			}

			// 없으면 만들어서 추가한다.
			var userLayer = new CMWORLD.UserObjectLayer(layerName);
			cmworld.addLayer(userLayer);
			return userLayer;
		}



		load3DS = function () {

			cmworld.gotoGeo(127, 37.55, 10000);
			var userLayer = getUserLayer();
			var siteRootFolder = CMWORLD.Compile.getSiteRootUrl();
			var modelresoucrFolder = "/model/gangnam_station/";
			CMWORLD.CmWorld3.load3DS(siteRootFolder + modelresoucrFolder + "AB02_FL.3DS", siteRootFolder + modelresoucrFolder,
				 function (name, url, meshArray) {

				 	if (meshArray.length > 0) {
				 		var meshGroup = new THREE.Object3D();//create an empty container

				 		for (var i in meshArray) {
				 			var mesh = meshArray[i];

				 			// texture가 있을 경우, 생성.
								  var imageName = mesh.material.imageName;
								  fileurl = siteRootFolder + modelresoucrFolder + imageName;
				 			var tex = CMWORLD.CmWorld3.loadTexture(fileurl);

				 			tex.minFilter = THREE.LinearFilter;
				 			tex.needUpdate = true;
								  tex.imageName = imageName;

				 			var mat = new THREE.MeshPhongMaterial({ map: tex, specular: 0, shininess: 0 });
				 			mat.needsUpdate = true;
				 			//mat.side = THREE.DoubleSide;
				 			mesh.material = mat;

				 			mesh.scale.set(100, 100, 100);

							// 분리되어 있는 객체를 하나의 Group으로 묶어서 활용한다.
				 			meshGroup.add(mesh);
				 		}

				 		var userObj = new CMWORLD.UserObject(name, meshGroup, new THREE.Vector3(127, 37.55, 200), null);
				 		userObj.rotate4GlobeEarth();
				 		userLayer.add(userObj);
				 	}
				 	else {
				 	}

				 });
		}


		/*각종 geometry를 생성해보자*/
		geometryExam = function (event) {

			cmworld.gotoGeo(127, 37.5, 10000);

			var userLayer = getUserLayer();
			userLayer.clear();

			// 켈리포니아 지도
			{
				var californiaPts = [];
				californiaPts.push(new THREE.Vector2(610, 320));
				californiaPts.push(new THREE.Vector2(450, 300));
				californiaPts.push(new THREE.Vector2(392, 392));
				californiaPts.push(new THREE.Vector2(266, 438));
				californiaPts.push(new THREE.Vector2(190, 570));
				californiaPts.push(new THREE.Vector2(190, 600));
				californiaPts.push(new THREE.Vector2(160, 620));
				californiaPts.push(new THREE.Vector2(160, 650));
				californiaPts.push(new THREE.Vector2(180, 640));
				californiaPts.push(new THREE.Vector2(165, 680));
				californiaPts.push(new THREE.Vector2(150, 670));
				californiaPts.push(new THREE.Vector2(90, 737));
				californiaPts.push(new THREE.Vector2(80, 795));
				californiaPts.push(new THREE.Vector2(50, 835));
				californiaPts.push(new THREE.Vector2(64, 870));
				californiaPts.push(new THREE.Vector2(60, 945));
				californiaPts.push(new THREE.Vector2(300, 945));
				californiaPts.push(new THREE.Vector2(300, 743));
				californiaPts.push(new THREE.Vector2(600, 473));
				californiaPts.push(new THREE.Vector2(626, 425));
				californiaPts.push(new THREE.Vector2(600, 370));
				californiaPts.push(new THREE.Vector2(610, 320));
				for (var i = 0; i < californiaPts.length; i++)
					californiaPts[i].multiplyScalar(0.25);

				var californiaShape = new THREE.Shape(californiaPts);
				var geometry = new THREE.ShapeGeometry(californiaShape);
				var mesh = new THREE.Mesh(geometry, new THREE.MeshPhongMaterial({ color: 0xf08000 }));

				var posGeo = new THREE.Vector3(127, 37.55, 1000000);
				// 크기를 키워보자.
				mesh.scale.set(10, 10, 10);

				var cmObj1 = new CMWORLD.UserObject("캘리포니아", mesh, posGeo);
				// 위치를 이동해보자
				cmObj1.setPosition(127, 37.505, 400);
				// cmworld 표면에 맞도록 회전.
				cmObj1.rotate4GlobeEarth();
				userLayer.add(cmObj1);
			}


			// Heart
			{
				var x = 0, y = 0;
				var heartShape = new THREE.Shape(); // From http://blog.burlock.org/html5/130-paths
				heartShape.moveTo(x + 25, y + 25);
				heartShape.bezierCurveTo(x + 25, y + 25, x + 20, y, x, y);
				heartShape.bezierCurveTo(x - 30, y, x - 30, y + 35, x - 30, y + 35);
				heartShape.bezierCurveTo(x - 30, y + 55, x - 10, y + 77, x + 25, y + 95);
				heartShape.bezierCurveTo(x + 60, y + 77, x + 80, y + 55, x + 80, y + 35);
				heartShape.bezierCurveTo(x + 80, y + 35, x + 80, y, x + 50, y);
				heartShape.bezierCurveTo(x + 35, y, x + 25, y + 25, x + 25, y + 25);

				var geometry = new THREE.ShapeGeometry(heartShape);
				var mesh = new THREE.Mesh(geometry, new THREE.MeshPhongMaterial({ color: 0xf00000 }));
				mesh.scale.set(10, 10, 10);

				var obj1 = new CMWORLD.UserObject("heart", mesh, new THREE.Vector3(127, 37.5, 200), null);
				// 빌보드 옶션을 주면, 항상 나마 바라보게 된다.
				obj1.useBillboard = true;
				userLayer.add(obj1);
			}


			// circle
			{
				var arcShape = new THREE.Shape();
				arcShape.absarc(0, 0, 20, 0, Math.PI * 2.0, false);

				var geometry = new THREE.ShapeGeometry(arcShape);
				var mesh = new THREE.Mesh(geometry, new THREE.MeshPhongMaterial({ color: 0xf00000 }));
				mesh.scale.set(10, 10, 10);

				var obj1 = new CMWORLD.UserObject("circle", mesh, new THREE.Vector3(127, 37.495, 200), null);
				obj1.rotate4GlobeEarth();
				userLayer.add(obj1);
			}


			// texturedMesh
			{
				var texture = new THREE.TextureLoader().load("textures/WonderWoman.png");
				//texture.wrapS = texture.wrapT = THREE.RepeatWrapping;
				//texture.repeat.set(0.018, 0.018);

				{
					var material = new THREE.MeshPhongMaterial({ color: 0xffffff, map: texture });
					material.transparent = true;
					//material.opacity = 0.5;
					// 사각형 도형을 만들어서 Texture를 씌우면 된다.
					var mesh1 = new THREE.Mesh(new THREE.PlaneGeometry(100, 100, 1, 1), material);
					mesh1.scale.set(10, 10, 10);
					var obj1 = new CMWORLD.UserObject("rectangleWithTexture", mesh1, new THREE.Vector3(127.01, 37.492, 200), null);
					obj1.rotate4GlobeEarth();
					userLayer.add(obj1);
				}


				// 사각형자체의 색상을 달리해볼까
				{
					var material = new THREE.MeshPhongMaterial({ color: 0xff00ff, map: texture });
					material.transparent = true;
					var mesh2 = new THREE.Mesh(new THREE.PlaneGeometry(100, 100, 1, 1), material);
					mesh2.scale.set(5, 5, 5);
					var obj1 = new CMWORLD.UserObject("rectangleWithTexture2", mesh2, new THREE.Vector3(127.01, 37.487, 300), null);
					obj1.rotate4GlobeEarth();
					userLayer.add(obj1);
				}
			}
		}


		var particle_options;
		exampleParticle = function (event) {

			var userLayer = cmworld.getLayer("test");
			var particleSystem = new THREE.GPUParticleSystem({
				maxParticles: 25000
			});

			// options passed during each spawned
			particle_options = {
				position: new THREE.Vector3(),
				positionRandomness: .9,
				velocity: new THREE.Vector3(),
				velocityRandomness: .5,
				color: 0xaa88ff,
				colorRandomness: .2,
				turbulence: .5,
				lifetime: 10,
				size: 100,
				sizeRandomness: 100
			};

			var obj1 = new CMWORLD.UserObject("particle", particleSystem, new THREE.Vector3(127, 37.48, 210), particle_update);
			obj1.rotate4GlobeEarth();
			userLayer.add(obj1);
		}


		particle_update = function (userobject, deltatime) {

			var spawnerOptions = {
				spawnRate: 15000,
				horizontalSpeed: 1.5,
				verticalSpeed: 1.33,
				timeScale: 10
			}

			if (userobject) {

				var pos = userobject.worldPosition.clone();
				pos = pos.sub(cmworld.option.refCenter);


				var particleSystem = userobject.object;

				var delta = clock.getDelta() * spawnerOptions.timeScale;
				tick += delta;
				if (tick < 0) tick = 0;
				if (delta > 0) {
					particle_options.position.x = Math.sin(tick * spawnerOptions.horizontalSpeed) * 20 + pos.x;
					particle_options.position.y = Math.sin(tick * spawnerOptions.verticalSpeed) * 10 + pos.y;
					particle_options.position.z = Math.sin(tick * spawnerOptions.horizontalSpeed + spawnerOptions.verticalSpeed) * 5 + pos.z;
					for (var x = 0; x < spawnerOptions.spawnRate * delta; x++) {
						// Yep, that's really it.	Spawning particles is super cheap, and once you spawn them, the rest of
						// their lifecycle is handled entirely on the GPU, driven by a time uniform updated below
						particleSystem.spawnParticle(particle_options);
					}
				}

				particleSystem.update(tick);
			}
		}



		var mixers = [];
		animationModel = function () {
			cmworld.gotoGeo(127, 37.43, 10000);

			var userLayer = getUserLayer();
			userLayer.clear();

			var loader = new THREE.JSONLoader();
			loader.load("model/animated/flamingo.js", function (geometry) {
				var material = new THREE.MeshPhongMaterial({ color: 0xffffff, specular: 0xffffff, shininess: 20, morphTargets: true, vertexColors: THREE.FaceColors, shading: THREE.FlatShading });
				var mesh = new THREE.Mesh(geometry, material);
				var s = 5.35;
				mesh.scale.set(s, s, s);
				mesh.position.y = 15;
				mesh.rotation.y = -1;
				mesh.castShadow = true;
				mesh.receiveShadow = true;

				var obj1 = new CMWORLD.UserObject("animationMode", mesh, new THREE.Vector3(127, 37.43, 210),
					 function (userobject, deltatime) {
					 	var delta = clock.getDelta();
					 	//controls.update();
					 	for (var i = 0; i < mixers.length; i++) {
					 		mixers[i].update(delta);
					 	}
					 });

				obj1.rotate4GlobeEarth();
				userLayer.add(obj1);

				var mixer = new THREE.AnimationMixer(mesh);
				mixer.clipAction(geometry.animations[0]).setDuration(1).play();
				mixers.push(mixer);
			});
		}


		moveModel = function () {
			cmworld.gotoGeo(127, 37.43, 500000);

			var userLayer = getUserLayer();
			userLayer.clear();
			var move = 0.02;
			var rotateDeg = 1;

			var texture = new THREE.TextureLoader().load("textures/X.png");
			{
				var material = new THREE.MeshPhongMaterial({ color: 0xffffff, map: texture });
				material.transparent = true;
				//material.opacity = 0.5;
				// 사각형 도형을 만들어서 Texture를 씌우면 된다.
				var mesh1 = new THREE.Mesh(new THREE.PlaneGeometry(100, 100, 1, 1), material);
				mesh1.scale.set(300, 300, 300);
				var obj1 = new CMWORLD.UserObject("moveModel", mesh1, new THREE.Vector3(127.01, 37.492, 1000),
					 function (userObject, deltatime, tag) {

					 	var geoPos = userObject.getPosition();
					 	if (geoPos.x > 129 || geoPos.x < 126) {
					 		move *= -1;
					 	}

					 	// 모델의 위치 이동
					 	userObject.setPosition(geoPos.x += move, geoPos.y, geoPos.z);
					 	userObject.rotate4GlobeEarth();

					 	// 이건, 모델의 회전방향설정
					 	userObject.setRotate(rotateDeg++);
					 });

				obj1.rotate4GlobeEarth();
				userLayer.add(obj1);
			}
		}


		var dae;
		// collada 모델을 읽어보자.
		colladaExam = function () {

			var userLayer = getUserLayer();
			userLayer.clear();

			var modelGeoPos = new THREE.Vector3(127, 37.55, 300);
			cmworld.gotoGeo(modelGeoPos.x, modelGeoPos.y, 5000);

			var loader = new THREE.ColladaLoader();
			loader.options.convertUpAxis = true;
			loader.load('model/collada/avatar.dae', function (collada) {
				dae = collada.scene;
				dae.traverse(function (child) {
					if (child instanceof THREE.SkinnedMesh) {
						//var animation = new THREE.Animation(child, child.geometry.animation);
						//animation.play();
					}
				});
				dae.scale.x = dae.scale.y = dae.scale.z = 300.002;
				dae.updateMatrix();

				var height = cmworld.getGroundHeight(modelGeoPos.x, modelGeoPos.y);
				if (height < 0)
					height = 300;
				var obj1 = new CMWORLD.UserObject("collada", dae, new THREE.Vector3(modelGeoPos.x, modelGeoPos.y, height));
				obj1.rotate4GlobeEarth();
				userLayer.add(obj1);
			});
		}



		pointsExam = function () {

			cmworld.gotoGeo(127, 37.37, 5000);

			var userLayer = getUserLayer();
			userLayer.clear();

			var geometry = new THREE.Geometry();

			for (i = 0; i < 1000; i++) {
				var vertex = new THREE.Vector3();
				vertex.x = 2000 * Math.random() - 1000;
				vertex.y = 2000 * Math.random() - 1000;
				vertex.z = 2000 * Math.random() - 1000;
				geometry.vertices.push(vertex);
			}

			var sprite = new THREE.TextureLoader().load("textures/disc.png");

			var material = new THREE.PointsMaterial({ size: 35, sizeAttenuation: false, map: sprite, alphaTest: 0.5, transparent: true });
			material.color.setHSL(1.0, 0.3, 0.7);
			var particles = new THREE.Points(geometry, material);

			var obj1 = new CMWORLD.UserObject("collada", particles, new THREE.Vector3(127, 37.37, 210));
			obj1.rotate4GlobeEarth();
			userLayer.add(obj1);
		}


		point2Exam = function (event) {
			cmworld.gotoGeo(127, 37.38, 5000);

			var userLayer = getUserLayer();
			userLayer.clear();

			var time = performance.now() * 0.0005;
			{
				var geometry = new THREE.InstancedBufferGeometry();
				geometry.copy(new THREE.CircleBufferGeometry(1, 6));
				var particleCount = 75000;
				var translateArray = new Float32Array(particleCount * 3);
				var scaleArray = new Float32Array(particleCount);
				var colorsArray = new Float32Array(particleCount * 3);
				for (var i = 0, i3 = 0, l = particleCount; i < l; i++, i3 += 3) {
					translateArray[i3 + 0] = Math.random() * 2 - 1;
					translateArray[i3 + 1] = Math.random() * 2 - 1;
					translateArray[i3 + 2] = Math.random() * 2 - 1;
				}
				geometry.addAttribute("translate", new THREE.InstancedBufferAttribute(translateArray, 3, 1));
				geometry.addAttribute("scale", new THREE.InstancedBufferAttribute(scaleArray, 1, 1).setDynamic(true));
				geometry.addAttribute("color", new THREE.InstancedBufferAttribute(colorsArray, 3, 1).setDynamic(true));
				var material = new THREE.RawShaderMaterial({
					uniforms: {
						map: { type: "t", value: new THREE.TextureLoader().load("./textures/circle.png") },
					},
					vertexShader: document.getElementById('vshader').textContent,
					fragmentShader: document.getElementById('fshader').textContent,
					depthTest: true,
					depthWrite: true
				});
				mesh = new THREE.Mesh(geometry, material);
				mesh.scale.set(400, 400, 400);

				var translates = geometry.getAttribute('translate');
				var translatesArray = translates.array;
				var scales = geometry.getAttribute('scale');
				var scalesArray = scales.array;
				var colors = geometry.getAttribute('color');
				var colorsArray = colors.array;

				var color = new THREE.Color(0xffffff);
				for (var i = 0, i3 = 0, l = scalesArray.length; i < l; i++, i3 += 3) {
					var x = translatesArray[i3 + 0] + time;
					var y = translatesArray[i3 + 1] + time;
					var z = translatesArray[i3 + 2] + time;
					var scale = Math.sin(x * 2.1) + Math.sin(y * 3.2) + Math.sin(z * 4.3);
					scalesArray[i] = scale * 10 + 10;
					color.setHSL(scale / 5, 1, 0.5);
					colorsArray[i3 + 0] = color.r;
					colorsArray[i3 + 1] = color.g;
					colorsArray[i3 + 2] = color.b;
				}
				scales.needsUpdate = true;
				colors.needsUpdate = true;



				var cmObj1 = new CMWORLD.UserObject("cloud circles", mesh, new THREE.Vector3(127, 37.38, 200),
					 function (userobject, deltatime) {
					 }
					);

				// cmworld 표면에 맞도록 회전.
				cmObj1.rotate4GlobeEarth();

				/*  회전
				var quaternionRotation = new THREE.Quaternion();
				quaternionRotation.setFromAxisAngle(new THREE.Vector3(0, 0, 1), 90 * CMWORLD.CmMathEngine.Deg2Rad);

				cmObj1.quaternion = quaternionRotation.clone();
				cmObj1.rotate4GlobeEarth();
				*/

				userLayer.add(cmObj1);
			}
		}


		function setTileInfo()
		{
			cmworld.option.viewTileInfo = !cmworld.option.viewTileInfo;
		}


		LineExam = function () {

			cmworld.gotoGeo(127, 37.46, 10000);

			var userLayer = getUserLayer();
			userLayer.clear();

			// 좌표개념이 없는 라인
			{
				var geometry = new THREE.Geometry();
				var point = new THREE.Vector3();
				var direction = new THREE.Vector3();
				for (var i = 0; i < 200; i++) {
					direction.x += Math.random() - 0.5;
					direction.y += Math.random() - 0.5;
					direction.z += Math.random() - 0.5;
					direction.normalize().multiplyScalar(20);
					point.add(direction);
					geometry.vertices.push(point.clone());
				}

				// line 10개 그리자
				for (var i = 0; i < 10; i++) {
					var object;
					if (Math.random() > 0.5) {
						object = new THREE.Line(geometry);
					} else {
						object = new THREE.LineSegments(geometry);
					}

					object.rotation.x = Math.random() * 2 * Math.PI;
					object.rotation.y = Math.random() * 2 * Math.PI;
					object.rotation.z = Math.random() * 2 * Math.PI;

					var obj1 = new CMWORLD.UserObject("line" + i.toString(), object, new THREE.Vector3(127, 37.46, 510));
					obj1.rotate4GlobeEarth();
					userLayer.add(obj1);
				}
			}


			// 특수라인 : 라인에 모양을 넣어서 해보자
			{
				var ptlist = [];
				ptlist.push(new THREE.Vector3(127, 37.371, 200));
				ptlist.push(new THREE.Vector3(127, 37.375, 300));
				ptlist.push(new THREE.Vector3(127, 37.370, 300));
				ptlist.push(new THREE.Vector3(127.4, 37.438, 500));
				ptlist.push(new THREE.Vector3(127, 37.475, 200));

				var earthRadius = CMWORLD.cm_const.EarthRadius;

				var earthpts = [];
				var origin = CMWORLD.CmMathEngine.Geo2Cartesian(ptlist[0].x, ptlist[0].y, ptlist[0].z + earthRadius)

				for (var i = 0; i < ptlist.length; i++) {
					var pt = CMWORLD.CmMathEngine.Geo2Cartesian(ptlist[i].x, ptlist[i].y,
							  ptlist[i].z + earthRadius);
					pt.x = pt.x - origin.x;
					pt.y = pt.y - origin.y;
					pt.z = pt.z - origin.z;

					earthpts.push(pt);
				}

				var randomSpline = new THREE.CatmullRomCurve3(earthpts);

				var extrudeSettings = {
					steps: 100,
					bevelEnabled: true,
					extrudePath: randomSpline
				};

				var pts = [], numPts = 8;

				for (var i = 0; i < numPts * 2; i++) {

					var radius = 10;
					var l = i % 2 == 1 ? radius : radius * 2;

					var a = i / numPts * Math.PI;

					pts.push(new THREE.Vector2(Math.cos(a) * l, Math.sin(a) * l));

				}

				var shape = new THREE.Shape(pts);
				var geometry = new THREE.ExtrudeGeometry(shape, extrudeSettings);

				var color = new THREE.Color(0xffff00);
				var material = new THREE.MeshBasicMaterial({
					color: 0xCC000F,
					shading: THREE.SmoothShading,
					ambient: 0x555555,
					specular: 0xffffff
				});

				var mesh = new THREE.Mesh(geometry, material);
				shipTrackPoisition = new THREE.Vector3(ptlist[0].x, ptlist[0].y, 100);
				shipTrackRealObj = new CMWORLD.UserObject(name, mesh, shipTrackPoisition, null);

				userLayer.add(shipTrackRealObj);
			}
		}


		init = function () {
			loadFont();
		}


		mouseClick = function (event) {
			if (event) {
				if (event.ctrlKey) {

					if (cmworld) {

						var userLayer = getUserLayer();

						if (userLayer != null) {
							var selected = userLayer.pickingByScreenCoordinate(event.pageX, event.pageY);
							if (selected != null && selected.length > 0) {

								var selObject = selected[0];
								while (selObject.parent != null) {
									selObject = selObject.parent;
								}

								alert("id:" + selObject.userObject.id + " name:" + selObject.userObject.name);

								disHighlight();
								setHighlight(selObject.userObject);
							}
							else {
								disHighlight();
							}
						}
					}
				}
			}
		}

		/** highlight를 제거한다. */
		function disHighlight()
		{
			if (selectedUserObject != null)
				selectedUserObject.setHighlightColor(null);
			selectedUserObject = null;
		}

		/** highlight를 설정한다.*/
		function setHighlight( userObject )
		{
			selectedUserObject = userObject;
			selectedUserObject.setHighlightColor(0xff0000);
		}


		mouseMove = function (event) {
			if (selectedUserObject != null) {
				if (event.altKey) {

					// 회전량을 계산하자.
					if (cmworld) {

						// 3차원 객체가 표시되는 화면좌표를 얻는다.
						var objectScreenPos = cmworld.toScreenCoord(selectedUserObject.worldPosition);

						// 모델의 화면 좌표를 중심으로 12시방향 상단의 한점을 구한다.
						var point1 = new THREE.Vector3(0, 100, 0);
						var point2 = new THREE.Vector3(event.pageX - objectScreenPos.x, event.pageY - objectScreenPos.y, 0);
						// 2개의 벡터사이 각도를 계산한다.
						var resultDegree = CMWORLD.MathEngine2d.arcCalc( point1.x, point1.y, point2.x, point2.y );

						// 0 ~ 360도.
						if (point1.x > (point2.x)) {
							resultDegree = 360 - resultDegree;
						}

						// 모델을 회전할 회전각도를 설정한다.
						selectedUserObject.setRotate(resultDegree);
						// 지표면으로 이동한다.
						selectedUserObject.rotate4GlobeEarth();
					}
				}
			}
		}


		window.onload = function () {
			var canvas = document.querySelector("#cmworldCanvas");
			canvas.onclick = mouseClick;
			canvas.onmousemove = mouseMove;

			// xdworldData
			cmworld = new CMWORLD.CmWorld3(canvas, 127, 37.5, 10000, { toptilespan: 36 });

			cmworld.addTileImageLayer("base", "http://xdworld.vworld.kr:8080/XDServer/requestLayerNode?APIKey=767B7ADF-10BA-3D86-AB7E-02816B5B92E9&Layer=tile_mo_HD&Level={z}&IDX={x}&IDY={y}", 0, 15, 90, -90, -180, 180, "jpg", false);
			cmworld.addTerrainLayer("terrain", "http://xdworld.vworld.kr:8080/XDServer/requestLayerNode?APIKey=767B7ADF-10BA-3D86-AB7E-02816B5B92E9&Layer=dem&Level={z}&IDX={x}&IDY={y}", 0, 15, 90, -90, -180, 180, "");

			cmworld.showLatLonLine(true);

			init();
		};


		function empty() {
		}

	</script>

<div class="panel pad-all">
	<!--Panel body-->
	<div class="panel-body">
		<div class="row">
			<canvas id="cmworldCanvas"></canvas>
			<div id="container"></div>
		</div>
	</div>
</div>

	<a href="#" onclick="geometryExam()" style="right: 10px; top: 20px; position: absolute; z-index: 10000;color: rgb(182, 255, 0)">Geometry</a>
	<a href="#" onclick="LineExam()" style="right: 10px; top: 40px; position: absolute; z-index: 10000;color: rgb(182, 255, 0)">Line</a>
	<a href="#" onclick="animationModel()" style="right: 10px; top: 60px; position: absolute; z-index: 10000;color: rgb(182, 255, 0)">AnimationModel</a>
	<a href="#" onclick="moveModel()" style="right: 10px; top: 80px; position: absolute; z-index: 10000;color: rgb(182, 255, 0)">moveModel</a>
	<!--<a href="#" onclick="colladaExam()" style="right: 10px; top: 100px; position: absolute; z-index: 10000;color: rgb(182, 255, 0)">loading_collada</a>-->
	<a href="#" onclick="pointsExam()" style="right: 10px; top: 120px; position: absolute; z-index: 10000;color: rgb(182, 255, 0)">point1</a>
	<a href="#" onclick="point2Exam()" style="right: 10px; top: 140px; position: absolute; z-index: 10000;color: rgb(182, 255, 0)">point2</a>
	<a href="#" onclick="text3DExam()" style="right: 10px; top: 160px; position: absolute; z-index: 10000;color: rgb(182, 255, 0)">3D Text</a>
	<a href="#" onclick="worldPositionMeshExam()" style="right: 10px; top: 180px; position: absolute; z-index: 10000;color: rgb(182, 255, 0)">WorldPositionMesh</a>
	<a href="#" onclick="load3DS()" style="right: 10px; top: 200px; position: absolute; z-index: 10000;color: rgb(182, 255, 0)">load 3ds</a>

	<script id="vshader" type="x-shader/x-vertex">
		precision highp float;
		uniform mat4 modelViewMatrix;
		uniform mat4 projectionMatrix;
		attribute vec3 position;
		attribute vec2 uv;
		attribute vec3 normal;
		attribute vec3 translate;
		attribute float scale;
		attribute vec3 color;
		varying vec2 vUv;
		varying vec3 vColor;

		void main() {
		vec4 mvPosition = modelViewMatrix * vec4( translate, 1.0 );
		mvPosition.xyz += position * scale;
		vUv = uv;
		vColor = color;
		gl_Position = projectionMatrix * mvPosition;
		}
	</script>

	<script id="fshader" type="x-shader/x-fragment">
		precision highp float;
		uniform sampler2D map;
		varying vec2 vUv;
		varying vec3 vColor;

		void main() {

		//gl_FragDepthEXT = log2(vFragDepth) * logDepthBufFC * 0.5;
		vec4 diffuseColor = texture2D( map, vUv );
		gl_FragColor = vec4( diffuseColor.xyz * vColor, diffuseColor.w );
		if ( diffuseColor.w < 0.5 ) discard;
		}
	</script>

