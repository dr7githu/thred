var key;
var targetLevel;
var renderReady = false;
var bConfig = false;
var planeInfo = [];
var dataMaking = false;

var clipPos = null;
var cubes = [];
var worldMat = null;
var cubeHeight = 0;
var tileSize = 0;
var refCenter = null;
var serverurl;
var minLevel;
var maxLevel;
var minHeight;
var maxHeight;
var downloadCount = 0;
var level0Height;
var pointColors = [];

onmessage = function (event)
{
   var inParam = event.data;

   if (inParam.cmworld3BaseRoot)
   {
      initWorker(inParam.cmworld3BaseRoot);
   }

   if (inParam.state == CMWORLD.Cube3DClipTarget.ID_SetLayerInfo) 
   {
      serverurl = inParam.serverUrl;
      targetLevel = inParam.targetLevel;
      tileSize = inParam.tileSize;
      cubeHeight = inParam.cubeHeight;
      level0Height = inParam.level0Height;

      minLevel = inParam.minLevel;
      maxLevel = inParam.maxLevel;
      minHeight = inParam.minHeight;
      maxHeight = inParam.maxHeight;

   }
   else if (inParam.state == CMWORLD.Cube3DClipTarget.ID_SetColorValue)
   {
      this.pointColors[inParam.value] = {
         r: inParam.r * 255,
         g: inParam.g * 255,
         b: inParam.b * 255
      };
   }
   else if (inParam.state == CMWORLD.Cube3DClipTarget.ID_SetPlaneInfo) 
   {
      // ImageDataBuffer를 생성하고 빈 내용을 채운다.
      var imageData = new Uint8ClampedArray(inParam.imageData);
      this.planeInfo[inParam.ID] = {
         ID: inParam.ID,
         lb: new THREE.Vector3(inParam.lbx, inParam.lby, inParam.lbz),
         lt: new THREE.Vector3(inParam.ltx, inParam.lty, inParam.ltz),
         rb: new THREE.Vector3(inParam.rbx, inParam.rby, inParam.rbz),
         rt: new THREE.Vector3(inParam.rtx, inParam.rty, inParam.rtz),
         w: inParam.w,
         h: inParam.h,
         image: imageData
      }
   }
   else if (inParam.state == CMWORLD.Cube3DClipTarget.ID_SetClipPosition) 
   {
      // 클립박스의 위치를 전달 받았다.
      // 위치에 해당하는 데이터들을 다운로드하고 
      // 다운로드가 완료되면 이미지를 준비한다.
      var needDataMake = false;
      if (clipPos == null)
      {
         clipPos = new THREE.Vector3(inParam.x, inParam.y, inParam.z);
         needDataMake = true;

      }
      else
      {
         if (inParam.x != clipPos.x || inParam.y != clipPos.y || inParam.z != clipPos.z)
         {
            needDataMake = true;
         }
         clipPos.x = inParam.x;
         clipPos.y = inParam.y;
         clipPos.z = inParam.z;
      }

      if (worldMat == null)
      {
         worldMat = new THREE.Matrix4();
      }

      console.log("SetClipPosition");
      worldMat.elements[0] = inParam.m0;
      worldMat.elements[1] = inParam.m1;
      worldMat.elements[2] = inParam.m2;
      worldMat.elements[3] = inParam.m3;
      worldMat.elements[4] = inParam.m4;
      worldMat.elements[5] = inParam.m5;
      worldMat.elements[6] = inParam.m6;
      worldMat.elements[7] = inParam.m7;
      worldMat.elements[8] = inParam.m8;
      worldMat.elements[9] = inParam.m9;
      worldMat.elements[10] = inParam.m10;
      worldMat.elements[11] = inParam.m11;
      worldMat.elements[12] = inParam.m12;
      worldMat.elements[13] = inParam.m13;
      worldMat.elements[14] = inParam.m14;
      worldMat.elements[15] = inParam.m15;

      refCenter.x = inParam.refX;
      refCenter.y = inParam.refY;
      refCenter.z = inParam.refZ;

      if (needDataMake == true)
      {
         if (dataMaking == true)
         {
            // 현재 작업 중인데 뭔가 달라졌다고 요청이 오면 무시하나?
            return;
         }

         dataMaking = true;

         makeImageData();

         dataMaking = false;
      }
   }
   else if (inParam.state == CMWORLD.Cube3DClipTarget.ID_GetPlaneImage) 
   {
      // 현재 준비된 이미지 데이터를 넘겨준다.
   }
   else if (inParam.state == CMWORLD.Cube3DClipTarget.ID_Finish) 
   {
      // 작업중인 내용을 모두 지우고 종류 한다.
   }
}

function sendImageData()
{
   // 준비가 끝났다고 생각하고 보낸다.
   for (var i in this.planeInfo)
   {
      postMessage({
         state: CMWORLD.Cube3DClipTarget.ID_GetPlaneImage,
         ID: this.planeInfo[i].ID,
         imageData: this.planeInfo[i].image
      });

    }
   console.log("worker : sendImageData");

   postMessage({
       state: CMWORLD.Cube3DClipTarget.ID_Finish,
   });
}

function setPixel(x, y, r, g, b, a, imageData, w)
{
   var pt = y * (w * 4) + x * 4;

   imageData[pt + 0] = r;
   imageData[pt + 1] = g;
   imageData[pt + 2] = b;
   imageData[pt + 3] = a;
}

// 최초로 워크를 기동했을때 초기화 할내용들
function initWorker(baseRoot)
{
   importScripts(baseRoot + 'cm_compile.js');
   importScripts(baseRoot + 'lib/three.min.js');
   importScripts(baseRoot + 'lib/msgpack.min.js');
   importScripts(baseRoot + 'lib/jszip.min.js');
	importScripts(baseRoot + 'Worker/cm_commonfunc.js');

   if (CMWORLD.Compile.DistributionMode)
   {
      importScripts(baseRoot + 'cm3webgl-0.4.5.min.js');
   }
   else
   {
      importScripts(baseRoot + 'cm_enums.js');
      importScripts(baseRoot + 'cm_const.js');
      importScripts(baseRoot + 'IO/cm_binaryreader.js');
      importScripts(baseRoot + 'Math3D/cm_mathengine.js');
      importScripts(baseRoot + 'Map/Cube/cm_cubegroup.js');
      importScripts(baseRoot + 'Map/Cube3d/c3_Math.js');
      importScripts(baseRoot + 'Map/Cube3d/c3_Cube3D.js');
      importScripts(baseRoot + 'Map/Cube3d/c3_RasterCube3D.js');
      importScripts(baseRoot + 'Map/Cube3d/c3_Cube3DTarget.js');
     
      importScripts(baseRoot + 'Map/Cube3d/c3_Cube3DClipTarget.js');
   }

   refCenter = new THREE.Vector3();
}


function workerTestSleep(milliSec)
{
	var nowTime = new Date();
	var stopTime = nowTime.getTime() + milliSec;

	while (true)
	{
		nowTime = new Date();

		if (nowTime.getTime() > stopTime)
		{
			return;
		}
	}
}

function localToWorldGeo(x, y, z)
{
   var pt = new THREE.Vector3(x, y, z);

   pt.applyMatrix4(worldMat);

   pt.add(refCenter);

   pt = CMWORLD.CmMathEngine.Cartesian2Geo(pt.x, pt.y, pt.z);

   return pt;
}


function getCubeIndexFromPositionRadius(level)
{
   var lon = clipPos.x;
   var lat = clipPos.y;
   var alt = clipPos.z;

   // 각 면에 대하여 모든 좌표를 얻어야 한다.
   // 각면의 좌표을 얻는다.
   var pt;
   var minX = Number.MAX_VALUE;
   var maxX = -Number.MAX_VALUE;
   var minY = Number.MAX_VALUE;
   var maxY = -Number.MAX_VALUE;
   var minZ = Number.MAX_VALUE;
   var maxZ = -Number.MAX_VALUE;

   for (var i in planeInfo)
   {
       pt = localToWorldGeo(planeInfo[i].lb.x, planeInfo[i].lb.y, planeInfo[i].lb.z);
       
       
      if (pt.x < minX) minX = pt.x;
      if (pt.x > maxX) maxX = pt.x;
      if (pt.y < minY) minY = pt.y;
      if (pt.y > maxY) maxY = pt.y;
      if (pt.z < minZ) minZ = pt.z;
      if (pt.z > maxZ) maxZ = pt.z;
      pt = localToWorldGeo(planeInfo[i].lt.x, planeInfo[i].lt.y, planeInfo[i].lt.z);
      if (pt.x < minX) minX = pt.x;
      if (pt.x > maxX) maxX = pt.x;
      if (pt.y < minY) minY = pt.y;
      if (pt.y > maxY) maxY = pt.y;
      if (pt.z < minZ) minZ = pt.z;
      if (pt.z > maxZ) maxZ = pt.z;
      pt = localToWorldGeo(planeInfo[i].rb.x, planeInfo[i].rb.y, planeInfo[i].rb.z);
      if (pt.x < minX) minX = pt.x;
      if (pt.x > maxX) maxX = pt.x;
      if (pt.y < minY) minY = pt.y;
      if (pt.y > maxY) maxY = pt.y;
      if (pt.z < minZ) minZ = pt.z;
      if (pt.z > maxZ) maxZ = pt.z;
      pt = localToWorldGeo(planeInfo[i].rt.x, planeInfo[i].rt.y, planeInfo[i].rt.z);
      if (pt.x < minX) minX = pt.x;
      if (pt.x > maxX) maxX = pt.x;
      if (pt.y < minY) minY = pt.y;
      if (pt.y > maxY) maxY = pt.y;
      if (pt.z < minZ) minZ = pt.z;
      if (pt.z > maxZ) maxZ = pt.z;
   }

   var minRow = CMWORLD.Cube3DMath.getRowFromLatitude(minY, tileSize);
   var maxRow = CMWORLD.Cube3DMath.getRowFromLatitude(maxY, tileSize);
   var minCol = CMWORLD.Cube3DMath.getColFromLongitude(minX, tileSize);
   var maxCol = CMWORLD.Cube3DMath.getColFromLongitude(maxX, tileSize);
   var minFloor = CMWORLD.Cube3DMath.getFloorFromAltitude(minZ - CMWORLD.cm_const.EarthRadius, cubeHeight);
   var maxFloor = CMWORLD.Cube3DMath.getFloorFromAltitude(maxZ - CMWORLD.cm_const.EarthRadius, cubeHeight);

   var row, col, floor;

   var retList = [];
   var key;

   for (floor = minFloor; floor <= maxFloor; floor++)
   {
      for (row = minRow; row <= maxRow; row++)
      {
         for (col = minCol; col <= maxCol; col++)
         {
            key = floor.toString() + ":" + row.toString() + "," + col.toString();
            retList[key] = {
               floor: floor, row: row, col: col
            }
         }
      }
   }

   return retList;
}

function getCubeUrl(level, row, col, floor)
{
   // 레벨안에 있는지 확인.
   if (targetLevel > maxLevel || targetLevel < minLevel)
   {
      return null;
   }

   var relStr = serverurl;
   relStr = relStr.replace(/{z}/gi, level.toString());
   relStr = relStr.replace(/{x}/gi, col.toString());
   relStr = relStr.replace(/{y}/gi, row.toString());
   relStr = relStr.replace(/{f}/gi, floor.toString());

   return relStr;
}

function readRasterData(data)
{
   var bytes = [];
   var cubedata = new CMWORLD.RasterCube3DData();

   var br = new CMWORLD.BinaryReader(data, false);

   bytes = br.readBytes(2);
   cubedata.vertsion = br.bin2String(bytes);

   if (cubedata.vertsion != "R0")
      return null;

   cubedata.level = br.readByte();
   cubedata.row = br.readInt32();
   cubedata.col = br.readInt32();
   cubedata.floor = br.readInt32();
   cubedata.dataBlockCount = br.readByte();
   cubedata.dataSidePointCount = br.readByte();
   cubedata.groundSurface = br.readByte();

   // level, row, col, floor을 이용해서 범위를 가져오자
   var boundary = CMWORLD.Cube3DMath.getBoundFromRowColFloor2(cubedata.level, cubedata.row, cubedata.col, cubedata.floor, tileSize, cubeHeight);
   cubedata.west = boundary.west;
   cubedata.east = boundary.east;
   cubedata.north = boundary.north;
   cubedata.south = boundary.south;
   cubedata.bottomHeight = boundary.bottomHeight;
   cubedata.topHeight = boundary.topHeight;
   cubedata.clon = (cubedata.west + cubedata.east) * 0.5;
   cubedata.clat = (cubedata.south + cubedata.north) * 0.5;
   cubedata.calt = (cubedata.bottomHeight + cubedata.topHeight) * 0.5;

   var halfDSPC = cubedata.dataSidePointCount / 2;
   var totalSubDataLength = halfDSPC * halfDSPC * halfDSPC;

   for (var i = 0; i < cubedata.dataBlockCount; i++)
   {
      var datablock = new CMWORLD.RasterCube3DDataBlock();
      datablock.dataType = br.readByte();

      switch (datablock.dataType)
      {
         case 1:
            {
               for (var j = CMWORLD.Cube3DPositionType.LBF; j <= CMWORLD.Cube3DPositionType.RTB; j++)
               {
                  datablock.subData[j] = br.readBytes(totalSubDataLength);
               }
            }
      }

      cubedata.dataBlock[i] = datablock;
   }

   return cubedata;
}

function makeImageData()
{
   // 먼저 필요한 격자들을 얻어와야 한다.
   var cubeIndex = getCubeIndexFromPositionRadius(targetLevel);

   // 기존 놈들중에 새로운 인덱스에 없는 놈들은 지운다.
   var downloadList = [];

   cubes = [];

   for (var key in cubeIndex)
   {
      downloadList[key] = cubeIndex[key];
   }

   // downloadList에 있는 놈들을 다운한다.
   var urlList = [];

   for (var key in downloadList)
   {
      var url = getCubeUrl(targetLevel, downloadList[key].row, downloadList[key].col, downloadList[key].floor);
      if (url != null)
      {
         urlList.push(url);
      }
   }

   // 이제 url 목록에 있는 데이터들을 로드하자.


   downloadCount = urlList.length;

   if (downloadCount == 0)
   {
      RenderImage();
   }
   else
   {
      var xhr;

      var that = this;
      for (var key in urlList)
      {
			xhr = CMWORLD.FuncForWorker.createCORSRequest('GET', urlList[key], false);
         if (xhr)
         {
            

            xhr.onload = function ()
            {
               if (xhr.status === 200)
               {
                  var buffer = xhr.response;

                  var new_zip = new JSZip();

                  new_zip.loadAsync(buffer)
                     .then(
                     function (contents)
                     {
                        Object.keys(contents.files).forEach(
                           function (filename)
                           {
                              new_zip.file(filename).async('arraybuffer').then(
                                 function (content)
                                 {
                                    // 여기서 뭔갈 해야 한다.
                                    var cubeData = that.readRasterData(content);
                                    var key = cubeData.floor.toString() + ":" + cubeData.row.toString() + "," + cubeData.col.toString();
                                    that.cubes[key] = cubeData;

                                    that.downloadCount--;

                                    if (that.downloadCount == 0)
                                    {
                                       // 이제 이미지를 만들고 처리해야 한다.
                                       that.RenderImage();
                                    }

                                 });
                           });
                     });
               }

            }

            xhr.send();
         }
         else
         {
            downloadCount--;
         }

         
      }

      // 여기는 다운로드가 문제가 있어서 안그린 곳이다.
      //RenderImage();
   }
}

function getValue(lon, lat, alt)
{
   // 주어진 좌표가 포함된 격자를 찿는다.
   // 해당격자내에서의 row, col, floor를 얻어서 인덱스 번호로 바꾼다.
   // 해당하는 인덱스의 값을 리턴한다.
   var clat;
   var clon;
   var calt;
   var subIndex;
   var xf;
   var yf;
   var zf;
   var row;
   var col;
   var floor;
   var half;
   var index;

   for (var key in this.cubes)
   {
      if (lon >= this.cubes[key].west && lon < this.cubes[key].east &&
         lat >= this.cubes[key].south && lat < this.cubes[key].north &&
         alt >= this.cubes[key].bottomHeight && alt < this.cubes[key].topHeight)
      {
         half = this.cubes[key].dataSidePointCount * 0.5;
         xf = (this.cubes[key].east - this.cubes[key].west) / this.cubes[key].dataSidePointCount;
         yf = (this.cubes[key].north - this.cubes[key].south) / this.cubes[key].dataSidePointCount;
         zf = (this.cubes[key].topHeight - this.cubes[key].bottomHeight) / this.cubes[key].dataSidePointCount;

         row = Math.floor((lat - this.cubes[key].south) / yf);
         col = Math.floor((lon - this.cubes[key].west) / xf);
         floor = Math.floor((alt - this.cubes[key].bottomHeight) / zf);

         // 호함된다.
         // 8개의 서브 객체중에 어디에 속하는지 확인한다.
         if (lon < this.cubes[key].clon)
         {
            if (lat < this.cubes[key].clat)
            {
               if (alt < this.cubes[key].calt)
               {
                  subIndex = CMWORLD.Cube3DPositionType.LBF;
                  // 그냥 사용
               }
               else
               {
                  subIndex = CMWORLD.Cube3DPositionType.LTF;
                  floor -= half;
               }
            }
            else
            {
               if (alt <= this.cubes[key].calt)
               {
                  subIndex = CMWORLD.Cube3DPositionType.LBB;
                  row -= half;
               }
               else
               {
                  subIndex = CMWORLD.Cube3DPositionType.LTB;
                  row -= half;
                  floor -= half;
               }
            }
         }
         else
         {
            if (lat <= this.cubes[key].clat)
            {
               if (alt < this.cubes[key].calt)
               {
                  subIndex = CMWORLD.Cube3DPositionType.RBF;
                  col -= half;
               }
               else
               {
                  subIndex = CMWORLD.Cube3DPositionType.RTF;
                  col -= half;
                  floor -= half;
               }
            }
            else
            {
               if (alt < this.cubes[key].calt)
               {
                  subIndex = CMWORLD.Cube3DPositionType.RBB;
                  col -= half;
                  row -= half;
               }
               else
               {
                  subIndex = CMWORLD.Cube3DPositionType.RTB;
                  col -= half;
                  row -= half;
                  floor -= half;
               }
            }
         }

         if (this.cubes[key].dataBlock[0].subData[subIndex])
         {
            index = floor * half * half + row * half + col;

            return this.cubes[key].dataBlock[0].subData[subIndex][index];
         }
         else
         {
            return null;
         }


      }

   }

   return null;
}

function getlerp(x1, y1, x2, y2, alpha)
{
   var v1 = new THREE.Vector2(x1, y1);
   var v2 = new THREE.Vector2(x2, y2);

   var ret = v1.lerp(v2, alpha);

   return ret;
}

function RenderImage()
{
   var len = 0;

   for (var i in this.cubes)
   {
      len++;
   }

   if (len == 0)
      return;

   var pt1 = new THREE.Vector3();
   var pt2 = new THREE.Vector3();
   var pt;
   var val;
   var lb, lt, rb, rt;

   var uvlb = new THREE.Vector2(0, 0);
   var uvlt = new THREE.Vector2(0, 1);
   var uvrt = new THREE.Vector2(1, 1);
   var uvrb = new THREE.Vector2(1, 0);
   
   var uvpt1 = new THREE.Vector2();
   var uvpt2 = new THREE.Vector2();
   var uvpt = new THREE.Vector2();
   var u, v;

   for (var key in this.planeInfo)
   //var key = 0;
   {
      var xf = 1.0 / this.planeInfo[key].w;
      var yf = 1.0 / this.planeInfo[key].h;

      var xdist = 0;
      var ydist = 0;

      // 귀퉁이 좌표들을 변환해야 한다.
      lb = localToWorldGeo(this.planeInfo[key].lb.x, this.planeInfo[key].lb.y, this.planeInfo[key].lb.z); 
      lt = localToWorldGeo(this.planeInfo[key].lt.x, this.planeInfo[key].lt.y, this.planeInfo[key].lt.z);
      rb = localToWorldGeo(this.planeInfo[key].rb.x, this.planeInfo[key].rb.y, this.planeInfo[key].rb.z);
      rt = localToWorldGeo(this.planeInfo[key].rt.x, this.planeInfo[key].rt.y, this.planeInfo[key].rt.z);
       /*
      console.log("lt : " + lt.x.toString() + ", " + lt.y.toString() + ", " + (lt.z - CMWORLD.cm_const.EarthRadius).toString());
      console.log("lb : " + lb.x.toString() + ", " + lb.y.toString() + ", " + (lb.z - CMWORLD.cm_const.EarthRadius).toString());
      console.log("rt : " + rt.x.toString() + ", " + rt.y.toString() + ", " + (rt.z - CMWORLD.cm_const.EarthRadius).toString());
      console.log("rb : " + rb.x.toString() + ", " + rb.y.toString() + ", " + (rb.z - CMWORLD.cm_const.EarthRadius).toString());
      */

      var cc = 0;
      for (var y = 0; y < this.planeInfo[key].h; y++)
      {
         xdist = 0;
         for (var x = 0; x < this.planeInfo[key].w; x++)
         {
             pt1.set(lb.x, lb.y, lb.z);
             pt2.set(lt.x, lt.y, lt.z);
            pt1 = pt1.lerp(rb, xdist);
            pt2 = pt2.lerp(rt, xdist);

            pt = pt2.lerp(pt1, ydist);


            uvpt1 = getlerp(uvlb.x, uvlb.y, uvrb.x, uvrb.y, xdist);
            uvpt2 = getlerp(uvlt.x, uvlt.y, uvrt.x, uvrt.y, xdist);

            uvpt = getlerp(uvpt1.x, uvpt1.y, uvpt2.x, uvpt2.y, ydist);
            u = Math.floor(uvpt.x * (this.planeInfo[key].w - 0.5));
            v = Math.floor(uvpt.y * (this.planeInfo[key].h - 0.5));

            cc++;
            // 이제 이점을 이용해서 값을 얻는다.
            if (cc > 100)
            {
               val = getValue(pt.x, pt.y, pt.z);
            }
            else
            {
               val = getValue(pt.x, pt.y, pt.z);
            }
            //console.log(val);
            
            if (this.pointColors[val] != null)
            {
                this.setPixel(u, v, this.pointColors[val].r, this.pointColors[val].g, this.pointColors[val].b, 255, this.planeInfo[key].image, this.planeInfo[key].w);
            }
            else
            {
               //this.setPixel(u, v, 0, 0, 0, 0, this.planeInfo[key].image, this.planeInfo[key].w);
                this.setPixel(u, v, 0, 0, 0, 0, this.planeInfo[key].image, this.planeInfo[key].w);
            }
            /*

            if (x < 10)
            {
               this.setPixel(u, v, 255, 0, 0, 255, this.planeInfo[key].image, this.planeInfo[key].w);
            }
            else
            {
               this.setPixel(u, v, 0, 0, 0, 255, this.planeInfo[key].image, this.planeInfo[key].w);
            }
            */
            
            xdist += xf;
         }
         ydist += yf;
      }
   }
   sendImageData();
}