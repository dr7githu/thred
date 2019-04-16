var firstLoad = true;
var m_doing = false;
var m_imageDownOK = false;

onmessage = function (event) {

    var edata = event.data;
    if (edata == "") {
        sendError();
        return;
    }

    if (firstLoad == true) {

        var cmworld3BaseRoot = edata.cmworld3BaseRoot;

		  importScripts(cmworld3BaseRoot + 'cm_compile.js');
        importScripts(cmworld3BaseRoot + 'Worker/cm_commonfunc.js');
        importScripts(cmworld3BaseRoot + 'lib/three.min.js');

        if (CMWORLD.Compile.DistributionMode) {
            importScripts(cmworld3BaseRoot + 'cm3webgl-0.4.5.min.js');
        }
        else {
            importScripts(cmworld3BaseRoot + 'cm_enums.js');
        }


        firstLoad = false;
    }

    if (m_doing)
        return;

    m_doing = true;

    var sendMsg = true;

    try {
        if (edata.command == 'start') {

            m_imageDownOK = false;
            //ResponseData = new QuadImageTileResponse();

				xhr = CMWORLD.FuncForWorker.createCORSRequest('GET', edata.dataUrl);

            if (!xhr) {
                //postMessage({ command: "error" });
            }

            xhr.send();


				if (xhr.readyState == CMWORLD.xHttp_readyState.finished && xhr.status == CMWORLD.HttpStatusCode.OK) {

                var downloadStream = xhr.response;
                if (downloadStream) {

                    var params = {dataState: true, datastream: downloadStream };
                    postMessage(params, [params.datastream]);
                    sendMsg = false;
                }
            }
            else {

                console.warn('cm_modelworker download failed. ' + edata.dataUrl);
                //sendError();
                //postMessage({ command: "error" });
            }
        }
    }
    catch (err) {
        console.error(err.message);
        sendError();
        sendMsg = false;
    }
    finally {
        if (sendMsg === true)
            sendError();

        m_doing = false;
    }
}



function sendFloat32Function() {

    postMessage(
       {
           dataState: true,
       });
}


function sendError() {
    console.warn("texturedownloadworker: SEND ERROR");

    postMessage(
          {
              dataState: false,
          });
}