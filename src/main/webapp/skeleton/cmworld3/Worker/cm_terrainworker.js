var CMWORLD;
(function (CMWORLD) {
    var ctx = self;
    var flipY = false;
    var m_responseData;
    var imageDownOK = false;
    var terrainDownOK = false;
    var demFile = null;
    ctx.onmessage = function (event) {
        var taskIndex = -1;
        var edata = event.data;
        if (edata == "" || edata == undefined) {
            sendError(taskIndex);
            notifyFinish(taskIndex, edata);
            return;
        }
        initWorker(edata);
        imageDownOK = false;
        terrainDownOK = false;
        var sendMsg = true;
        try {
            taskIndex = edata.taskIndex;
            if (edata.command == CMWORLD.WorkerCommand.loadTerrain) {
                var fileArrayBuffer = null;
                if (edata.terrainFileBuffer) {
                    fileArrayBuffer = edata.terrainFileBuffer;
                }
                else {
                    var xhr = CMWORLD.FuncForWorker.createCORSRequest('GET', edata.terrainUrl);
                    if (!xhr) {
                    }
                    xhr.send();
                    fileArrayBuffer = xhr.response;
                }
                if (fileArrayBuffer) {
                    Level = edata.Level;
                    Row = edata.Row;
                    Col = edata.Col;
                    VertexWidth = edata.vertexWidth;
                    checkDataBuffer(VertexWidth);
                    flipY = edata.flipY;
                    EarthRadiusDynamic = edata.EarthRadius;
                    SceneMode = edata.SceneMode;
                    if (edata.SceneMode == 0 || SceneMode == 2) {
                        EarthRadiusDynamic = CMWORLD.cm_const.EarthRadius;
                    }
                    m_MeterPerSec = (2 * CMWORLD.CmMathEngine.PI * EarthRadiusDynamic) / 360.0;
                    TileSize = edata.TileSize;
                    GlobalScale = edata.GlobalScale;
                    VerticalExaggeration = edata.VerticalExaggeration;
                    West = -180 + Col * TileSize;
                    East = -180 + (Col + 1) * TileSize;
                    South = -90 + Row * TileSize;
                    North = -90 + (Row + 1) * TileSize;
                    if (isNotTin == false) {
                    }
                    else {
                        m_Center = new THREE.Vector3();
                        m_Center.x = (West + East) * 0.5;
                        m_Center.y = (North + South) * 0.5;
                        m_Center.z = 0;
                        _origin = Geo2Cartesian(West + TileSize * 0.5, South + TileSize * 0.5, EarthRadiusDynamic, SceneMode);
                        {
                            if (false) {
                            }
                            else {
                                if (fileArrayBuffer) {
                                    var isNotTin = loadElevationData(fileArrayBuffer);
                                    if (isNotTin == false) {
                                    }
                                    else {
                                        CreateElevatedMesh(SceneMode);
                                        sendFloat32Function(taskIndex, edata);
                                        sendMsg = false;
                                    }
                                }
                            }
                        }
                    }
                }
                else {
                    ctx.postMessage({ command: "error", success: false, dataState: false, status: CMWORLD.HttpStatusCode.NOT_FOUND });
                    sendMsg = false;
                }
            }
            else if (edata.command == 'getdata') {
                if (m_responseData.NWdata == null) {
                }
                else {
                    ctx.postMessage({ command: "data", data: m_responseData, taskIndex: taskIndex });
                    sendMsg = false;
                }
            }
        }
        catch (err) {
            console.log(err.message);
            sendError(taskIndex);
            sendMsg = false;
        }
        finally {
            if (sendMsg === true)
                sendError(taskIndex);
            notifyFinish(taskIndex, edata);
        }
    };
    var cm_tiledata = (function () {
        function cm_tiledata() {
            this.vertices = [];
            this.verticeslength = 0;
            this.triangles = [];
            this.triangleslength = 0;
            this.uv = [];
            this.uvlength = 0;
            this.edgeFaceStartIndex = 0;
        }
        return cm_tiledata;
    }());
    var QuadImageTileResponse = (function () {
        function QuadImageTileResponse() {
            this.NWdata = null;
            this.NEdata = null;
            this.SWdata = null;
            this.SEdata = null;
        }
        return QuadImageTileResponse;
    }());
    var m_MeterPerSec = 0;
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
        else {
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
    var Level = -1;
    var Row = -1;
    var Col = -1;
    var North;
    var South;
    var East;
    var West;
    var m_Center;
    var _origin;
    var VertexWidth = 64;
    var SamplePerTile = 64;
    var HalfSamplerCount = SamplePerTile / 2;
    var EarthRadiusDynamic = 0;
    var TileSize;
    var reponseData = null;
    var GlobalScale;
    var VerticalExaggeration;
    var SceneMode;
    var _memManager = null;
    var _elevationDataBuffer = [];
    function loadElevationData(fileArrayBuffer) {
        if (_elevationDataBuffer == null)
            return;
        if (fileArrayBuffer.byteLength < 1) {
            demFile.isTin = false;
        }
        else {
            demFile.isTin = false;
            demFile.initHeightBuffer(0);
            if (demFile.readDemFile(fileArrayBuffer) == false) {
                return false;
            }
            var heights = demFile.heightbuffer;
            var bufferW = demFile.header.col;
            var bufferH = demFile.header.row;
            if (demFile.isTin) {
                return false;
            }
            if (bufferW == VertexWidth + 1) {
                for (var y = 0; y < bufferH; y++) {
                    for (var x = 0; x < bufferW; x++) {
                        _elevationDataBuffer[y][x] = heights[y][x] * GlobalScale * VerticalExaggeration;
                    }
                }
            }
            else {
                var latrange = Math.abs(North - South);
                var lonrange = Math.abs(East - West);
                var scaleFactor = 1.0 / VertexWidth;
                for (var y = 0; y < VertexWidth + 1; y++) {
                    var curLat = North - scaleFactor * latrange * y;
                    for (var x = 0; x < VertexWidth + 1; x++) {
                        var curLon = West + scaleFactor * lonrange * x;
                        _elevationDataBuffer[y][x] = GetElevationAt(curLat, curLon, heights, bufferW);
                    }
                }
            }
        }
        return true;
    }
    function GetElevationAt(latitude, longitude, heights, DataBufferWidth) {
        if (_elevationDataBuffer.length == 0) {
            return 0;
        }
        var deltaLat = North - latitude;
        var deltaLon = longitude - West;
        var TileSizeDegrees = TileSize;
        var df2 = (DataBufferWidth - 1.0) / TileSizeDegrees;
        var lat_pixel = (deltaLat * df2);
        var lon_pixel = (deltaLon * df2);
        var min_y = Math.floor(lat_pixel);
        var max_y = Math.ceil(lat_pixel);
        var min_x = Math.floor(lon_pixel);
        var max_x = Math.ceil(lon_pixel);
        if (min_y >= DataBufferWidth)
            min_y = DataBufferWidth - 1;
        if (max_y >= DataBufferWidth)
            max_y = DataBufferWidth - 1;
        if (min_x >= DataBufferWidth)
            min_x = DataBufferWidth - 1;
        if (max_x >= DataBufferWidth)
            max_x = DataBufferWidth - 1;
        if (min_y < 0)
            min_y = 0;
        if (max_y < 0)
            max_y = 0;
        if (min_x < 0)
            min_x = 0;
        if (max_x < 0)
            max_x = 0;
        var delta = (lat_pixel - min_y);
        {
            if (latitude == North) {
                min_y = max_y = 0;
            }
            else if (latitude == South) {
                min_y = max_y = DataBufferWidth - 1;
            }
            if (longitude == East) {
                min_x = max_x = DataBufferWidth - 1;
            }
            else if (longitude == West) {
                min_x = max_x = 0;
            }
        }
        var westElevation = heights[min_y][min_x] * (1 - delta) + heights[max_y][min_x] * delta;
        var eastElevation = heights[min_y][max_x] * (1 - delta) + heights[max_y][max_x] * delta;
        delta = lon_pixel - min_x;
        var interpolatedElevation = 0;
        interpolatedElevation = westElevation * (1 - delta) + eastElevation * delta;
        return interpolatedElevation * GlobalScale * VerticalExaggeration;
    }
    function CreateElevatedMesh(sceneMode) {
        var totalVertexCount = (HalfSamplerCount + 1) * (HalfSamplerCount + 1);
        CalculateSubElevatedVertex(CMWORLD.TilePositionType.NW, totalVertexCount, sceneMode);
        CalculateSubElevatedVertex(CMWORLD.TilePositionType.NE, totalVertexCount, sceneMode);
        CalculateSubElevatedVertex(CMWORLD.TilePositionType.SW, totalVertexCount, sceneMode);
        CalculateSubElevatedVertex(CMWORLD.TilePositionType.SE, totalVertexCount, sceneMode);
    }
    function calculate_normals(corner, vert, tri, edgeFaceStartIndex) {
        var VA, VB, VC;
        var cb = new THREE.Vector3(), ab = new THREE.Vector3();
        var v, vl, f, fl, face;
        var tileData = GetTiledataInResponseData(corner);
        var normalTempBuffer = _memManager.GetVector3Array(tileData.verticeslength);
        var usedtrianglecount = edgeFaceStartIndex;
        for (f = 0; f < usedtrianglecount; f++) {
            face = tri[f];
            VA = vert[face.a];
            VB = vert[face.b];
            VC = vert[face.c];
            cb.subVectors(VC, VB);
            ab.subVectors(VA, VB);
            cb.cross(ab);
            normalTempBuffer[face.a].add(cb);
            normalTempBuffer[face.b].add(cb);
            normalTempBuffer[face.c].add(cb);
        }
        for (v = 0; v < tileData.verticeslength; v++) {
            normalTempBuffer[v].normalize();
        }
        for (f = 0; f < usedtrianglecount; f++) {
            face = tri[f];
            face.vertexNormals[0] = normalTempBuffer[face.a].clone();
            face.vertexNormals[1] = normalTempBuffer[face.b].clone();
            face.vertexNormals[2] = normalTempBuffer[face.c].clone();
        }
        for (f = edgeFaceStartIndex; f < tri.length; f++) {
            face = tri[f];
            face.vertexNormals[0] = normalTempBuffer[face.a].clone();
            face.vertexNormals[1] = normalTempBuffer[face.a].clone();
            face.vertexNormals[2] = normalTempBuffer[face.a].clone();
        }
        _memManager.RemoveVector3Array(normalTempBuffer);
    }
    function GetTiledataInResponseData(corner) {
        switch (corner) {
            case CMWORLD.TilePositionType.NW:
                return m_responseData.NWdata;
            case CMWORLD.TilePositionType.NE:
                return m_responseData.NEdata;
            case CMWORLD.TilePositionType.SW:
                return m_responseData.SWdata;
            case CMWORLD.TilePositionType.SE:
                return m_responseData.SEdata;
        }
        return null;
    }
    function GetVerticeInResponseData(corner) {
        var data = GetTiledataInResponseData(corner);
        if (data)
            return data.vertices;
        return null;
    }
    function SetVerticeInResponseData(corner, vertices) {
        var data = GetTiledataInResponseData(corner);
        if (data)
            data.vertices = vertices;
    }
    function GetUVInResponseData(corner) {
        var data = GetTiledataInResponseData(corner);
        if (data)
            return data.uv;
        return null;
    }
    function SetUVInResponseData(corner, UV) {
        var data = GetTiledataInResponseData(corner);
        if (data)
            data.uv = UV;
    }
    function GetTrianglesInResponseData(corner) {
        var data = GetTiledataInResponseData(corner);
        if (data)
            return data.triangles;
        return null;
    }
    function SetTrianglesInResponseData(corner, triangles) {
        var data = GetTiledataInResponseData(corner);
        if (data)
            data.triangles = triangles;
    }
    function CalculateSubElevatedVertex(corner, VertexCount, sceneMode) {
        var tileData = GetTiledataInResponseData(corner);
        var vertices = GetVerticeInResponseData(corner);
        var uvs = GetUVInResponseData(corner);
        var faces = GetTrianglesInResponseData(corner);
        var LatitudeSpan = Math.abs(North - South);
        var StartX = West;
        var StartY = South;
        var terrainLongitudeIndex = 0;
        var terrainLatitudeIndex = 0;
        var LatitudeSpanHalf = LatitudeSpan * 0.5;
        var u = 0;
        var v = 0;
        var uvf = 1.0 / SamplePerTile;
        var lineCellCount = HalfSamplerCount;
        switch (corner) {
            case CMWORLD.TilePositionType.SW:
                {
                    u = 0;
                    v = 0;
                }
                break;
            case CMWORLD.TilePositionType.SE:
                {
                    u = 0.5;
                    v = 0;
                    StartX = m_Center.x;
                    terrainLongitudeIndex = lineCellCount;
                }
                break;
            case CMWORLD.TilePositionType.NW:
                {
                    u = 0;
                    v = 0.5;
                    StartY = m_Center.y;
                    terrainLatitudeIndex = lineCellCount;
                }
                break;
            case CMWORLD.TilePositionType.NE:
                {
                    u = 0.5;
                    v = 0.5;
                    StartX = m_Center.x;
                    StartY = m_Center.y;
                    terrainLongitudeIndex = lineCellCount;
                    terrainLatitudeIndex = lineCellCount;
                }
                break;
        }
        var height;
        var latitudeIndex = 0;
        var baseHeight = 0.0;
        var stepBuffer = _memManager.GetBaseObjectArray(lineCellCount + 1);
        for (var i = 0; i < (lineCellCount + 1); i++) {
            if (i == 0) {
                stepBuffer[i] = 0;
            }
            else {
                stepBuffer[i] = LatitudeSpanHalf * (i / lineCellCount);
            }
        }
        var halfCount = Math.floor(SamplePerTile * 0.5) + 1;
        var preu = u;
        var coord;
        var vLen = (lineCellCount + 1) * (lineCellCount + 1);
        var extraLen = 150 * 8;
        if (vertices.length < vLen + extraLen) {
            vertices = new Array();
            for (var i = 0; i < vLen + extraLen; i++) {
                vertices.push(new THREE.Vector3());
            }
            SetVerticeInResponseData(corner, vertices);
        }
        if (uvs.length < vLen + extraLen) {
            uvs = new Array();
            for (var i = 0; i < vLen + extraLen; i++) {
                uvs.push(new THREE.Vector2());
            }
            SetUVInResponseData(corner, uvs);
        }
        var vIndex = 0;
        var tIndex = 0;
        var fIndex = 0;
        for (var latitudeIndex = 0; latitudeIndex < lineCellCount + 1; latitudeIndex++) {
            for (var longitudeIndex = 0; longitudeIndex < lineCellCount + 1; longitudeIndex++) {
                height = _elevationDataBuffer[SamplePerTile - (terrainLatitudeIndex + latitudeIndex)][terrainLongitudeIndex + longitudeIndex];
                if (isNaN(height)) {
                    height = 0.0;
                }
                else {
                    height = (baseHeight + height);
                }
                coord = Geo2Cartesian(StartX + (stepBuffer[longitudeIndex]), StartY + (stepBuffer[latitudeIndex]), height + EarthRadiusDynamic, SceneMode);
                coord.sub(_origin);
                vertices[vIndex++] = coord;
                uvs[tIndex].x = u;
                uvs[tIndex++].y = v;
                u += uvf;
                if (latitudeIndex < lineCellCount && longitudeIndex < lineCellCount) {
                    var longitude_base = latitudeIndex * halfCount + longitudeIndex;
                    var longitude_bottom = (latitudeIndex + 1) * halfCount + longitudeIndex;
                    faces[fIndex++] = new THREE.Face3(longitude_base, longitude_base + 1, longitude_bottom);
                    faces[fIndex++] = new THREE.Face3(longitude_base + 1, longitude_bottom + 1, longitude_bottom);
                }
            }
            v += uvf;
            u = preu;
        }
        var edgevertex_startindex = vIndex;
        var edgeFaceStartIndex = fIndex;
        var makeEdge = true;
        if (makeEdge) {
            var meterOfDegree = 114640;
            var demoneStep = (stepBuffer[1] - stepBuffer[0]) * meterOfDegree;
            var edge_vertices_index = new Array(4);
            edge_vertices_index[0] = new Array();
            edge_vertices_index[1] = new Array();
            edge_vertices_index[2] = new Array();
            edge_vertices_index[3] = new Array();
            {
                var linevertexcount = lineCellCount + 1;
                var gap = lineCellCount * linevertexcount;
                var vIndex2 = 0;
                for (var longitudeIndex = 0; longitudeIndex < linevertexcount; longitudeIndex++) {
                    edge_vertices_index[1].push(gap + vIndex2);
                    edge_vertices_index[3].push(lineCellCount - vIndex2);
                    ++vIndex2;
                }
                for (var latitudeIndex = 0; latitudeIndex < linevertexcount; latitudeIndex++) {
                    var ii = latitudeIndex * linevertexcount;
                    edge_vertices_index[0].push(ii);
                    edge_vertices_index[2].push((linevertexcount - latitudeIndex) * linevertexcount - 1);
                }
            }
            var downMulti = 1.0;
            var edgevertex_index = edgevertex_startindex;
            for (var kk = 0; kk < 4; kk++) {
                var dirUp = new THREE.Vector3(0, 0, 1);
                var downdistance = demoneStep * downMulti;
                var vert2 = edge_vertices_index[kk];
                for (var i = 0; i < vert2.length; i++) {
                    var down;
                    var dir;
                    if (sceneMode == CMWORLD.SceneModeType.SCENE_P3D) {
                        down = vertices[vert2[i]].clone();
                        dir = dirUp.clone();
                        dir.multiplyScalar(downdistance);
                        down.sub(dir);
                    }
                    else {
                        down = vertices[vert2[i]].clone().add(_origin);
                        dir = down.clone().normalize();
                        dir.multiplyScalar(downdistance);
                        down.sub(dir);
                        down.sub(_origin);
                    }
                    uvs[tIndex].x = uvs[vert2[i]].x;
                    uvs[tIndex++].y = uvs[vert2[i]].y;
                    vertices[vIndex++] = down;
                }
            }
            {
                for (var kk = 0; kk < 4; kk++) {
                    var vert2 = edge_vertices_index[kk];
                    for (var i = 0; i < vert2.length - 1; i++) {
                        faces[fIndex++] = new THREE.Face3(vert2[i + 1], edgevertex_index + 1, edgevertex_index);
                        faces[fIndex++] = new THREE.Face3(vert2[i + 1], edgevertex_index, vert2[i]);
                        ++edgevertex_index;
                    }
                    ++edgevertex_index;
                }
            }
        }
        tileData.verticeslength = vIndex;
        tileData.triangleslength = fIndex;
        tileData.uvlength = tIndex;
        calculate_normals(corner, vertices, faces, edgeFaceStartIndex);
        tileData.edgeFaceStartIndex = edgeFaceStartIndex;
        _memManager.RemoveBaseObjectArray(stepBuffer);
    }
    function convertFloat32Array(demValueArray, width) {
        var length = width * width;
        var packedData = new Float32Array(length);
        var packedIndex = 0;
        for (var y = 0; y < width; y++) {
            for (var x = 0; x < width; x++) {
                packedData[packedIndex++] = demValueArray[y][x];
            }
        }
        return packedData;
    }
    function getVert(corner) {
        var tileData = GetTiledataInResponseData(corner);
        var length = tileData.verticeslength * 3;
        var packedData = new Float32Array(length);
        var packedIndex = 0;
        var i;
        var vertices = GetVerticeInResponseData(corner);
        for (i = 0; i < tileData.verticeslength; i++) {
            packedData[packedIndex++] = vertices[i].x;
            packedData[packedIndex++] = vertices[i].y;
            packedData[packedIndex++] = vertices[i].z;
        }
        return packedData;
    }
    function getNormal(corner) {
        var tileData = GetTiledataInResponseData(corner);
        var length = tileData.verticeslength * 3;
        var packedData = new Float32Array(length);
        var packedIndex = 0;
        var i;
        var triangles = GetTrianglesInResponseData(corner);
        for (i = 0; i < tileData.triangleslength; i++) {
            packedData[triangles[i].a * 3 + 0] = triangles[i].vertexNormals[0].x;
            packedData[triangles[i].a * 3 + 1] = triangles[i].vertexNormals[0].y;
            packedData[triangles[i].a * 3 + 2] = triangles[i].vertexNormals[0].z;
            packedData[triangles[i].b * 3 + 0] = triangles[i].vertexNormals[1].x;
            packedData[triangles[i].b * 3 + 1] = triangles[i].vertexNormals[1].y;
            packedData[triangles[i].b * 3 + 2] = triangles[i].vertexNormals[1].z;
            packedData[triangles[i].c * 3 + 0] = triangles[i].vertexNormals[2].x;
            packedData[triangles[i].c * 3 + 1] = triangles[i].vertexNormals[2].y;
            packedData[triangles[i].c * 3 + 2] = triangles[i].vertexNormals[2].z;
        }
        return packedData;
    }
    function getUV(corner) {
        var tileData = GetTiledataInResponseData(corner);
        var length = tileData.uvlength * 2;
        var packedData = new Float32Array(length);
        var packedIndex = 0;
        var i;
        var uv = GetUVInResponseData(corner);
        if (flipY) {
            for (i = 0; i < tileData.uvlength; i++) {
                packedData[packedIndex++] = uv[i].x;
                packedData[packedIndex++] = 1.0 - uv[i].y;
            }
        }
        else {
            for (i = 0; i < tileData.uvlength; i++) {
                packedData[packedIndex++] = uv[i].x;
                packedData[packedIndex++] = uv[i].y;
            }
        }
        return packedData;
    }
    function getIndex(corner) {
        var tileData = GetTiledataInResponseData(corner);
        var length = tileData.triangleslength * 3;
        var packedData = new Uint16Array(length);
        var packedIndex = 0;
        var i;
        var tri = GetTrianglesInResponseData(corner);
        for (i = 0; i < tri.length; i++) {
            packedData[packedIndex++] = tri[i].a;
            packedData[packedIndex++] = tri[i].b;
            packedData[packedIndex++] = tri[i].c;
        }
        return packedData;
    }
    function sendFloat32Function(taskIndex, edata) {
        var tileData_NW = GetTiledataInResponseData(CMWORLD.TilePositionType.NW);
        var tileData_NE = GetTiledataInResponseData(CMWORLD.TilePositionType.NE);
        var tileData_SW = GetTiledataInResponseData(CMWORLD.TilePositionType.SW);
        var tileData_SE = GetTiledataInResponseData(CMWORLD.TilePositionType.SE);
        var NWVert = getVert(CMWORLD.TilePositionType.NW);
        var NEVert = getVert(CMWORLD.TilePositionType.NE);
        var SWVert = getVert(CMWORLD.TilePositionType.SW);
        var SEVert = getVert(CMWORLD.TilePositionType.SE);
        var NWNorm = getNormal(CMWORLD.TilePositionType.NW);
        var NENorm = getNormal(CMWORLD.TilePositionType.NE);
        var SWNorm = getNormal(CMWORLD.TilePositionType.SW);
        var SENorm = getNormal(CMWORLD.TilePositionType.SE);
        var NWUVs = getUV(CMWORLD.TilePositionType.NW);
        var NEUVs = getUV(CMWORLD.TilePositionType.NE);
        var SWUVs = getUV(CMWORLD.TilePositionType.SW);
        var SEUVs = getUV(CMWORLD.TilePositionType.SE);
        var NWTri = getIndex(CMWORLD.TilePositionType.NW);
        var NETri = getIndex(CMWORLD.TilePositionType.NE);
        var SWTri = getIndex(CMWORLD.TilePositionType.SW);
        var SETri = getIndex(CMWORLD.TilePositionType.SE);
        var params = {
            success: true,
            dataState: true,
            origin: _origin,
            NWVerticesLength: NWVert.length,
            NWVertices: NWVert,
            NEVerticesLength: NEVert.length,
            NEVertices: NEVert,
            SWVerticesLength: SWVert.length,
            SWVertices: SWVert,
            SEVerticesLength: SEVert.length,
            SEVertices: SEVert,
            NWNormalLength: NWNorm.length,
            NWNormal: NWNorm,
            NENormalLength: NENorm.length,
            NENormal: NENorm,
            SWNormalLength: SWNorm.length,
            SWNormal: SWNorm,
            SENormalLength: SENorm.length,
            SENormal: SENorm,
            NWUVLength: NWUVs.length,
            NWUV: NWUVs,
            NEUVLength: NEUVs.length,
            NEUV: NEUVs,
            SWUVLength: SWUVs.length,
            SWUV: SWUVs,
            SEUVLength: SEUVs.length,
            SEUV: SEUVs,
            NWIndexLength: NWTri.length,
            NWIndex: NWTri,
            NWEdgeFaceStartIndex: tileData_NW.edgeFaceStartIndex,
            NEIndexLength: NETri.length,
            NEIndex: NETri,
            NEEdgeFaceStartIndex: tileData_NE.edgeFaceStartIndex,
            SWIndexLength: SWTri.length,
            SWIndex: SWTri,
            SWEdgeFaceStartIndex: tileData_SW.edgeFaceStartIndex,
            SEIndexLength: SETri.length,
            SEIndex: SETri,
            SEEdgeFaceStartIndex: tileData_SE.edgeFaceStartIndex,
            taskIndex: taskIndex,
            level: edata.Level,
            row: edata.Row,
            col: edata.Col,
            minHeight: demFile.header.min,
            maxHeight: demFile.header.max,
        };
        var transferableObjects = [];
        transferableObjects.push(params.NWVertices.buffer, params.NEVertices.buffer, params.SWVertices.buffer, params.SEVertices.buffer, params.NWNormal.buffer, params.NENormal.buffer, params.SWNormal.buffer, params.SENormal.buffer, params.NWUV.buffer, params.NEUV.buffer, params.SWUV.buffer, params.SEUV.buffer, params.NWIndex.buffer, params.NEIndex.buffer, params.SWIndex.buffer, params.SEIndex.buffer);
        ctx.postMessage(params, transferableObjects);
    }
    function sendError(taskIndex) {
        console.log("TERRAIN ERROR : SEND ERROR");
        ctx.postMessage({ command: "error", success: false, dataState: false, taskIndex: taskIndex });
    }
    function notifyFinish(taskIndex, edata) {
        var msg = CMWORLD.FuncForWorker.genWorkerMsgObject();
        msg.command = CMWORLD.WorkerCommand.finish;
        ctx.postMessage(msg);
    }
    function checkDataBuffer(bufferWidth) {
        if (_elevationDataBuffer.length < (bufferWidth + 1)) {
            _elevationDataBuffer = new Array(bufferWidth + 1);
            for (var y = 0; y < bufferWidth + 1; y++) {
                _elevationDataBuffer[y] = new Array(bufferWidth + 1);
                for (var x = 0; x < bufferWidth + 1; x++) {
                    _elevationDataBuffer[y][x] = 0;
                }
            }
        }
    }
    var firstLoad = true;
    function initWorker(edata) {
        if (firstLoad == true) {
            var cmworld3BaseRoot = edata.cmworld3BaseRoot;
            importScripts(cmworld3BaseRoot + 'cm_compile.js');
            importScripts(cmworld3BaseRoot + 'lib/three.min.js');
            importScripts(cmworld3BaseRoot + 'Worker/cm_commonfunc.js');
            if (CMWORLD.Compile.DistributionMode) {
                importScripts(cmworld3BaseRoot + 'cm3webgl-0.4.5.min.js');
            }
            else {
                importScripts(cmworld3BaseRoot + 'cm_enums.js');
                importScripts(cmworld3BaseRoot + 'cm_const.js');
                importScripts(cmworld3BaseRoot + 'IO/cm_binaryreader.js');
                importScripts(cmworld3BaseRoot + 'Utilities/cm_memmanager.js');
                importScripts(cmworld3BaseRoot + 'Map/cm_demfile.js');
                importScripts(cmworld3BaseRoot + 'Math3D/cm_mathengine.js');
            }
            m_MeterPerSec = (2 * CMWORLD.CmMathEngine.PI * CMWORLD.cm_const.EarthRadius) / 360.0;
            EarthRadiusDynamic = CMWORLD.cm_const.EarthRadius;
            demFile = new CMWORLD.DemFile();
            demFile.prepareHeightBuffer(130);
            m_responseData = new QuadImageTileResponse();
            _memManager = new CMWORLD.MemManager();
            m_responseData.NWdata = new cm_tiledata();
            m_responseData.NEdata = new cm_tiledata();
            m_responseData.SWdata = new cm_tiledata();
            m_responseData.SEdata = new cm_tiledata();
            firstLoad = false;
        }
    }
})(CMWORLD || (CMWORLD = {}));
