var seidel_edge = (function () {
    function seidel_edge(p, q) {
        this.poly = null;
        this.below = null;
        this.above = null;
        this.p = p;
        this.q = q;
        this.slope = (q.y - p.y) / (q.x - p.x);
        this.poly = null;
        this.below = null;
        this.above = null;
    }
    return seidel_edge;
}());
var seidel_point = (function () {
    function seidel_point(x, y) {
        this.x = x;
        this.y = y;
    }
    return seidel_point;
}());
var seidel_polygonnode = (function () {
    function seidel_polygonnode(point) {
        this.point = null;
        this.next = null;
        this.prev = null;
        this.ear = false;
        this.point = point;
        this.next = null;
        this.prev = null;
        this.ear = false;
    }
    return seidel_polygonnode;
}());
var seidel_polygon = (function () {
    function seidel_polygon() {
        this.length = 0;
        this.first = null;
        this.last = null;
    }
    seidel_polygon.prototype.add = function (point) {
        var node = new seidel_polygonnode(point);
        if (!this.length) {
            this.first = this.last = node;
        }
        else {
            this.last.next = node;
            node.prev = this.last;
            this.last = node;
        }
        this.length++;
    };
    seidel_polygon.prototype.remove = function (node) {
        if (!this.length)
            return;
        if (node === this.first) {
            this.first = this.first.next;
            if (!this.first)
                this.last = null;
            else
                this.first.prev = null;
        }
        else if (node === this.last) {
            this.last = this.last.prev;
            this.last.next = null;
        }
        else {
            node.prev.next = node.next;
            node.next.prev = node.prev;
        }
        node.prev = null;
        node.next = null;
        this.length--;
    };
    seidel_polygon.prototype.insertBefore = function (point, node) {
        var newNode = new seidel_polygonnode(point);
        newNode.prev = node.prev;
        newNode.next = node;
        if (!node.prev)
            this.first = newNode;
        else
            node.prev.next = newNode;
        node.prev = newNode;
        this.length++;
    };
    return seidel_polygon;
}());
var seidel_querygraph_node = (function () {
    function seidel_querygraph_node() {
        this.point = null;
        this.edge = null;
        this.lchild = null;
        this.rchild = null;
        this.trapezoid = null;
    }
    return seidel_querygraph_node;
}());
var seidel_querygraph = (function () {
    function seidel_querygraph(head) {
        this.head = head;
    }
    seidel_querygraph.prototype.locate = function (point, slope) {
        var node = this.head, orient;
        while (node) {
            if (node.trapezoid)
                return node.trapezoid;
            if (node.point) {
                node = point.x >= node.point.x ? node.rchild : node.lchild;
            }
            else if (node.edge) {
                orient = seidel.edgeOrient(node.edge, point);
                node =
                    orient < 0 ? node.rchild :
                        orient > 0 ? node.lchild :
                            slope < node.edge.slope ? node.rchild : node.lchild;
            }
        }
    };
    seidel_querygraph.prototype.case1 = function (sink, edge, t1, t2, t3, t4) {
        var yNode = seidel_querygraph.setYNode(new seidel_querygraph_node(), edge, seidel_querygraph.getSink(t2), seidel_querygraph.getSink(t3)), qNode = seidel_querygraph.setXNode(new seidel_querygraph_node(), edge.q, yNode, seidel_querygraph.getSink(t4));
        seidel_querygraph.setXNode(sink, edge.p, seidel_querygraph.getSink(t1), qNode);
    };
    seidel_querygraph.prototype.case2 = function (sink, edge, t1, t2, t3) {
        var yNode = seidel_querygraph.setYNode(new seidel_querygraph_node(), edge, seidel_querygraph.getSink(t2), seidel_querygraph.getSink(t3));
        seidel_querygraph.setXNode(sink, edge.p, seidel_querygraph.getSink(t1), yNode);
    };
    seidel_querygraph.prototype.case3 = function (sink, edge, t1, t2) {
        seidel_querygraph.setYNode(sink, edge, seidel_querygraph.getSink(t1), seidel_querygraph.getSink(t2));
    };
    seidel_querygraph.prototype.case4 = function (sink, edge, t1, t2, t3) {
        var yNode = seidel_querygraph.setYNode(new seidel_querygraph_node(), edge, seidel_querygraph.getSink(t1), seidel_querygraph.getSink(t2));
        seidel_querygraph.setXNode(sink, edge.q, yNode, seidel_querygraph.getSink(t3));
    };
    seidel_querygraph.setYNode = function (node, edge, lchild, rchild) {
        node.edge = edge;
        node.lchild = lchild;
        node.rchild = rchild;
        node.trapezoid = null;
        return node;
    };
    seidel_querygraph.setXNode = function (node, point, lchild, rchild) {
        node.point = point;
        node.lchild = lchild;
        node.rchild = rchild;
        node.trapezoid = null;
        return node;
    };
    seidel_querygraph.setSink = function (node, trapezoid) {
        node.trapezoid = trapezoid;
        trapezoid.sink = node;
        return node;
    };
    seidel_querygraph.getSink = function (trapezoid) {
        return trapezoid.sink || this.setSink(new seidel_querygraph_node(), trapezoid);
    };
    return seidel_querygraph;
}());
var seidel_Trapezoid = (function () {
    function seidel_Trapezoid(leftPoint, rightPoint, top, bottom) {
        this.leftPoint = null;
        this.rightPoint = null;
        this.top = null;
        this.bottom = null;
        this.inside = false;
        this.removed = false;
        this.sink = null;
        this.upperLeft = null;
        this.upperRight = null;
        this.lowerLeft = null;
        this.lowerRight = null;
        this.leftPoint = leftPoint;
        this.rightPoint = rightPoint;
        this.top = top;
        this.bottom = bottom;
        this.inside = false;
        this.removed = false;
        this.sink = null;
        this.upperLeft = null;
        this.upperRight = null;
        this.lowerLeft = null;
        this.lowerRight = null;
    }
    seidel_Trapezoid.prototype.updateLeft = function (ul, ll) {
        this.upperLeft = ul;
        if (ul)
            ul.upperRight = this;
        this.lowerLeft = ll;
        if (ll)
            ll.lowerRight = this;
    };
    seidel_Trapezoid.prototype.updateRight = function (ur, lr) {
        this.upperRight = ur;
        if (ur)
            ur.upperLeft = this;
        this.lowerRight = lr;
        if (lr)
            lr.lowerLeft = this;
    };
    seidel_Trapezoid.prototype.updateLeftRight = function (ul, ll, ur, lr) {
        this.updateLeft(ul, ll);
        this.updateRight(ur, lr);
    };
    seidel_Trapezoid.prototype.markInside = function () {
        var stack = [this];
        while (stack.length) {
            var t = stack.pop();
            if (!t.inside) {
                t.inside = true;
                if (t.upperLeft)
                    stack.push(t.upperLeft);
                if (t.lowerLeft)
                    stack.push(t.lowerLeft);
                if (t.upperRight)
                    stack.push(t.upperRight);
                if (t.lowerRight)
                    stack.push(t.lowerRight);
            }
        }
    };
    seidel_Trapezoid.prototype.contains = function (point) {
        return point.x > this.leftPoint.x &&
            point.x < this.rightPoint.x &&
            seidel.edgeAbove(this.top, point) &&
            seidel.edgeBelow(this.bottom, point);
    };
    seidel_Trapezoid.prototype.addPoint = function (edge, point) {
        var poly = edge.poly;
        if (!poly) {
            if (seidel.neq(point, edge.p) && seidel.neq(point, edge.q)) {
                poly = edge.poly = new seidel_polygon();
                poly.add(edge.p);
                poly.add(point);
                poly.add(edge.q);
            }
        }
        else {
            var v = poly.first;
            while (v) {
                if (!seidel.neq(point, v.point))
                    return;
                if (point.x < v.point.x) {
                    poly.insertBefore(point, v);
                    return;
                }
                v = v.next;
            }
            poly.add(point);
        }
    };
    seidel_Trapezoid.prototype.addPoints = function () {
        if (this.leftPoint !== this.bottom.p)
            this.addPoint(this.bottom, this.leftPoint);
        if (this.rightPoint !== this.bottom.q)
            this.addPoint(this.bottom, this.rightPoint);
        if (this.leftPoint !== this.top.p)
            this.addPoint(this.top, this.leftPoint);
        if (this.rightPoint !== this.top.q)
            this.addPoint(this.top, this.rightPoint);
    };
    return seidel_Trapezoid;
}());
var seidel_TrapezoidalMap = (function () {
    function seidel_TrapezoidalMap() {
        this.root = null;
        this.items = [];
        this.queryGraph = null;
        this.bcross = null;
        this.tcross = null;
        var top = new seidel_edge(new seidel_point(-Infinity, Infinity), new seidel_point(Infinity, Infinity)), bottom = new seidel_edge(new seidel_point(-Infinity, -Infinity), new seidel_point(Infinity, -Infinity));
        this.root = new seidel_Trapezoid(bottom.p, top.q, top, bottom);
        this.items = [];
        this.items.push(this.root);
        this.queryGraph = new seidel_querygraph(this.root);
    }
    seidel_TrapezoidalMap.prototype.addEdge = function (edge) {
        var t = this.queryGraph.locate(edge.p, edge.slope);
        if (!t)
            return false;
        var cp, cq;
        while (t) {
            cp = cp ? false : t.contains(edge.p);
            cq = cq ? false : t.contains(edge.q);
            t = cp && cq ? this.case1(t, edge) :
                cp && !cq ? this.case2(t, edge) :
                    !cp && !cq ? this.case3(t, edge) : this.case4(t, edge);
            if (t === null)
                return false;
        }
        this.bcross = null;
        this.tcross = null;
        return true;
    };
    seidel_TrapezoidalMap.prototype.nextTrapezoid = function (t, edge) {
        return edge.q.x <= t.rightPoint.x ? false :
            seidel.edgeAbove(edge, t.rightPoint) ? t.upperRight : t.lowerRight;
    };
    seidel_TrapezoidalMap.prototype.case1 = function (t, e) {
        var t2 = new seidel_Trapezoid(e.p, e.q, t.top, e), t3 = new seidel_Trapezoid(e.p, e.q, e, t.bottom), t4 = new seidel_Trapezoid(e.q, t.rightPoint, t.top, t.bottom);
        t4.updateRight(t.upperRight, t.lowerRight);
        t4.updateLeft(t2, t3);
        t.rightPoint = e.p;
        t.updateRight(t2, t3);
        var sink = t.sink;
        t.sink = null;
        this.queryGraph.case1(sink, e, t, t2, t3, t4);
        this.items.push(t2, t3, t4);
        return false;
    };
    seidel_TrapezoidalMap.prototype.case2 = function (t, e) {
        var next = this.nextTrapezoid(t, e), t2 = new seidel_Trapezoid(e.p, t.rightPoint, t.top, e), t3 = new seidel_Trapezoid(e.p, t.rightPoint, e, t.bottom);
        t.rightPoint = e.p;
        t.updateLeft(t.upperLeft, t.lowerLeft);
        t2.updateLeftRight(t, null, t.upperRight, null);
        t3.updateLeftRight(null, t, null, t.lowerRight);
        this.bcross = t.bottom;
        this.tcross = t.top;
        e.above = t2;
        e.below = t3;
        var sink = t.sink;
        t.sink = null;
        this.queryGraph.case2(sink, e, t, t2, t3);
        this.items.push(t2, t3);
        return next;
    };
    seidel_TrapezoidalMap.prototype.case3 = function (t, e) {
        var next = this.nextTrapezoid(t, e), bottom = t.bottom, lowerRight = t.lowerRight, lowerLeft = t.lowerLeft, top = t.top, t1, t2;
        if (this.tcross === t.top) {
            t1 = t.upperLeft;
            t1.updateRight(t.upperRight, null);
            t1.rightPoint = t.rightPoint;
        }
        else {
            t1 = t;
            t1.bottom = e;
            t1.lowerLeft = e.above;
            if (e.above)
                e.above.lowerRight = t1;
            t1.lowerRight = null;
        }
        if (this.bcross === bottom) {
            t2 = lowerLeft;
            t2.updateRight(null, lowerRight);
            t2.rightPoint = t.rightPoint;
        }
        else if (t1 === t) {
            t2 = new seidel_Trapezoid(t.leftPoint, t.rightPoint, e, bottom);
            t2.updateLeftRight(e.below, lowerLeft, null, lowerRight);
            this.items.push(t2);
        }
        else {
            t2 = t;
            t2.top = e;
            t2.upperLeft = e.below;
            if (e.below)
                e.below.upperRight = t2;
            t2.upperRight = null;
        }
        if (t !== t1 && t !== t2)
            t.removed = true;
        this.bcross = bottom;
        this.tcross = top;
        e.above = t1;
        e.below = t2;
        var sink = t.sink;
        t.sink = null;
        this.queryGraph.case3(sink, e, t1, t2);
        return next;
    };
    seidel_TrapezoidalMap.prototype.case4 = function (t, e) {
        var next = this.nextTrapezoid(t, e), t1, t2;
        if (this.tcross === t.top) {
            t1 = t.upperLeft;
            t1.rightPoint = e.q;
        }
        else {
            t1 = new seidel_Trapezoid(t.leftPoint, e.q, t.top, e);
            t1.updateLeft(t.upperLeft, e.above);
            this.items.push(t1);
        }
        if (this.bcross === t.bottom) {
            t2 = t.lowerLeft;
            t2.rightPoint = e.q;
        }
        else {
            t2 = new seidel_Trapezoid(t.leftPoint, e.q, e, t.bottom);
            t2.updateLeft(e.below, t.lowerLeft);
            this.items.push(t2);
        }
        t.leftPoint = e.q;
        t.updateLeft(t1, t2);
        var sink = t.sink;
        t.sink = null;
        this.queryGraph.case4(sink, e, t1, t2, t);
        return next;
    };
    seidel_TrapezoidalMap.prototype.collectPoints = function () {
        var i, t, len = this.items.length;
        for (i = 0; i < len; i++) {
            t = this.items[i];
            if (t.removed)
                continue;
            if (t.top === this.root.top && t.bottom.below && !t.bottom.below.removed) {
                t.bottom.below.markInside();
                break;
            }
            if (t.bottom === this.root.bottom && t.top.above && !t.top.above.removed) {
                t.top.above.markInside();
                break;
            }
        }
        for (i = 0; i < len; i++) {
            t = this.items[i];
            if (!t.removed && t.inside) {
                if (t.top.p.y === Infinity)
                    return false;
                t.addPoints();
            }
        }
        return true;
    };
    return seidel_TrapezoidalMap;
}());
var seidel = (function () {
    function seidel() {
    }
    seidel.triangulate = function (rings) {
        var triangles = [], edges = [], i, j, k, points, p, q, len, done;
        for (k = 0; k < rings.length; k++) {
            points = rings[k];
            for (i = 0, len = points.length; i < len; i++) {
                j = i < len - 1 ? i + 1 : 0;
                p = i ? q : this.shearTransform(points[i]);
                q = this.shearTransform(points[j]);
                edges.push(p.x > q.x ? new seidel_edge(q, p) : new seidel_edge(p, q));
            }
        }
        var map = new seidel_TrapezoidalMap();
        for (i = 0; i < edges.length; i++) {
            done = map.addEdge(edges[i]);
            if (!done)
                return null;
        }
        done = map.collectPoints();
        if (!done)
            return null;
        for (i = 0; i < edges.length; i++) {
            if (edges[i].poly && edges[i].poly.length) {
                this.triangulateMountain(edges[i], triangles);
            }
        }
        return triangles.length ? triangles : null;
    };
    seidel.shearTransform = function (point) {
        return new seidel_point(point[0] + this.SHEAR * point[1], point[1]);
    };
    seidel.earcut = function (points) {
        var triangles = [], sum = 0, len = points.length, i, j, last, clockwise, ear, prev, next;
        for (i = 0, j = len - 1; i < len; j = i++) {
            last = this.insertNode(points[i], last);
            sum += (points[i][0] - points[j][0]) * (points[i][1] + points[j][1]);
        }
        clockwise = sum < 0;
        ear = last;
        while (len > 2) {
            prev = ear.prev;
            next = ear.next;
            if (len === 3 || this.isEar(ear, clockwise)) {
                triangles.push([prev.p, ear.p, next.p]);
                ear.next.prev = ear.prev;
                ear.prev.next = ear.next;
                len--;
            }
            ear = next;
        }
        return triangles;
    };
    seidel.isEar = function (ear, clockwise) {
        var a = ear.prev.p, b = ear.p, c = ear.next.p, ax = a[0], bx = b[0], cx = c[0], ay = a[1], by = b[1], cy = c[1], abd = ax * by - ay * bx, acd = ax * cy - ay * cx, cbd = cx * by - cy * bx, A = abd - acd - cbd;
        if (clockwise !== (A > 0))
            return false;
        var sign = clockwise ? 1 : -1, node = ear.next.next, cay = cy - ay, acx = ax - cx, aby = ay - by, bax = bx - ax, p, px, py, s, t;
        while (node !== ear.prev) {
            p = node.p;
            px = p[0];
            py = p[1];
            s = (cay * px + acx * py - acd) * sign;
            t = (aby * px + bax * py + abd) * sign;
            if (s >= 0 && t >= 0 && (s + t) <= A * sign)
                return false;
            node = node.next;
        }
        return true;
    };
    seidel.insertNode = function (point, last) {
        var node = {
            p: point,
            prev: null,
            next: null
        };
        if (!last) {
            node.prev = node;
            node.next = node;
        }
        else {
            node.next = last.next;
            node.prev = last;
            last.next.prev = node;
            last.next = node;
        }
        return node;
    };
    seidel.triangulateMountain = function (edge, triangles) {
        var a = edge.p, b = edge.q, poly = edge.poly, p = poly.first.next;
        if (poly.length < 3)
            return;
        else if (poly.length === 3) {
            triangles.push([a, p.point, b]);
            return;
        }
        var convexPoints = [], positive = this.cross(p.point, b, a) > 0;
        while (p !== poly.last) {
            this.addEar(convexPoints, p, poly, positive);
            p = p.next;
        }
        while (convexPoints.length) {
            var ear = convexPoints.shift(), prev = ear.prev, next = ear.next;
            triangles.push([prev.point, ear.point, next.point]);
            poly.remove(ear);
            this.addEar(convexPoints, prev, poly, positive);
            this.addEar(convexPoints, next, poly, positive);
        }
    };
    seidel.addEar = function (points, p, poly, positive) {
        if (!p.ear && p !== poly.first && p !== poly.last && this.isConvex(p, positive)) {
            p.ear = true;
            points.push(p);
        }
    };
    seidel.isConvex = function (p, positive) {
        return positive === (this.cross(p.next.point, p.prev.point, p.point) > 0);
    };
    seidel.neq = function (p1, p2) {
        return p1.x !== p2.x || p1.y !== p2.y;
    };
    ;
    seidel.clone = function (p) {
        return new seidel_point(p.x, p.y);
    };
    ;
    seidel.cross = function (a, b, c) {
        var acx = a.x - c.x, bcx = b.x - c.x, acy = a.y - c.y, bcy = b.y - c.y;
        return acx * bcy - acy * bcx;
    };
    seidel.edgeOrient = function (edge, point) {
        return this.cross(edge.p, edge.q, point);
    };
    seidel.edgeAbove = function (edge, point) {
        return this.cross(edge.p, edge.q, point) < 0;
    };
    seidel.edgeBelow = function (edge, point) {
        return this.cross(edge.p, edge.q, point) > 0;
    };
    return seidel;
}());
seidel.SHEAR = 1e-10;
