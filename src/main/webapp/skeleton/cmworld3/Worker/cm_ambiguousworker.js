var ResponseData;
var imageDownOK = false;
var terrainDownOK = false;
var m_Head;
var Origin;
//var EarthRadius = CMWORLD.cm_const.EarthRadius;


/* 타일 하나가 가지고 있는 데이터 목록들*/
cm_tiledata = function () {
    this.vertices = [];
    this.verticeslength = 0;

    this.triangles = [];
    this.triangleslength = 0;

    this.uv = [];
    this.uvlength = 0;
}


QuadImageTileResponse = function () {
    this.NWdata = null;
    this.NEdata = null;
    this.SWdata = null;
    this.SEdata = null;
}


function Geo2Cartesian(lon, lat, height, sceneMode) {
    var ret = new THREE.Vector3(0, 0, 0);
    var x = 0;
    var y = 0;
    var z = 0;

    if (sceneMode == CMWORLD.SceneModeType.SCENE_P2D) {
        x = (lon + 180.0) * m_MeterPerSec;
        y = (lat + 90.0) * m_MeterPerSec;
        z = 0;
    }
    else if (sceneMode == CMWORLD.SceneModeType.SCENE_P3D) {
        x = (lon + 180.0) * m_MeterPerSec;
        y = (lat + 90.0) * m_MeterPerSec;
        z = height - EarthRadiusDynamic;
    }
	 else
	 {
		 ret = CMWORLD.CmMathEngine.Geo2Cartesian(lon, lat, height, sceneMode);
		 x = ret.x;
		 y = ret.y;
		 z = ret.z;
    }

    ret.x = x;
    ret.y = y;
    ret.z = z;

    return ret;
}



var firstLoad = true;
function initWorker(edata)
{
	if (firstLoad == true)
	{
		var cmworld3BaseRoot = edata.cmworld3BaseRoot;
		// 공통
		importScripts(cmworld3BaseRoot + 'cm_compile.js');
		importScripts(cmworld3BaseRoot + 'Worker/cm_commonfunc.js');
		importScripts(cmworld3BaseRoot + 'lib/three.min.js');

		if (CMWORLD.Compile.DistributionMode)
		{
			importScripts(cmworld3BaseRoot + 'cm3webgl-0.4.5.min.js');
		}
		else
		{
			importScripts(cmworld3BaseRoot + 'cm_enums.js');
			importScripts(cmworld3BaseRoot + 'cm_const.js');
			importScripts(cmworld3BaseRoot + 'IO/cm_binaryreader.js');
			importScripts(cmworld3BaseRoot + 'Utilities/cm_memmanager.js');
			importScripts(cmworld3BaseRoot + 'Math3D/cm_mathengine.js');
		}

		ResponseData = new QuadImageTileResponse();
		MemManager = new CMWORLD.MemManager();
		firstLoad = false;
	}
}



onmessage = function (event) {

    var edata = event.data;
    if (edata == "") {
        sendError();
        return;
	 }

	 initWorker(edata);

    imageDownOK = false;
    terrainDownOK = false;

    var sendMsg = true;

    try {
        if (edata.command == 'start') {
            //ResponseData = new QuadImageTileResponse();

           Level = edata.Level;
           Row = edata.Row;
           Col = edata.Col;

			  xhr = CMWORLD.FuncForWorker.createCORSRequest('GET', edata.dataUrl);

            if (!xhr) {
                //postMessage({ command: "error" });
            }

            xhr.send();


            VertexWidth = edata.vertexWidth;
            EarthRadiusDynamic = edata.EarthRadius;
            SceneMode = edata.SceneMode;

            if (edata.SceneMode == 0 || SceneMode == 2) {
                EarthRadiusDynamic = CMWORLD.cm_const.EarthRadius;
            }

            m_MeterPerSec = (2 * CMWORLD.CmMathEngine.PI * EarthRadiusDynamic) / 360.0;
            TileSize = edata.TileSize;
            GlobalScale = edata.GlobalScale;
            VerticalExaggeration = edata.VerticalExaggeration;

            //m_Head = new CMWORLD.DemHeader();

            West = -180 + Col * TileSize;
            East = -180 + (Col + 1) * TileSize;
            South = -90 + Row * TileSize;
            North = -90 + (Row + 1) * TileSize;


            m_Center = new THREE.Vector3();
            m_Center.x = (West + East) * 0.5;
            m_Center.y = (North + South) * 0.5;
            m_Center.z = 0;

            Origin = Geo2Cartesian(West + TileSize * 0.5, South + TileSize * 0.5, EarthRadiusDynamic, SceneMode);

				if (xhr.readyState == CMWORLD.xHttp_readyState.finished && xhr.status == CMWORLD.HttpStatusCode.OK) {

                var downloadStream = xhr.response;
                var params = { dataState: true, datastream: downloadStream };
                if (downloadStream) {
                    postMessage(params, [params.datastream]);
                    sendMsg = false;
                }
            }
            else {

                console.warn('cm_modelworker download failed. ' + edata.dataUrl );
                //sendError();
                //postMessage({ command: "error" });
            }
        }
        else if (edata.command == 'getdata') {
            if (ResponseData.NWdata == null) {
                //sendError();
                //postMessage({ command: "error" });
            }
            else {

                var params = { command: "data", data: ResponseData };
                postMessage(params, [params.data]);
                sendMsg = false;
            }
        }
    }
    catch (err) {
        console.log(err.message);
        sendError();
        sendMsg = false;
    }
    finally {
        if (sendMsg === true)
            sendError();
    }
}



function sendFloat32Function() {

    postMessage(
       {
           dataState: true,
       });
}


function sendError() {
    console.warn("ModelWorker: SEND ERROR");

    postMessage(
          {
              dataState: false,
          });
}