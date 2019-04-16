var CMWORLD;
(function (CMWORLD) {
    var Compile = (function () {
        function Compile() {
        }
        Compile.getSiteRootUrl = function () {
            var url = location.href;
            var index = url.lastIndexOf("/");
            var rootfolder = url.slice(0, index);
            return rootfolder;
        };
        Compile.loadJsCssfile = function (filename, filetype, callback) {
            var scriptEl = null;
            if (filetype == "js") {
                scriptEl = document.createElement('script');
                scriptEl.type = 'text/javascript';
                scriptEl.onload = function () {
                    if (callback) {
                        callback();
                    }
                };
                scriptEl.src = filename;
            }
            else if (filetype == "css") {
                scriptEl = document.createElement("link");
                scriptEl.setAttribute("rel", "stylesheet");
                scriptEl.setAttribute("type", "text/css");
                scriptEl.setAttribute("href", filename);
            }
            if (typeof scriptEl != "undefined")
                document.getElementsByTagName("head")[0].appendChild(scriptEl);
        };
        Compile.concatAndResolveUrl = function (baseUrl, concat) {
            var url1 = baseUrl.split('/');
            var url2 = concat.split('/');
            var url3 = [];
            for (var i = 0, l = url1.length; i < l; i++) {
                if (url1[i] == '..') {
                    url3.pop();
                }
                else if (url1[i] == '.') {
                    continue;
                }
                else {
                    url3.push(url1[i]);
                }
            }
            for (var i = 0, l = url2.length; i < l; i++) {
                if (url2[i] == '..') {
                    url3.pop();
                }
                else if (url2[i] == '.') {
                    continue;
                }
                else {
                    url3.push(url2[i]);
                }
            }
            return url3.join('/');
        };
        Compile.includeCm3Library = function (cmworld3BaseURL) {
            if (cmworld3BaseURL !== undefined && cmworld3BaseURL !== null) {
                var index1 = cmworld3BaseURL.indexOf("./", 0);
                var index2 = cmworld3BaseURL.indexOf("../", 0);
                if (index1 == 0 || index2 == 0) {
                    cmworld3BaseURL = Compile.concatAndResolveUrl(CMWORLD.Compile.getSiteRootUrl(), cmworld3BaseURL);
                }
            }
            else {
                cmworld3BaseURL = CMWORLD.Compile.getSiteRootUrl() + "/";
            }
            Compile.cmworld3BaseURL = cmworld3BaseURL;
            {
                var includeJS = [];
                if (Compile.DistributionMode) {
                    includeJS.push("lib/three.min.js");
                }
                else {
                    includeJS.push("lib/three.js");
                }
                includeJS.push("lib/lines/LineSegmentsGeometry.js");
                includeJS.push("lib/lines/LineGeometry.js");
                includeJS.push("lib/lines/WireframeGeometry2.js");
                includeJS.push("lib/lines/LineMaterial.js");
                includeJS.push("lib/lines/LineSegments2.js");
                includeJS.push("lib/lines/Line2.js");
                includeJS.push("lib/lines/Wireframe.js");
                includeJS.push("Utilities/THREEx.KeyboardState.js");
                includeJS.push("lib/image/jpegdecode.js");
                includeJS.push("lib/unicode.js");
                includeJS.push("lib/octree.js");
                includeJS.push("lib/proj4.js");
                includeJS.push("lib/canvastoBlob.js");
                includeJS.push("lib/ThreeCSG.js");
                includeJS.push("lib/jszip.min.js");
                includeJS.push("lib/loaders/ColladaLoader.js");
                includeJS.push("lib/loaders/MTLLoader.js");
                includeJS.push("lib/loaders/OBJLoader.js");
                includeJS.push("lib/loaders/DDSLoader.js");
                includeJS.push("lib/postprocessing/EffectComposer.js");
                includeJS.push("lib/postprocessing/ClearPass.js");
                includeJS.push("lib/postprocessing/MaskPass.js");
                includeJS.push("lib/postprocessing/RenderPass.js");
                includeJS.push("lib/postprocessing/ShaderPass.js");
                includeJS.push("lib/postprocessing/DotScreenPass.js");
                includeJS.push("lib/shaders/CopyShader.js");
                includeJS.push("lib/shaders/DotScreenShader.js");
                includeJS.push("lib/msgpack.min.js");
                includeJS.push("Loader/TDSLoader.js");
                includeJS.push("Worker/cm_commonfunc.js");
                for (var i = 0; i < includeJS.length; i++) {
                    var path = cmworld3BaseURL + includeJS[i];
                    document.write('<script type="text/javascript" src="' + path + '"></script>');
                }
            }
            if (Compile.DistributionMode) {
                var path = cmworld3BaseURL + "cm3webgl-0.4.5.min.js";
                document.write('<script type="text/javascript" src="' + path + '"></script>');
            }
            else {
                Compile.addCm3DevelopmentLibrary(cmworld3BaseURL);
            }
        };
        Compile.addCm3DevelopmentLibrary = function (cmworld3BaseURL) {
            if (Compile.DistributionMode == false) {
                var includeJS = [
                    "cm_const.js",
                    "cm_enums.js",
                    "Core/cm_event.js",
                    "Core/cm_color.js",
                    "Core/cm_geometry.js",
                    "Core/cm_associativearray.js",
                    "Core/cm_framestate.js",
                    "IO/cm_binaryreader.js",
                    "IO/cm_cache.js",
                    "Utilities/cm_time.js",
                    "Utilities/cm_memmanager.js",
                    "Utilities/cm_fps.js",
                    "Utilities/TextureBlender.js",
                    "Utilities/cm_disposemanager.js",
                    "Utilities/cm_canvas.js",
                    "Utilities/cm_etcutil.js",
                    "Utilities/cm_geometryutil.js",
                    "Utilities/cm_network.js",
                    "Utilities/cm_confirmutil.js",
                    "Utilities/fontinit.js",
                    "Utilities/cm_util.js",
                    "Utilities/cm_activiychecker.js",
                    "Math3D/cm_worldtimer.js",
                    "Math3D/cm_suncalculator.js",
                    "Math3D/cm_angle.js",
                    "Math3D/cm_mathengine.js",
                    "Math3D/cm_mathengine2d.js",
                    "Math3D/cm_mathengines3d.js",
                    "Math3D/cm_mathenginep3d.js",
                    "Math3D/cm_mathenginep2d.js",
                    "Math3D/cm_coordbound.js",
                    "Math3D/cm_camera.js",
                    "Math3D/cm_cameraglobe.js",
                    "Math3D/cm_camerautil.js",
                    "Math3D/cm_cameraglobefirstperson.js",
                    "Math3D/cm_cameraflat3d.js",
                    "Objects/cm_axis3d.js",
                    "Objects/cm_material.js",
                    "SpecitialEffect/cm_pass.js",
                    "SpecitialEffect/SkyShader.js",
                    "SpecitialEffect/cm_clipbox.js",
                    "SpecitialEffect/cm_shaderlib.js",
                    "SpecitialEffect/cm_basepass.js",
                    "SpecitialEffect/cm_spacepass.js",
                    "SpecitialEffect/cm_hudpass.js",
                    "SpecitialEffect/cm_shadercode.js",
                    "Map/cm_tile.js",
                    "Map/cm_stylemanager.js",
                    "Map/cm_quadtilequery.js",
                    "Map/cm_tiledmapinfo.js",
                    "Map/cm_poisymbolmanager.js",
                    "Map/cm_quadimageloader.js",
                    "Map/cm_quadimageloadmanager.js",
                    "Map/cm_atmosphere.js",
                    "Map/cm_demfile.js",
                    "Map/VectorObject/cm_vectorobject.js",
                    "Map/cm_quadinfostruct.js",
                    "Map/cm_latlongridline.js",
                    "Map/cm_quadimagetile.js",
                    "Map/cm_jobmanager.js",
                    "Map/cm_overlayimagetile.js",
                    "Map/cm_overlayimage.js",
                    "Map/cm_modelloadmanager.js",
                    "Map/Layer/cm_ilayer.js",
                    "Map/Layer/cm_layer.js",
                    "Map/Layer/cm_tilelayer.js",
                    "Map/Layer/cm_gislayer.js",
                    "Map/Layer/cm_quadimagelayer.js",
                    "Map/Layer/cm_overlayimagetilelayer.js",
                    "Map/Layer/cm_quadterrainlayer.js",
                    "Map/Layer/cm_poi3dlayer.js",
                    "Map/Layer/cm_userobjectlayer.js",
                    "Map/Cube/cm_cubegrouploader.js",
                    "Map/Cube/cm_cubegrouploadmanager.js",
                    "Map/Cube/cm_cubegrouplayer.js",
                    "Map/Cube/cm_cubegroup.js",
                    "Map/Cube3d/c3_grouplayer.js",
                    "Map/Cube3d/c3_Math.js",
                    "Map/Cube3d/c3_CoordBound.js",
                    "Map/Cube3d/c3_Cube3DInfoStruct.js",
                    "Map/Cube3d/c3_Cube3DTarget.js",
                    "Map/Cube3d/c3_Cube3DClipTarget.js",
                    "Map/Cube3d/c3_Cube3DLayer.js",
                    "Map/Cube3d/c3_RasterLayer.js",
                    "Map/Cube3d/c3_VectorLayer.js",
                    "Map/Cube3d/c3_UnderGroundLayer.js",
                    "Map/Cube3d/c3_Cube3D.js",
                    "Map/Cube3d/c3_RasterCube3D.js",
                    "Map/Cube3d/c3_VectorCube3D.js",
                    "Map/Cube3d/c3_UnderGroundClipCube3D.js",
                    "Map/Cube3d/c3_VirtualCube3D.js",
                    "Map/Vector/cm_vectorimagemapmanager.js",
                    "Map/Vector/cm_cmvstyle.js",
                    "Map/Vector/cm_vectortilelayer.js",
                    "Map/Vector/cm_vectorimagetilelayer.js",
                    "Map/Vector/cm_cmvgeometry.js",
                    "Map/Vector/cm_line2d.js",
                    "Map/Vector/cm_line3d.js",
                    "Map/Vector/cm_poi3d.js",
                    "Map/Vector/cm_surface2d.js",
                    "Map/Vector/cm_surface3d.js",
                    "Map/Vector/cm_pointmesh.js",
                    "Map/Vector/cm_cmvreader.js",
                    "Map/Vector/cm_geojsonreader.js",
                    "Map/Vector/cm_vectortilebase.js",
                    "Map/Vector/cm_vectortile.js",
                    "Map/Vector/cm_vectorimagetile.js",
                    "Map/vWorld/vw_object.js",
                    "Map/vWorld/vw_real3dlayer.js",
                    "Map/vWorld/vw_real3dtile.js",
                    "Map/vWorld/vw_building.js",
                    "Map/vWorld/vw_poilayer.js",
                    "Map/vWorld/vw_poitile.js",
                    "Map/vWorld/vw_poi.js",
                    "Map/vWorld/vw_util.js",
                    "Map/style/cm_styleinfo.js",
                    "Map/cm_userobject.js",
                    "Map/cm_objectdownloadmanager.js",
                    "Map/cm_map.js",
                    "Map/polar/polar.js",
                    "shader/Mirror.js",
                    "shader/WaterShader.js",
                    "Loader/cm_3dsloader.js",
                    "Loader/cm_xdoloader.js",
                    "Loader/cm_spoloader.js",
                    "Geo/cm_gisobject.js",
                    "Geo/cm_gispoint.js",
                    "Geo/cm_gispolyline.js",
                    "Geo/cm_gispolygon.js",
                    "Geo/cm_rectangle.js",
                    "Geo/cm_giscircle.js",
                    "Geo/cm_sphere.js",
                    "Geo/cm_volumepolygon.js",
                    "UserDraw/cm_userdrawhandler.js",
                    "cm_workermanager.js",
                    "cm_earthsc.js",
                    "cm_mouse.js",
                    "cm_keyboard.js",
                    "cm_globaloption.js",
                    "cm_cmworld3.js",
                    "cm_cmworld.js",
                ];
                for (var i = 0; i < includeJS.length; i++) {
                    var path = cmworld3BaseURL + includeJS[i];
                    document.write('<script type="text/javascript" src="' + path + '"></script>');
                }
            }
        };
        return Compile;
    }());
Compile.DistributionMode = true;
    Compile.cmworld3BaseURL = "./";
    CMWORLD.Compile = Compile;
})(CMWORLD || (CMWORLD = {}));
if (!String.prototype['startsWith']) {
    String.prototype['startsWith'] = function (searchString, position) {
        position = position || 0;
        return this.indexOf(searchString, position) === position;
    };
}
