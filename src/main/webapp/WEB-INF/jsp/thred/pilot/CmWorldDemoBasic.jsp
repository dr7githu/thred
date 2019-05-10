<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>CM World Demo - CM World 3D Excercise</title>

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

<script>
	var cmworld;

	window.onload = function() {
		var canvas = document.querySelector("#cmworldCanvas");
		cmworld = new CMWORLD.CmWorld3(canvas, 127, 38,
				CMWORLD.cm_const.EarthRadius);

		loop();

		function loop() {
			requestAnimationFrame(loop);
			cmworld.update();
		}
	};
</script>

</head>
<body>
	<canvas id="cmworldCanvas"></canvas>
</body>
</html>