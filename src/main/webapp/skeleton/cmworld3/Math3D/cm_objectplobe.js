var CMWORLD;
(function (CMWORLD) {
    var ObjectPlobe = (function () {
        function ObjectPlobe() {
            this.position = new THREE.Vector3();
            this.localToWorldMatrix = new THREE.Matrix4();
            this.rotation = null;
        }
        ObjectPlobe.prototype.setPosition = function (vect) {
            this.position.x = vect.x;
            this.position.y = vect.y;
            this.position.z = vect.z;
        };
        ObjectPlobe.prototype.setRotation = function (rotate) {
            this.rotation = rotate.clone();
        };
        ObjectPlobe.prototype.transformDirection = function (v) {
        };
        ObjectPlobe.prototype.rotateAround = function (point, axis, angle) {
            axis.normalize();
        };
        return ObjectPlobe;
    }());
    CMWORLD.ObjectPlobe = ObjectPlobe;
})(CMWORLD || (CMWORLD = {}));
