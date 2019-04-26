<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html;charset=utf-8">
<title>3D GRID</title>

<style>
html, body {
	overflow: hidden;
	width: 100%;
	height: 100%;
	margin: 0;
	padding: 0;
}

#cmworldCanvas {
	width: 100%;
	height: 100%;
}
</style>


<script src="./cmworld3/lib/jquery-2.2.0.min.js"></script>

<script src="./cmworld3/cm_compile.js"></script>
<script>
	CMWORLD.Compile.includeCm3Library("./cmworld3/");
</script>
<script src="./cmworld3/Loader/OBJMTLLoader.js"></script>
<script src="./cmworld3/Utilities/SceneUtils.js"></script>


<script>
	var cmworld;
	var gui;
	var redmat;
	var whitemat;
	var userLayer;
	var path;
	var starttime;
	var ppp = 0;
	var droneobj;
	var cubes = [];
	var rollOverMesh, rollOverMaterial;
	var cubeGeo, cubeMaterial;
	var axis = new THREE.Vector3();
	var up = new THREE.Vector3(0, 1, 0);
	var radians;
	var isFly = false;


	// 드론을 따라 움직이는 카메라
	// 드론을 따라 갈때는 마우스가 동작하지 않는다.
	 function fly() {
	    isFly = true;
	 }
	
	// 드론을 따라가는 걸 멈춘다.
	 function stopFly() {
	    isFly = false;
	 }

        function onupdatedrone(userObject, deltatime) {
           var pos = path.getPoint(ppp);
           var tan = path.getTangent(ppp).normalize();

           userObject.setPosition(pos.x, pos.y, pos.z);

           axis.crossVectors(up, tan).normalize();

           radians = Math.acos(up.dot(tan));

           // set the quaternion
           userObject.rotate4GlobeEarth(CMWORLD.RotateOp.Reset);
           userObject.setRotate(90);
           //userObject.setFromAxisAngle(axis, radians, CMWORLD.RotateOp.Reset);

           //userObject.rotate4GlobeEarth();
           //userObject.rotate(90, 0, 0);

           if (isFly == true)
           {
              // 카메라 위치를 지정해 보자
              var ct = ppp - 0.05;
              if (ct < 0)
              {
                 // 현재 ppp만큼 1에서 뺀 값을 가지고 구한다.
                 ct = 1.0 + ct;
              }
              {
                  var cameraPos = path.getPoint(ct);

                 var camera = cmworld.getCamera();

                 cmworld.gotoLookAt(cameraPos.x, cameraPos.y, cameraPos.z, pos.x, pos.y, pos.z - 120);
                 //cmworld.gotoLookAt(pos.x, pos.y, pos.z, cameraPos.x, cameraPos.y, cameraPos.z + 100);
                 // pos를 Geo로 바꾸자
                 //camera.setPositionGeo(lookPos.x, lookPos.y, lookPos.z);
                 //camera.setLookPositionGeo(pos.x, pos.y, pos.z);
              }

           }

            ppp += 0.001;
            if (ppp > 1) {
                ppp = 0;
            }
        }


        function makeSampleCubes() {

            var cubeSpace = 22;
            var cubeSpaceDeg = cubeSpace/80000;

            var LT = new THREE.Vector3(127.09238088798946, 37.51723136677059, 80);
            var RB = new THREE.Vector3(127.10138088798946, 37.509616606656335, 20);

            //voxel.position.copy(intersect.point).add(intersect.face.normal);
            //voxel.position.divideScalar(50).floor().multiplyScalar(50).addScalar(25);

            for (var h = RB.z; h < LT.z; h += cubeSpace) {
                for (var y = RB.y; y < LT.y; y += cubeSpaceDeg) {
                    for (var x = LT.x; x < RB.x; x += cubeSpaceDeg) {
                        var voxelMesh = new THREE.Mesh(cubeGeo, cubeMaterial);
                        var cubeCmObj = new CMWORLD.UserObject("cube", voxelMesh, new THREE.Vector3(x, y, h));
                        cubeCmObj.rotate4GlobeEarth();
                        userLayer.add(cubeCmObj);
                    }
                }
            }
        }


        function onupdateobject(userObject, deltatime) {
            if (userObject.object) {
                if (userObject.drone) {
                    if (userObject.drone.object) {
                        //if (userObject.object.children[0].geometry.boundingBox == null)
                        //    userObject.object.children[0].geometry.computeBoundingBox();
                        //if (userObject.drone.object.geometry.boundingBox == null)
                         //   userObject.drone.object.geometry.computeBoundingBox();

                        // 일단, 거리로 체크.
                        var dist = userObject.worldPosition.distanceTo(userObject.drone.worldPosition);
                        if (dist < 20)
                            //if (userObject.object.children[0].geometry.boundingBox.intersect(userObject.drone.object.geometry.boundingBox))
                        {
                            userObject.object.children[0].material = redmat[0];
                            userObject.object.children[1].material = redmat[1];
                        }
                        else {
                            userObject.object.children[0].material = whitemat[0];
                            userObject.object.children[1].material = whitemat[1];
                        }

                        userObject.object.children[0].material.needsUpdate = true;
                    }
                }
            }
        }

        function onloaddrone(obj)
        {
           starttime = new Date();

           var points = [];/*
           points.push(new THREE.Vector3(127.08014368603168, 37.517527477832544, 22.494735240004957));
           points.push(new THREE.Vector3(127.08064091669904, 37.516802207097356, 26.058950913138688));
           points.push(new THREE.Vector3(127.08115061993482, 37.516252853433016, 36.225367670878768));
           points.push(new THREE.Vector3(127.08125980746743, 37.51554634948031, 45.612869640812278));
           points.push(new THREE.Vector3(127.0802479765137, 37.51514109155389, 55.240735003724694));
           points.push(new THREE.Vector3(127.07895354178835, 37.51628663723899, 30.168893757276237));
           points.push(new THREE.Vector3(127.07893445125274, 37.51745484817524, 13.051897082477808));
           */
           points.push(new THREE.Vector3(127.08032160008247, 37.518026833001535, 12.036206373013556));
           points.push(new THREE.Vector3(127.08069062860281, 37.516395945733855, 24.2060666391626));
           points.push(new THREE.Vector3(127.08189561080279, 37.51624879542647,  34.202766254544258));
           points.push(new THREE.Vector3(127.0819531470497,  37.51615501828014,   44.418672335334122));
           points.push(new THREE.Vector3(127.08197394748373, 37.51587202569353,  45.27419700846076));
           points.push(new THREE.Vector3(127.08206475487944, 37.51543586406959,  45.332078789360821));
           points.push(new THREE.Vector3(127.0820843030921,  37.51506892147592,   45.194045457057655));
           points.push(new THREE.Vector3(127.08139401508005, 37.514167784043124, 46.20430080872029));
           points.push(new THREE.Vector3(127.08218180925498, 37.513743065460226, 45.815882312133908));
           points.push(new THREE.Vector3(127.08223955276986, 37.51361070272318,  45.296193852089345));
           points.push(new THREE.Vector3(127.08217215967451, 37.51351975284549,  45.398337663151324));
           points.push(new THREE.Vector3(127.0820581944191,  37.51346406817735,   45.407616688869894));
           points.push(new THREE.Vector3(127.08185460989489, 37.51337277951243,  45.146325396373868));
           points.push(new THREE.Vector3(127.08164654486401, 37.51325774486434,  45.20303083397448));
           points.push(new THREE.Vector3(127.08168026555032, 37.51308941926688,  45.477084174752235));
           points.push(new THREE.Vector3(127.08170306382354, 37.51293798081657,  45.219697866588831));
           points.push(new THREE.Vector3(127.08163524251393, 37.51276023344294,  45.334281240589917));
           points.push(new THREE.Vector3(127.08150299837592, 37.512617296426114, 45.242563012987375));
           points.push(new THREE.Vector3(127.08133403934477, 37.512453356140234, 45.205888508819044));
           points.push(new THREE.Vector3(127.08113337494498, 37.51222285978129,  45.893543291836977));
           points.push(new THREE.Vector3(127.0809740730333,  37.51208648270882,   44.951618768274784));
           points.push(new THREE.Vector3(127.08053663016057, 37.51201566293305,  44.164152760989964));
           points.push(new THREE.Vector3(127.07982035901446, 37.51201084491874,  44.195055276155472));
           points.push(new THREE.Vector3(127.07925259393579, 37.512062018052234, 44.122340681031346));
           points.push(new THREE.Vector3(127.07875131696896, 37.51207958141443,  44.214711031876504));
           points.push(new THREE.Vector3(127.0783003275059,  37.51237384255757,   44.183334787376225));
           points.push(new THREE.Vector3(127.07817490462114, 37.512790562365666, 44.173574956133962));
           points.push(new THREE.Vector3(127.078110461592,   37.51340243185643,    43.936627745628357));
           points.push(new THREE.Vector3(127.07798380861914, 37.514012135119344, 43.952180043794215));
           points.push(new THREE.Vector3(127.07782996976425, 37.514798878257636, 43.818239197134972));
           points.push(new THREE.Vector3(127.07764820205246, 37.51544000210379,  43.943038646131754));
           points.push(new THREE.Vector3(127.0781418167137,  37.515694409269344,  44.019498552195728));
           points.push(new THREE.Vector3(127.07879608374843, 37.51670541443626,  60.718812882900238));
           points.push(new THREE.Vector3(127.07925085198727, 37.51742316163681,  13.173998506739736));

           path = new THREE.SplineCurve3(points);

           var droneobj = new CMWORLD.UserObject("drone", obj, new THREE.Vector3(127.0774320205246, 37.517527477832544, 22.494735240004957), onupdatedrone);
           droneobj.rotate4GlobeEarth();
           droneobj.setRotateAll(90, 90, 0);
           droneobj.setScale(0.01, 0.01, 0.01);
           userLayer.add(droneobj);

           var faceIndices = ['a', 'b', 'c'];
           var radius = 20;
           var boxgeo = new THREE.BoxGeometry(20, 20, 20);

           for (var i = 0; i < boxgeo.faces.length; i++)
           {

              f = boxgeo.faces[i];
              f2 = boxgeo.faces[i];
              f3 = boxgeo.faces[i];

              for (var j = 0; j < 3; j++)
              {
                 vertexIndex = f[faceIndices[j]];

                 p = boxgeo.vertices[vertexIndex];

                 color = new THREE.Color(0xffffff);

                 f3.vertexColors[j] = color;

              }

           }

           redmat = [
                      new THREE.MeshPhongMaterial({ color: 0x11ff00, shading: THREE.FlatShading, opacity: 0.5, wireframe: true, vertexColors: THREE.VertexColors, shininess: 0 }),
                      new THREE.MeshBasicMaterial({ color: 0x11ff00, shading: THREE.FlatShading, opacity: 1, wireframe: true, transparent: true })

           ];

           whitemat = [

                      new THREE.MeshPhongMaterial({ color: 0xffffff, shading: THREE.FlatShading, opacity: 0.1, wireframe: true, vertexColors: THREE.VertexColors, shininess: 0, transparent: true }),
                      new THREE.MeshBasicMaterial({ color: 0xffffff, shading: THREE.FlatShading, opacity: 0.1, wireframe: true, transparent: true })

           ];

           for (var x = 0; x < 30; x++)
           {
              for (var y = 0; y < 30; y++)
              {
                 for (var z = 0; z < 5; z++)
                 {
                    //var box = new THREE.Mesh(boxgeo, whitemat);

                    var box = THREE.SceneUtils.createMultiMaterialObject(boxgeo, whitemat);


                    var index = x + y * 10;

                    var obj = new CMWORLD.UserObject(index.toString(), box, new THREE.Vector3(127.07744820205246 + x * 0.000225, 37.511801084491874 + y * 0.00018, 35.277411763556302 + z * 20), onupdateobject);
                    obj.drone = droneobj;
                    obj.rotate4GlobeEarth();
                    userLayer.add(obj);
                 }
              }
           }

        }

        function example()
        {
           cmworld.setAmbientColor(0xffffff);
            userLayer = new CMWORLD.UserObjectLayer("lights");

            cmworld.addLayer(userLayer);

            //cmworld.setAmbientColor(0x111111);


           /*
            var geometry = new THREE.SphereGeometry(5, 32, 32);
            var material = new THREE.MeshBasicMaterial({ color: 0xffff00 });
            drone = new THREE.Mesh(geometry, material);

            var droneobj = new CMWORLD.UserObject("drone", drone, new THREE.Vector3(127.08014368603168, 37.517527477832544, 22.494735240004957), onupdatedrone);
            userLayer.add(droneobj);
            */


            var loader = new THREE.OBJMTLLoader();
           loader.load("./cmworld3/model/Drone-MQ27/MQ-27.obj", "./cmworld3/model/Drone-MQ27/MQ-27.mtl", onloaddrone);
           // loader.load("./model/Drone_Red/Drone_Red.obj", "./model/Drone_Red/Drone_Red.mtl", onloaddrone);
        }


        function onDocumentMouseMove(event) {

            event.preventDefault();

            var camera = cmworld.getCamera().getThreejsCamera();

            var mouse = new THREE.Vector2();
            mouse.set((event.clientX / window.innerWidth) * 2 - 1, -(event.clientY / window.innerHeight) * 2 + 1);

            var raycaster = new THREE.Raycaster();
            raycaster.setFromCamera(mouse, camera);

            var intersects = raycaster.intersectObjects(cubes);

            if (intersects.length > 0) {

                var intersect = intersects[0];

                rollOverMesh.position.copy(intersect.point).add(intersect.face.normal);
                rollOverMesh.position.divideScalar(50).floor().multiplyScalar(50).addScalar(25);

            }
        }


        function onDocumentMouseDown(event) {

            event.preventDefault();

            var camera = cmworld.getCamera().getThreejsCamera();

            var mouse = new THREE.Vector2();
            mouse.set((event.clientX / window.innerWidth) * 2 - 1, -(event.clientY / window.innerHeight) * 2 + 1);

            var raycaster = new THREE.Raycaster();
            raycaster.setFromCamera(mouse, camera);

            var intersects = raycaster.intersectObjects(cubes);

            if (intersects.length > 0) {

                var intersect = intersects[0];

                // delete cube

                if (isShiftDown) {

                    if (intersect.object != plane) {

                        scene.remove(intersect.object);

                        cubes.splice(cubes.indexOf(intersect.object), 1);

                    }

                    // create cube

                } else {

                    var voxel = new THREE.Mesh(cubeGeo, cubeMaterial);
                    voxel.position.copy(intersect.point).add(intersect.face.normal);
                    voxel.position.divideScalar(50).floor().multiplyScalar(50).addScalar(25);
                    scene.add(voxel);

                    cubes.push(voxel);

                }
            }
        }


        window.onload = function () {

            document.addEventListener('mousemove', onDocumentMouseMove, false);
            document.addEventListener('mousedown', onDocumentMouseDown, false);

            rollOverGeo = new THREE.BoxGeometry(20, 20, 20);
            rollOverMaterial = new THREE.MeshBasicMaterial({ color: 0xff0000, opacity: 0.5, transparent: true });
            rollOverMesh = new THREE.Mesh(rollOverGeo, rollOverMaterial)

            //cubeGeo = new THREE.BoxGeometry(20, 20, 20);
            cubeGeo = new THREE.CubeGeometry(20, 20, 20);
            //cubeGeo.computeFaceNormals();
            //cubeGeo.normalsNeedUpdate = true;
            //cubeMaterial = new THREE.MeshLambertMaterial({ color: 0xfeb74c, /*map: new THREE.TextureLoader().load("textures/square-outline-textured.png")*/ });
            cubeMaterial = new THREE.MeshPhongMaterial({
                color: 0x808080,
                ambient: 0x808080,
                specular: 0x808080,
                shininess: 20,
                reflectivity: 5.5
            });


            var canvas = document.querySelector("#cmworldCanvas");

            cmworld = new CMWORLD.CmWorld3(canvas, 127, 38, CMWORLD.cm_const.EarthRadius, { toptilespan: 36 });
				cmworld.option.worldTimer.setStartDateTime(2015, 7, 12, 14, 0, 0, 0);

            cmworld.addTileImageLayer("base", "http://xdworld.vworld.kr:8080/XDServer/requestLayerNode?APIKey=767B7ADF-10BA-3D86-AB7E-02816B5B92E9&Layer=tile_mo_HD&Level={z}&IDX={x}&IDY={y}", 0, 15, 90, -90, -180, 180, "jpg", false);
            cmworld.addTerrainLayer("terrain", "http://xdworld.vworld.kr:8080/XDServer/requestLayerNode?APIKey=767B7ADF-10BA-3D86-AB7E-02816B5B92E9&Layer=dem&Level={z}&IDX={x}&IDY={y}", 0, 15, 90, -90, -180, 180, "");

            cmworld.addReal3DLayer("facility_build", "http://xdworld.vworld.kr:8080/XDServer/requestLayerNode?Layer=facility_build&Level={z}&IDX={x}&IDY={y}&APIKey=767B7ADF-10BA-3D86-AB7E-02816B5B92E9",
                                                   "http://xdworld.vworld.kr:8080/XDServer/requestLayerObject?APIKey=767B7ADF-10BA-3D86-AB7E-02816B5B92E9&Layer=facility_build&Level={z}&IDX={x}&IDY={y}&DataFile={f}", "facility_build", 0, 15, 90, -90, -180, 180, "dat");

            cmworld.option.showFPS(true);

            example();

            var eye_x = 127.08174188396235;
            var eye_y = 37.51231017799103;
            var eye_h = 300;
            var look_x = 127.08174188396235;
            var look_y = 37.51505310508758;
            var look_h = 100;

            cmworld.gotoLookAt(eye_x, eye_y, eye_h, look_x, look_y, look_h);
        };
	</script>

</head>
<body>
	<canvas id="cmworldCanvas"></canvas>

	<a href="#" onclick="fly()"
		style="right: 10px; top: 20px; position: absolute; z-index: 10000; color: rgb(182, 255, 0)">fly
		along drone</a>
	<a href="#" onclick="stopFly()"
		style="right: 10px; top: 40px; position: absolute; z-index: 10000; color: rgb(182, 255, 0)">stop
		fly</a>
</body>
</html>