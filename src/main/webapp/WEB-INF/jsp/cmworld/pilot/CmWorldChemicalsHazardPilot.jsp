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

var userLayer10;
var userLayer30;
var userLayer20;
var userLayer40;
var fistGroundPoint = null;
var secondGroundPoint = null;
var selectGroundPointMode = false;
var cube10mScene = null;
var cube20mScene = null;
var curState = 0;
var outlineGeo = null;
var outlineMat = null;
var outlineMat1 = null;
var boxGeo = null;
var boxMat = null;
var cubeSize = 50;
var cubeGeo, cubeGeo20, cubeMaterial, cubeWireMat;
var moveCount;
var moveTarget;
var correctHeightTarget = 0;
var correctHeight = 0;
var modeCorrectHeight = false;
var modeFire = false;
var sid = null;
var fireCount = 0;
var font = null;
var backimage = null;
var selectMode = false;

function loadFont()
{
    if (font)
        return;

    var fontName = "optimer";
    var fontWeight = "bold";

    var loader = new THREE.FontLoader();
    loader.load('\/skeleton\/three\/examples\/fonts\/' + fontName + '_' + fontWeight + '.typeface.json', function (response)
    {
        font = response;
    });
}

onupdateobject = function (userObject, deltatime)
{
    var d = new Date();

    context.clearRect(0, 0, backimage.width, backimage.height);
    context.drawImage(backimage, 0, 0, backimage.width, backimage.height);
    /*
    var text = d.getHours().toLocaleString('en-US', { minimumIntegerDigits: 2, useGrouping: false }) + " : "
        + d.getMinutes().toLocaleString('en-US', { minimumIntegerDigits: 2, useGrouping: false }) + " : "
        + d.getSeconds().toLocaleString('en-US', { minimumIntegerDigits: 2, useGrouping: false });
    context.drawImage(backimage, 0, 0, backimage.width, backimage.height);
    context.font = "36px arial bold";
    context.fillStyle = "white";
    context.fillText(text, 5, 40);
    context.lineWidth = 1;
    context.strokeStyle = "red";
    context.strokeText(text, 5, 40);
    */

    userObject.updateMaterial();
}

init = function ()
{
    if (userLayer30 == null)
    {
        userLayer30 = new CMWORLD.UserObjectLayer("user30");
        cmworld.addLayer(userLayer30);
    }

    if (userLayer10 == null)
    {
        userLayer10 = new CMWORLD.UserObjectLayer("user10");
        cmworld.addLayer(userLayer10);
    }

    userLayer10.clear();

    if (userLayer20 == null)
    {
        userLayer20 = new CMWORLD.UserObjectLayer("user20");
        cmworld.addLayer(userLayer20);
    }

    userLayer20.clear();

    cubeGeo = new THREE.CubeGeometry(22, 28, 20);
    cubeGeo20 = new THREE.CubeGeometry(44, 56, 40);
    //cubeGeo.computeFaceNormals();
    //cubeGeo.normalsNeedUpdate = true;
    //cubeMaterial = new THREE.MeshLambertMaterial({ color: 0xfeb74c, /*map: new THREE.TextureLoader().load("textures/square-outline-textured.png")*/ });

    cubeMaterial = new THREE.MeshPhongMaterial({
        color: 0x808080,
        transparent: true,
        opacity: 0.4
    });

    cubeWireMat = new THREE.MeshBasicMaterial({
        color: 0xff0000,
        transparent: true,
        wireframe: true
    });

    cubeWireMat.wireframe = true;
    //cubeMaterial = new THREEx.SolidWireframeMaterial(cubeGeo);

    loadFont();


    if (userLayer40 == null)
    {
        userLayer40 = new CMWORLD.UserObjectLayer("user40");
        cmworld.addLayer(userLayer40);
    }

    userLayer40.clear();

    /*
    var geometry = new THREE.BufferGeometry();
    // create a simple square shape. We duplicate the top left and bottom right
    // vertices because each vertex needs to appear once per triangle.

    var earthRadius = CMWORLD.cm_const.EarthRadius + 50;
    var pos = [];

    pos.push(CMWORLD.CmMathEngine.Geo2Cartesian(127.10144169849268, 37.510399772681026, 14.366467135027051 + earthRadius));
    pos.push(CMWORLD.CmMathEngine.Geo2Cartesian(127.10144169849268, 37.510399772681026, -50 + earthRadius));
    pos.push(CMWORLD.CmMathEngine.Geo2Cartesian(127.10134714692765, 37.51391758491301, 14.634756354615092 + earthRadius));

    pos.push(CMWORLD.CmMathEngine.Geo2Cartesian(127.10134714692765, 37.51391758491301, 14.634756354615092 + earthRadius));
    pos.push(CMWORLD.CmMathEngine.Geo2Cartesian(127.10144169849268, 37.510399772681026, -50 + earthRadius));
    pos.push(CMWORLD.CmMathEngine.Geo2Cartesian(127.10134714692765, 37.51391758491301, -50 + earthRadius));

    //geometry.vertices = pos;

    var vertices = new Float32Array([
        pos[0].x, pos[0].y, pos[0].z,
        pos[1].x, pos[1].y, pos[1].z,
        pos[2].x, pos[2].y, pos[2].z,

        pos[3].x, pos[3].y, pos[3].z,
        pos[4].x, pos[4].y, pos[4].z,
        pos[5].x, pos[5].y, pos[5].z,
    ]);

    // itemSize = 3 because there are 3 values (components) per vertex
    geometry.addAttribute('position', new THREE.BufferAttribute(vertices, 3));

    var material = new THREE.MeshBasicMaterial({ color: 0xff0000, side: THREE.DoubleSide });
    var mesh = new THREE.Mesh(geometry, material);


    var obj = new CMWORLD.UserObject("underground", mesh, new THREE.Vector3(127.10144169849268, 37.510399772681026, 14.366467135027051));
    obj.rotate4GlobeEarth();
    userLayer40.add(obj);
    */

    //var img = document.createElement("img");

    //img.onload = function (image)
    //{
    //    backimage = image.currentTarget;

    //    canvas = document.createElement("canvas");
    //    canvas.width = image.currentTarget.width;
    //    canvas.height = image.currentTarget.height;

    //    context = canvas.getContext("2d");

    //    var obj = CMWORLD.UserObject.createPlane("supermodel", 127.10144169849268, 37.510399772681026, -200, 127.10134714692765, 37.51391758491301, 54.634756354615092-40, canvas, true, onupdateobject);

    //    userLayer40.add(obj);
    //}

    //img.src = './textures/underground.jpg';
}

function makeSampleCubes()
{

}

function mouseClick(event)
{
    if (event)
    {
        if (event.shiftKey)
        {

            if (cmworld)
            {
                var mousePos = cmworld.convertPagePosToCanvasPos(event.pageX, event.pageY);

                var pos = cmworld.getHitCoordinate(mousePos.x, mousePos.y);

                if (pos)
                {
                    var coordtext = document.getElementById("coordtext");

                    if (coordtext)
                    {
                        var str = "(" + pos.x.toString() + ", " + pos.y.toString() + ", " + pos.z.toString() + ")\n";
                        console.log(str);
                    }
                }
            }
        }
        else if (event.ctrlKey)
        {
            var mousePos = cmworld.convertPagePosToCanvasPos(event.pageX, event.pageY);

            if (cmworld)
            {
                var info = cmworld.getHitInformationOnObject(mousePos.x, mousePos.y);

                if (info)
                {
                    if (info.hasOwnProperty("key"))
                    {
                        console.log(info.key + "\n");
                    }

                    // 이걸 통해서 CmUserObject의 정보를 얻을 수 있다.
                    if (info.userObject)
                    {
                        var cmUserObject = info.userObject;
                        console.log(cmUserObject.name);
                    }

                    // 이건 threejs object 정보
                    if (info.hasOwnProperty("object"))
                    {
                        console.log(info.object.toString());
                    }
                }
            }
        }
        else if (event.altKey)
        {
            // camera의 현재 상태 값을 돌려 준다.
            var camerapos = cmworld.getCamera().getPositionGeo();
            var lookpos = cmworld.getCamera().getLookPositionGeo();

            if (camerapos)
            {
                var coordtext = document.getElementById("coordtext");

                if (coordtext)
                {
                    var str = "camera(" + camerapos.x.toString() + ", " + camerapos.y.toString() + ", " + camerapos.z.toString() + ")\n"
                        + "look  (" + lookpos.x.toString() + ", " + lookpos.y.toString() + ", " + lookpos.z.toString() + ")\n";

                    console.log(str);
                }
            }
        }
    }
}


function addText(str, lat, lng, elv)
{

    var userLayer = userLayer20();
    userLayer.clear();

    // text
    if (font)
    {
        var size = 100;
        var height = 10;
        var curveSegments = 4;
        var bevelThickness = 2;
        var bevelSize = 1.5;
        var bevelSegments = 3;
        var bevelEnabled = true;


        var textGeo = new THREE.TextGeometry(str, {
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
            new THREE.MeshPhongMaterial({ color: 0x0c2800, shading: THREE.FlatShading }), // front
            new THREE.MeshPhongMaterial({ color: 0x214E0E }) // side
        ]);


        textMesh1 = new THREE.Mesh(textGeo, material);

        var cmObj1 = new CMWORLD.UserObject("text", textMesh1, new THREE.Vector3(lng, lat, elv), null);
        // cmworld 표면에 맞도록 회전.
        cmObj1.rotate4GlobeEarth();
        userLayer.add(cmObj1);
    }
}


function onOffBuilding()
{

    var layerName = "facility_build";
    var layer = cmworldViewer.getLayer(layerName);
    if (layer != null)
    {
        layer.visible = !layer.visible;
    }
}

function rotateAroundCamera()
{
}

function explose(id)
{
    var nid = new Array();

    for (var x = 0; x < 37; x++)
    {
        nid[x] = new Array();

        for (var y = 0; y < 36; y++)
        {
            nid[x][y] = new Array();
            for (var z = 0; z < 12; z++)
            {
                nid[x][y][z] = id[x][y][z];
            }
        }
    }

    for (var x = 0; x < 37; x++)
    {
        for (var y = 0; y < 36; y++)
        {
            for (var z = 0; z < 12; z++)
            {
                if (id[x][y][z] == 1 || id[x][y][z] == -1)
                {
                    for (var ix = x - 1; ix <= x + 1; ix++)
                    {
                        for (var iy = y - 1; iy <= y + 1; iy++)
                        {
                            for (var iz = z - 1; iz <= z + 1; iz++)
                            {
                                if (ix >= 0 && ix < 37 && iy >= 0 && iy < 36 && iz >= 0 && iz < 12)
                                {
                                    if (id[ix][iy][iz] == 0)
                                    {

                                        var f = Math.random();

                                        if (iz >= z)
                                        {
                                            if (f < 0.1)
                                            {
                                                nid[ix][iy][iz] = id[x][y][z];
                                            }
                                        }
                                        else
                                        {
                                            if (f < 0.01)
                                            {
                                                nid[ix][iy][iz] = id[x][y][z];
                                            }
                                        }
                                    }
                                    else
                                    {
                                        var f = Math.random();

                                        if (f < 0.1)
                                        {
                                            nid[ix][iy][iz] = 0.5;
                                        }
                                    }
                                }
                            }

                        }

                    }
                }
            }
        }
    }

    return nid;
}

function fire()
{
    $("#txtLabel").text("유독가스 확산");
    $("#legend").show();

    fireCount = 15;

    sid = new Array();

    for (var x = 0; x < 37; x++)
    {
        sid[x] = new Array();

        for (var y = 0; y < 36; y++)
        {
            sid[x][y] = new Array();
            for (var z = 0; z < 12; z++)
            {
                sid[x][y][z] = 0;
            }
        }
    }

    sid[25][25][2] = 1;
    sid[13][15][4] = -1;
    modeFire = true;
}

function View10mCube()
{
    $("#legend").hide();
    if (userLayer10.userObjects == undefined || userLayer10.userObjects.length < 1)
    {
        var px = 127.09812137375809;
        var py = 37.507568118168656;
        var pz = 0;

        var cubeSpace = 20;
        var cubeSpaceDeg = cubeSpace / 80000;

        var LT = new THREE.Vector3(px, py + 0.009, 200);
        var RB = new THREE.Vector3(px + 0.009, py, -40);

        //voxel.position.copy(intersect.point).add(intersect.face.normal);
        //voxel.position.divideScalar(50).floor().multiplyScalar(50).addScalar(25);
        var ix = 0;
        var iy = 0;
        var iz = 0;

        for (var h = RB.z; h < LT.z; h += cubeSpace)
        {
            for (var y = RB.y; y < LT.y; y += cubeSpaceDeg)
            {
                for (var x = LT.x; x < RB.x; x += cubeSpaceDeg)
                {
                    c = 0xffffff;

                    cubeMaterial = new THREE.MeshPhongMaterial({
                        color: c,
                        transparent: true,
                        opacity: 0.4,

                    });

                    var voxelMesh = new THREE.Mesh(cubeGeo, cubeMaterial);
                    var cubeCmObj = new CMWORLD.UserObject("cube", voxelMesh, new THREE.Vector3(x, y, 0));
                    cubeCmObj.targetHeight = h;
                    cubeCmObj.rotate4GlobeEarth();
                    cubeCmObj.cubeid = new THREE.Vector3(ix, iy, iz);
                    cubeCmObj.cubeValue = 0;
                    userLayer10.add(cubeCmObj);

                    /*

                    voxelMesh = new THREE.Mesh(cubeGeo, cubeWireMat);
                    cubeCmObj = new CMWORLD.UserObject("cubewire", voxelMesh, new THREE.Vector3(x, y, h));
                    cubeCmObj.rotate4GlobeEarth();
                    userLayer10.add(cubeCmObj);
                    */
                    ix++;

                }
                iy++;
                ix = 0;
            }
            iz++;
            ix = 0;
            iy = 0;
        }



        userLayer10.visible = true;
    }
    else
    {
        userLayer10.visible = !userLayer10.visible;
        for (var i in userLayer10.userObjects)
        {
            var obj = userLayer10.userObjects[i];

            obj.object.material.color.setHex(0xffffff);
            obj.visible = userLayer10.visible;
        }
    }

    /*

    if (userLayer10.children == undefined || userLayer10.children.length < 1)
    {

    }
    */
    $("#txtLabel").text("3지점에서 유독가스 발생");
}

function View30mCube()
{
    if (userLayer30.userObjects == undefined || userLayer30.userObjects.length < 1)
    {
        var px = 127.09812137375809;
        var py = 37.507568118168656;
        var pz = 0;

        var cubeSpace = 20;
        var cubeSpaceDeg = cubeSpace / 80000;

        var LT = new THREE.Vector3(px, py + 0.009, 200);
        var RB = new THREE.Vector3(px + 0.009, py, -40);

        //voxel.position.copy(intersect.point).add(intersect.face.normal);
        //voxel.position.divideScalar(50).floor().multiplyScalar(50).addScalar(25);
        var ix = 0;
        var iy = 0;
        var iz = 0;

        for (var h = RB.z; h < LT.z; h += cubeSpace)
        {
            for (var y = RB.y; y < LT.y; y += cubeSpaceDeg)
            {
                for (var x = LT.x; x < RB.x; x += cubeSpaceDeg)
                {
                    c = 0xffffff;

                    cubeMaterial = new THREE.MeshPhongMaterial({
                        color: c,
                        transparent: true,
                        opacity: 0.4,
                        wireframe: true
                    });

                    var voxelMesh = new THREE.Mesh(cubeGeo, cubeMaterial);
                    var cubeCmObj = new CMWORLD.UserObject("cube", voxelMesh, new THREE.Vector3(x, y, h));
                    cubeCmObj.targetHeight = h;
                    cubeCmObj.rotate4GlobeEarth();
                    cubeCmObj.cubeid = new THREE.Vector3(ix, iy, iz);
                    cubeCmObj.cubeValue = 0;
                    userLayer30.add(cubeCmObj);

                    /*

                    voxelMesh = new THREE.Mesh(cubeGeo, cubeWireMat);
                    cubeCmObj = new CMWORLD.UserObject("cubewire", voxelMesh, new THREE.Vector3(x, y, h));
                    cubeCmObj.rotate4GlobeEarth();
                    userLayer10.add(cubeCmObj);
                    */
                    ix++;

                }
                iy++;
                ix = 0;
            }
            iz++;
            ix = 0;
            iy = 0;
        }



        userLayer30.visible = true;
    }
    else
    {
        userLayer30.visible = !userLayer30.visible;
        for (var i in userLayer30.userObjects)
        {
            var obj = userLayer30.userObjects[i];

            obj.visible = userLayer30.visible;
        }
    }

    /*

    if (userLayer10.children == undefined || userLayer10.children.length < 1)
    {

    }
    */

}

function moveBox()
{
    $("#txtLabel").text("분석영역 및 입체격자 생성");
    $("#legend").hide();
    moveTarget = 100;
    moveCount = 100;
}

function ViewAll()
{
    for (var i in userLayer10.userObjects)
    {
        var obj = userLayer10.userObjects[i];

        var pos = obj.getPosition();
        var h = obj.targetHeight;

        obj.setPosition(pos.x, pos.y, h);
        obj.visible = true;
    }
}

function correct()
{
    for (var i in userLayer10.userObjects)
    {
        var obj = userLayer10.userObjects[i];

        if (obj.cubeValue == 0)
        {
            obj.visible = false;
        }
    }
}

function correct2()
{
    $("#txtLabel").text("유독가스 확산");
    $("#legend").show();

    for (var i in userLayer10.userObjects)
    {
        var obj = userLayer10.userObjects[i];

        obj.visible = false;
    }

    correctHeightTarget = 240;
    correctHeight = -40;
    modeCorrectHeight = true;
}

function View20mCube()
{
    if (userLayer20.userObjects == undefined || userLayer20.userObjects.length < 1)
    {
        var px = 127.09812137375809;
        var py = 37.507568118168656;
        var pz = 0;

        var cubeSpace = 40;
        var cubeSpaceDeg = cubeSpace / 80000;

        var LT = new THREE.Vector3(px, py + 0.009, 200);
        var RB = new THREE.Vector3(px + 0.009, py, -40);

        //voxel.position.copy(intersect.point).add(intersect.face.normal);
        //voxel.position.divideScalar(50).floor().multiplyScalar(50).addScalar(25);
        var ix = 0;
        var iy = 0;
        var iz = 0;

        for (var h = RB.z; h < LT.z; h += cubeSpace)
        {
            for (var y = RB.y; y < LT.y; y += cubeSpaceDeg)
            {
                for (var x = LT.x; x < RB.x; x += cubeSpaceDeg)
                {
                    c = 0xffffff;

                    cubeMaterial = new THREE.MeshPhongMaterial({
                        color: c,
                        transparent: true,
                        opacity: 0.4,
                        wireframe : true
                    });

                    var voxelMesh = new THREE.Mesh(cubeGeo20, cubeMaterial);
                    voxelMesh.scal
                    var cubeCmObj = new CMWORLD.UserObject("cube", voxelMesh, new THREE.Vector3(x, y, h));
                    cubeCmObj.targetHeight = h;
                    cubeCmObj.rotate4GlobeEarth();
                    cubeCmObj.cubeid = new THREE.Vector3(ix, iy, iz);
                    cubeCmObj.cubeValue = 0;
                    userLayer20.add(cubeCmObj);

                    ix++;

                }
                iy++;
                ix = 0;
            }
            iz++;
            ix = 0;
            iy = 0;
        }



        userLayer20.visible = true;
    }
    else
    {
        userLayer20.visible = !userLayer20.visible;
        for(i in userLayer20.userObjects)
        {
            var obj = userLayer20.userObjects[i];

            obj.visible = userLayer20.visible;
        }
    }

}

function OnUpdate()
{
    if (moveCount > 0)
    {
        if (userLayer10)
        {
            for (var i in userLayer10.userObjects)
            {
                var obj = userLayer10.userObjects[i];

                var pos = obj.getPosition();
                var h = (obj.targetHeight / moveTarget) * (moveTarget - moveCount);

                obj.setPosition(pos.x, pos.y, h);


            }
        }

        moveCount = moveCount - 1;

        $("#all").text(userLayer10.userObjects.length);
    }

    if (modeCorrectHeight == true)
    {
        if (correctHeight >= correctHeightTarget)
        {
            modeCorrectHeight = false;
        }
        else
        {
            correctHeight += 1;

            if (userLayer10)
            {
                for (var i in userLayer10.userObjects)
                {
                    var obj = userLayer10.userObjects[i];
                    var r = sid[obj.cubeid.x][obj.cubeid.y][obj.cubeid.z];

                    if (r != 0)
                    {
                        if (obj.visible == false)
                        {
                            var pos = obj.getPosition();

                            if (pos.z <= correctHeight)
                            {
                                obj.visible = true;
                            }
                        }
                    }
                }
            }
        }
    }

    if (modeFire == true)
    {
        sid = explose(sid);

        if (userLayer10)
        {
            var ir = 0, ig = 0, ib = 0;
            for (var i in userLayer10.userObjects)
            {
                var obj = userLayer10.userObjects[i];
                var r = sid[obj.cubeid.x][obj.cubeid.y][obj.cubeid.z]
                if (r == 0)
                {
                    obj.visible = false;
                }
                else
                {
                    var c = 0xffffff;

                    if (r == 1)
                    {
                        //c = 0x1F3F56;
                        c = 0xff0000;
                        $("#red").text(ir);
                        ir++;
                    }
                    else if (r == -1)
                    {
                        //c = 0x732545;
                        c = 0x0000ff;
                        $("#blue").text(ib);
                        ib++
                    }
                    else if (r == 0.5)
                    {
                        c = 0x00ff00;
                        $("#green").text(ig);
                        ig++;
                    }

                    obj.object.material.color.setHex(c);
                    obj.object.material.needsUpdate = true;
                    obj.cubeValue = r;
                    obj.visible = true;
                }
            }
        }

        fireCount--;

        if (fireCount < 0)
        {
            modeFire = false;
            fireCount = 0;
        }

    }
}

function ViewToggle()
{
    View30mCube();
    View20mCube();
}

function underground()
{
    var near = cmworld.getCameraNear();

    if (near == 200)
    {
        cmworld.setCameraNear(1);
    }
    else
    {
        cmworld.setCameraNear(200);
    }
}

function selectCube()
{
    if (userLayer10)
    {
        for (var i in userLayer10.userObjects)
        {
            var obj = userLayer10.userObjects[i];

            if (selectMode == true)
            {

                if (obj.cubeid.x == 0 && obj.cubeid.y == 30 && obj.cubeid.z == 10)
                {
                    obj.object.material.color.setHex(0xff0000);
                    obj.object.material.needsUpdate = true;
                }
                else
                {
                    obj.object.material.color.setHex(0xffffff);
                    obj.object.material.needsUpdate = true;
                }
            }
            else
            {
                obj.object.material.color.setHex(0xffffff);
                obj.object.material.needsUpdate = true;
            }
        }

        selectMode = !selectMode;
    }


}

function correct3()
{
    if (userLayer10)
    {
        for (var i in userLayer10.userObjects)
        {
            var obj = userLayer10.userObjects[i];

            var r = sid[obj.cubeid.x][obj.cubeid.y][obj.cubeid.z];

            if (r == 0.5)
            {
                obj.visible = true;
            }
            else
            {
                obj.visible = false;
            }
        }
    }


}

window.onload = function ()
{
    var canvas = document.querySelector("#cmworldCanvas");
    var siteRoot = CMWORLD.Compile.getSiteRootUrl();

    canvas.onclick = mouseClick;

    cmworld = new CMWORLD.CmWorld3(canvas, 127.09812137375809, 37.507568118168656, 508.48281691968441, { toptilespan: 36 }, OnUpdate);
    cmworld.option.worldTimer.setStartDateTime(2015, 7, 12, 14, 0, 0, 0);

    //gliEmbedDebug = true;
    var serverUri = "http://xdworld.vworld.kr:8080/XDServer";
    cmworld.addBaseImageLayer(serverUri + "/requestLayerNode?APIKey=767B7ADF-10BA-3D86-AB7E-02816B5B92E9&Layer=tile_mo_HD&Level={z}&IDX={x}&IDY={y}", 0, 15, 90, -90, -180, 180);
    cmworld.addTerrainLayer("terrain", serverUri + "/requestLayerNode?APIKey=767B7ADF-10BA-3D86-AB7E-02816B5B92E9&Layer=dem&Level={z}&IDX={x}&IDY={y}", 0, 15, 90, -90, -180, 180, "");

    cmworld.addReal3DLayer("facility_build", serverUri + "/requestLayerNode?Layer=facility_build&Level={z}&IDX={x}&IDY={y}&APIKey=767B7ADF-10BA-3D86-AB7E-02816B5B92E9",
        serverUri + "/requestLayerObject?APIKey=767B7ADF-10BA-3D86-AB7E-02816B5B92E9&Layer=facility_build&Level={z}&IDX={x}&IDY={y}&DataFile={f}", "facility_build", 0, 15, 90, -90, -180, 180, "dat");

    cmworld.addReal3DLayer("facility_build_at", serverUri + "/requestLayerNode?Layer=facility_build_at&Level={z}&IDX={x}&IDY={y}&APIKey=767B7ADF-10BA-3D86-AB7E-02816B5B92E9",
        serverUri + "/requestLayerObject?APIKey=767B7ADF-10BA-3D86-AB7E-02816B5B92E9&Layer=facility_build_at&Level={z}&IDX={x}&IDY={y}&DataFile={f}", "facility_build_at", 0, 15, 90, -90, -180, 180, "dat");

    cmworld.addReal3DLayer("facility_bridge", serverUri + "/requestLayerNode?Layer=facility_bridge&Level={z}&IDX={x}&IDY={y}&APIKey=767B7ADF-10BA-3D86-AB7E-02816B5B92E9",
        serverUri + "/requestLayerObject?APIKey=767B7ADF-10BA-3D86-AB7E-02816B5B92E9&Layer=facility_bridge&Level={z}&IDX={x}&IDY={y}&DataFile={f}", "facility_bridge", 0, 14, 90, -90, -180, 180, "dat");


    if (CMWORLD.Compile.DistributionMode == false)
    {
        cmworld.option.showFPS(true);
    }

    init();


};
</script>

<div class="panel pad-all">
	<div class="panel-heading">
		<h3 class="panel-title">Harzard</h3>
	</div>
	<!--Panel body-->
	<div class="panel-body">
		<div class="row">
			<button class="btn btn-dark" onclick="View10mCube()">onOff 10m Cube</button>
			<button class="btn btn-primary" onclick="moveBox()">moveBox</button>
			<button class="btn btn-info" onclick="fire()">fire</button>
			<!-- 					
					<button class="btn btn-default" onclick="correct2()">correct2</button> 
					<button class="btn btn-default" onclick="ViewAll()">ViewAll</button> 
					<button class="btn btn-default" onclick="onOffBuilding()">OnOff Building</button> 
-->
			<button class="btn btn-success" onclick="View30mCube()">onOff 10m Wire</button>
			<!-- 					
					<button class="btn btn-default" onclick="correct()">correct</button>  
-->
			<button class="btn btn-mint" onclick="rotateAroundCamera()">rotateAroundCamera</button>
			<button class="btn btn-warning" onclick="View20mCube()">onOff 20m Cube</button>
			<button class="btn btn-danger" onclick="ViewToggle()">ViewToggle</button>
			<button class="btn btn-pink" onclick="underground()">underground</button>
			<button class="btn btn-purple" onclick="selectCube()">selectCube</button>
			<!--  
					<button class="btn btn-default" onclick="correct3()">correct3</button>
-->

		</div>
		<div class="row mar-top" style="overflow: hidden">
			<div class="pad-right">
				<canvas id="cmworldCanvas"></canvas>
			</div>
		</div>
	</div>
</div>

<%-- 
<div class="row">
	<div class="panel">
		<div class="panel-heading">
			<h3 id="txtLabel" class="panel-title">Harzard</h3>
		</div>

		<!--Panel body-->
		<div class="panel-body">
			<div class="row">
				<div class="col-lg-1 text-xs">

										<div id="legend" style="position: absolute; height: auto; width: 200px; top: 50px; left: 10px; background-color: white; padding: 10px 5px; display: none; ">
						<table>
							<caption>범례</caption>
							<tbody>
								<tr>
									<td style="width: 80px; text-align: center;">분석면적</td>
									<th id="all" style="text-align: center; width: 55%;">0</th>
								</tr>
								<tr>
									<td style="text-align: center;">빨간가스</td>
									<th id="red" style="background-color: rgb(255, 0, 0); text-align: center;">0</th>
								</tr>
								<tr>
									<td style="text-align: center;">파란가스</td>
									<th id="blue" style="background-color: rgb(0, 0, 255); text-align: center;">0</th>
								</tr>
								<tr>
									<td style="text-align: center;">혼합</td>
									<th id="green" style="background-color: rgb(0, 255, 0); text-align: center;">0</th>
								</tr>
							</tbody>
						</table>
					</div>
					
				</div>
				<div class="col-lg-11 text-right">
					<button class="btn btn-dark" onclick="View10mCube()">onOff 10m Cube</button>
					<button class="btn btn-primary" onclick="moveBox()">moveBox</button>
					<button class="btn btn-info" onclick="fire()">fire</button>
					<!-- 					
					<button class="btn btn-default" onclick="correct2()">correct2</button> 
					<button class="btn btn-default" onclick="ViewAll()">ViewAll</button> 
					<button class="btn btn-default" onclick="onOffBuilding()">OnOff Building</button> 
-->
					<button class="btn btn-success" onclick="View30mCube()">onOff 10m Wire</button>
					<!-- 					
					<button class="btn btn-default" onclick="correct()">correct</button>  
-->
					<button class="btn btn-mint" onclick="rotateAroundCamera()">rotateAroundCamera</button>
					<button class="btn btn-warning" onclick="View20mCube()">onOff 20m Cube</button>
					<button class="btn btn-danger" onclick="ViewToggle()">ViewToggle</button>
					<button class="btn btn-pink" onclick="underground()">underground</button>
					<button class="btn btn-purple" onclick="selectCube()">selectCube</button>
					<!--  
					<button class="btn btn-default" onclick="correct3()">correct3</button>
-->
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
</div>

 --%>