var bConfig = false;

onmessage = function(event) {

	var inParam = event.data;
	if (!bConfig)
	{
		initWorker(inParam.cmworld3BaseRoot);
	}

	if (inParam.state == CMWORLD.VectorCube3D.ID_MakeCubeDataProcess) 
	{
		try
		{
			var result = makeCubeDataProcess(inParam);
			// 결과에 상태값을 넣어서 보내주자.
			result.state = CMWORLD.VectorCube3D.ID_MakeCubeDataProcess;
			postMessage(result, [result.msgpackBuffer]);

			// 더이상 할것 없다.
			return;
		}
		catch (e)
		{
		}

		// 어떠한 경우든 최종적으로 worker가 할일이 끝났음을 알려야 한다.
		postMessage({ state: CMWORLD.VectorCube3D.ID_Finish });
	}
	 else
	 {
		 if (inParam.state == 'VectorCube3D_makeData')
		 {
		 }
		 else
		 {
			 var readResult = CMWORLD.CubeGroup.readData(inParam.arrBufData);
			 // WorkerTestSleep(3000);

			 postMessage({

				 state: 'dataSetComplete',
				 isWorking: true,
				 cubeSize: readResult.cubeSize,
				 cubeBlockDepth: readResult.cubeBlockHeight,
				 cubeValueBuffer: readResult.cubeValueBuffer,
				 cubeValueOutsideBuffers: readResult.cubeValueOutsideBuffers,
				 level: inParam.Level,
				 row: inParam.Row,
				 col: inParam.Col
			 });

			 postMessage({

				 state: 'finish',
				 isWorking: false,
				 level: inParam.Level,
				 row: inParam.Row,
				 col: inParam.Col
			 });
		 }
	 }
}


// 최초로 워크를 기동했을때 초기화 할내용들
function initWorker(baseRoot )
{
	importScripts(baseRoot + 'cm_compile.js');
	importScripts(baseRoot + 'lib/three.min.js');
	importScripts(baseRoot + 'lib/msgpack.min.js');

	if (CMWORLD.Compile.DistributionMode)
	{
		importScripts(baseRoot + 'cm3webgl-0.4.5.min.js');

	} else
	{
		importScripts(baseRoot + 'cm_enums.js');
		importScripts(baseRoot + 'cm_const.js');
		importScripts(baseRoot + 'IO/cm_binaryreader.js');
		importScripts(baseRoot + 'Math3D/cm_mathengine.js');
		importScripts(baseRoot + 'Map/Cube/cm_cubegroup.js');
		importScripts(baseRoot + 'Map/Cube3d/c3_Cube3D.js');
		importScripts(baseRoot + 'Map/Cube3d/c3_VectorCube3D.js');
	}
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


function makeCubeDataProcess(parameter)
{
	if (parameter == null || parameter == undefined)
		return null;

	var result = CMWORLD.VectorCube3D.makeCubeDataProcess(parameter);
	return result;
}
