var CMWORLD;
(function (CMWORLD) {
    var ctx = self;
    var firstLoad = true;
    var _3dsLoader = null;
    var _xdoReader = null;
    ctx.onmessage = function (event) {
        var edata = event.data;
        if (edata == "") {
            console.warn("3dsworker: edata == null ");
            notifyFinish(-1);
            return;
        }
        initWorker(edata);
        try {
            switch (edata.command) {
                case CMWORLD.WorkerCommand.loadModel:
                    if (loadModels(edata)) {
                    }
                    break;
            }
        }
        catch (err) {
            if (typeof err === 'object') {
                if (err.message) {
                    console.log('\nMessage: ' + err.message);
                }
                if (err.stack) {
                    console.log('\nStacktrace:');
                    console.log('====================');
                    console.log(err.stack);
                }
            }
            else {
                console.log('dumpError :: argument is not an object');
            }
        }
        finally {
            notifyFinish(-1);
        }
    };
    function notifyError(flag) {
        console.info("3DS ERROR : SEND ERROR " + flag);
        var msg = CMWORLD.FuncForWorker.genWorkerMsgObject();
        msg.success = false;
        ctx.postMessage(msg);
    }
    function notifyFinish(taskIndex) {
        var msg = CMWORLD.FuncForWorker.genWorkerMsgObject();
        msg.command = CMWORLD.WorkerCommand.finish;
        ctx.postMessage(msg);
    }
    function initWorker(edata) {
        if (firstLoad == true) {
            var baseRoot = edata.cmworld3BaseRoot;
            importScripts(baseRoot + 'cm_compile.js');
            importScripts(baseRoot + 'Worker/cm_commonfunc.js');
            importScripts(baseRoot + 'lib/three.min.js');
            importScripts(baseRoot + 'lib/msgpack.min.js');
            if (CMWORLD.Compile.DistributionMode) {
                importScripts(baseRoot + 'cm3webgl-0.4.5.min.js');
            }
            else {
                importScripts(baseRoot + 'cm_enums.js');
                importScripts(baseRoot + 'cm_const.js');
                importScripts(baseRoot + 'IO/cm_binaryreader.js');
                importScripts(baseRoot + 'Loader/cm_3dsloader.js');
                importScripts(baseRoot + 'Loader/cm_xdoloader.js');
                importScripts(baseRoot + 'Utilities/cm_util.js');
            }
            firstLoad = false;
        }
    }
    function loadModels(edata) {
        var msgpackBuffer = msgpack.decode(new Uint8Array(edata.msgpackBuffer));
        edata.buffers = msgpackBuffer.buffers;
        edata.fileNames = msgpackBuffer.fileNames;
        edata.fileFormats = msgpackBuffer.fileFormats;
        edata.dataAltitudes = msgpackBuffer.dataAltitudes;
        edata.urls = msgpackBuffer.urls;
        edata.version = msgpackBuffer.version;
        edata.earthRadius = msgpackBuffer.earthRadius;
        edata.xorig = msgpackBuffer.xorig;
        edata.yorig = msgpackBuffer.yorig;
        edata.zorig = msgpackBuffer.zorig;
        if (CMWORLD.Util.isDefined(edata.xorig) ||
            CMWORLD.Util.isDefined(edata.xorig) ||
            CMWORLD.Util.isDefined(edata.xorig)) {
            edata.moveMent = { x: -edata.xorig, y: -edata.yorig, z: -edata.zorig };
        }
        else {
            edata.moveMent = null;
        }
        for (var i = 0; i < edata.requestCount; i++) {
            if (edata.fileFormats[i] == CMWORLD.FileFormat._3ds) {
                load3DSAndPost(edata.buffers[i], i, edata.moveMent);
            }
            else if (edata.fileFormats[i] == CMWORLD.FileFormat._xdo) {
                loadXDOAndPost(edata.buffers[i], i, edata);
            }
            else if (edata.fileFormats[i] == CMWORLD.FileFormat._spo) {
                loadSPOAndPost(edata.buffers[i], i, edata);
            }
        }
        return true;
    }
    function load3DSAndPost(modelBuffer, index, moveMent) {
        if (_3dsLoader == null) {
            _3dsLoader = new CMWORLD.Max3DSLoader();
        }
        if (modelBuffer) {
            var resultMeshList = _3dsLoader.parse3DS(modelBuffer);
            var resultData = CMWORLD.Max3DSLoader.packingToFloat32Data(resultMeshList, moveMent);
            resultData.success = true;
            resultData.argIndex = index;
            var transferableObjects = [];
            transferableObjects.push(resultData.groups.buffer, resultData.counts.buffer, resultData.vertices.buffer, resultData.indices.buffer, resultData.uv.buffer, resultData.normal.buffer, resultData.diffuseColors.buffer, resultData.bothSides.buffer, resultData.hasTextures.buffer);
            ctx.postMessage(resultData, transferableObjects);
        }
        return true;
    }
    function loadXDOAndPost(modelBuffer, index, inParam) {
        if (_xdoReader == null) {
            _xdoReader = new CMWORLD.XDOLoader();
        }
        if (modelBuffer) {
            _xdoReader.xorig = 0;
            _xdoReader.yorig = 0;
            _xdoReader.zorig = 0;
            if (inParam.xorig)
                _xdoReader.xorig = inParam.xorig;
            if (inParam.yorig)
                _xdoReader.yorig = inParam.yorig;
            if (inParam.zorig)
                _xdoReader.zorig = inParam.zorig;
            if (inParam.earthRadius)
                _xdoReader.EarthRadius = inParam.earthRadius;
            else
                _xdoReader.EarthRadius = 63781370;
            _xdoReader.dataAltitude = inParam.dataAltitude;
            _xdoReader.init();
            _xdoReader.argIndex = index;
            try {
                if (inParam.version == 3002) {
                    if (_xdoReader.parseXDO3002(modelBuffer) == true) {
                        _xdoReader.sendFloat32Function(this);
                    }
                }
                else if (inParam.version == 3001) {
                    _xdoReader.parseXDO3001(modelBuffer);
                    _xdoReader.sendFloat32Function(this);
                }
                else {
                    notifyError("3");
                }
            }
            catch (ex) {
                console.error(ex.message);
            }
        }
        return true;
    }
    function loadSPOAndPost(modelBuffer, index, moveMent) {
        if (modelBuffer) {
            var spoData = CMWORLD.SPOLoader.parseBinary(modelBuffer);
            var packedBuffer = CMWORLD.SPOLoader.packToBuffer(spoData);
            var msg = {
                state: CMWORLD.WorkerCommand.response,
                success: true,
                argIndex: index,
                packedBuffer: packedBuffer
            };
            ctx.postMessage(msg, [msg.packedBuffer]);
        }
        return true;
    }
})(CMWORLD || (CMWORLD = {}));
