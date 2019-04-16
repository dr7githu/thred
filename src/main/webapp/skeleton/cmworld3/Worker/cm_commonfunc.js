var CMWORLD;
(function (CMWORLD) {
    var FuncForWorker = (function () {
        function FuncForWorker() {
        }
        FuncForWorker.createCORSRequest = function (method, url, async) {
            if (async === void 0) { async = false; }
            var xhr = new XMLHttpRequest();
            if ("withCredentials" in xhr) {
                xhr.open(method, url, async);
            }
            else if (typeof XDomainRequest != "undefined") {
                xhr = new XDomainRequest();
                xhr.open(method, url, async);
            }
            else {
                xhr = null;
            }
            xhr.responseType = 'arraybuffer';
            return xhr;
        };
        FuncForWorker.genWorkerMsgObject = function () {
            var obj;
            obj = { command: CMWORLD.WorkerCommand.response };
            return obj;
        };
        return FuncForWorker;
    }());
    CMWORLD.FuncForWorker = FuncForWorker;
})(CMWORLD || (CMWORLD = {}));
