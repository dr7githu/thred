GroundModePass = function (scene, camera)
{
   this.Points = [];
   this.Planes = [];
   this.Normals = [];
   this.NormalsArray = new Array(0, 0, 0);
   this.Const = [];
   this.clipBox = null;

   this.scene = scene;
   this.camera = camera;

   this.enabled = true;
   this.clear = true;
   this.needsSwap = false;

   this.inverse = false;

   this.camera = CmWorld3.getInstance().option.MainCamera.mainCamera;
   this.origin = new THREE.Vector3();

   for (var i = 0; i < 6; i++)
   {
      this.Normals.push(new THREE.Vector3());
      this.Const.push(1.0);
   }
}

GroundModePass.prototype = 
{
   SetClipBox: function (points, clipinside)
   {
      if (points)
      {
         if (points.length < 8)
            return;

         var cmworld = CmWorld3.getInstance();

         if (this.clipBox)
         {
             cmworld.option.scene.remove(this.clipBox);
         }

         this.ClipboxInside = clipinside;
         this.Points = [];

         var pt;

         for (var i = 0; i < 8; i++)
         {
             this.Points.push(new THREE.Vector3(points[i].x, points[i].y, (points[i].z * cmworld.option.VerticalExaggeration) + cm_const.EarthRadius));
         }

         this.origin.x = points[0].x;
         this.origin.y = points[0].y;
         this.origin.z = points[0].z;

         // 우선 여덟게의 점의 구하자.
         var pts = [];

         for (var i = 0; i < this.Points.length; i++)
         {
            pts.push(CmMathEngine.Geo2Cartesian(this.Points[i].x, this.Points[i].y, this.Points[i].z));
         }

         // 이제 각각의 지점들을 이용해서 plane를 만들자.
         // 근데 이게 삼각형이 안쪽으로 가야 한다.
         // 그러니까 순서가 바뀌어야 한다.
         this.Planes = [];
         this.Normals = [];
         this.Const = [];
         var plane = new THREE.Plane();
         plane.setFromCoplanarPoints(pts[0], pts[4], pts[1]);
         this.Planes.push(plane);
         this.Normals.push(new THREE.Vector3(plane.normal.x, plane.normal.y, plane.normal.z));
         this.Const.push(plane.constant);

         plane = new THREE.Plane();
         plane.setFromCoplanarPoints(pts[1], pts[5], pts[2]);
         this.Planes.push(plane);
         this.Normals.push(new THREE.Vector3(plane.normal.x, plane.normal.y, plane.normal.z));
         this.Const.push(plane.constant);

         plane = new THREE.Plane();
         plane.setFromCoplanarPoints(pts[2], pts[6], pts[3]);
         this.Planes.push(plane);
         this.Normals.push(new THREE.Vector3(plane.normal.x, plane.normal.y, plane.normal.z));
         this.Const.push(plane.constant);

         plane = new THREE.Plane();
         plane.setFromCoplanarPoints(pts[3], pts[7], pts[0]);
         this.Planes.push(plane);
         this.Normals.push(new THREE.Vector3(plane.normal.x, plane.normal.y, plane.normal.z));
         this.Const.push(plane.constant);

         plane = new THREE.Plane();
         plane.setFromCoplanarPoints(pts[0], pts[1], pts[3]);
         this.Planes.push(plane);
         this.Normals.push(new THREE.Vector3(plane.normal.x, plane.normal.y, plane.normal.z));
         this.Const.push(plane.constant);

         plane = new THREE.Plane();
         plane.setFromCoplanarPoints(pts[4], pts[7], pts[5]);
         this.Planes.push(plane);
         this.Normals.push(new THREE.Vector3(plane.normal.x, plane.normal.y, plane.normal.z));
         this.Const.push(plane.constant);

         this.NormalsArray = [];

         for (var i = 0; i < this.Normals.length; i++)
         {
            this.NormalsArray.push(this.Normals[i].x);
            this.NormalsArray.push(this.Normals[i].y);
            this.NormalsArray.push(this.Normals[i].z);
         }

         /*
         var geo = new THREE.BufferGeometry();
         var vert = new Float32Array(pts.length * 3);

         for (var i = 1; i < pts.length; i++)
         {
            pts[i].x -= pts[0].x;
            pts[i].y -= pts[0].y;
            pts[i].z -= pts[0].z;
         }

         pts[0].x = 0;
         pts[0].y = 0;
         pts[0].z = 0;

         var idx = 0;

         for(i = 0; i < pts.length; i++)
         {
            vert[idx++] = pts[i].x;
            vert[idx++] = pts[i].y;
            vert[idx++] = pts[i].z;
         }

         var index = new Uint16Array(18);
         idx = 0;

         // 시계 방향으로 돌려야 한다.
         index[idx++] = 0; index[idx++] = 4; index[idx++] = 1;
         index[idx++] = 1; index[idx++] = 5; index[idx++] = 2;
         index[idx++] = 2; index[idx++] = 6; index[idx++] = 3;
         index[idx++] = 3; index[idx++] = 7; index[idx++] = 0;
         index[idx++] = 0; index[idx++] = 1; index[idx++] = 3;
         index[idx++] = 4; index[idx++] = 7; index[idx++] = 5;



         geo.addAttribute('position', new THREE.BufferAttribute(vert, 3));
         geo.setIndex(new THREE.BufferAttribute(index, 1));
         geo.computeVertexNormals();
         geo.computeBoundingSphere();

         geo.needUpdate = true;

         var mat = new THREE.MeshPhongMaterial({ color: "blue", wireframe : false });

         this.clipBox = new THREE.Mesh(geo, mat);

         cmworld.option.scene.add(this.clipBox);
         */
      }
   },

   clipboxVisible: function ()
   {
       var cmworld = CmWorld3.getInstance();

       if (cmworld.option.ClipboxEnable == true)
      {
         // 이건 적절한 값으로 조절해야 할듯
          if (cmworld.option.MainCamera.PositionGeo.z < cm_const.EarthRadius + 1000)
         {
            return true;
         }
      }

      return false;
   },

   intersectBoundingSphere : function(sphere)
   {
      if (this.clipBox)
      {
         // 우선 자신은 월드로 바꾸어져 있여야 한다.
         // 넘어온 놈도 월드로 바꾸어져 있어야 한다.
         // 일단 그냥하자.
      }
      return false;
   },

   setClipboxParam : function(material, mat)
   {
      return;
      if (material instanceof THREE.MeshPhongMaterial)
      {
         if (material.__webglShader)
         {
            if (material.__webglShader.uniforms)
            {
                var cmworld = CmWorld3.getInstance();

               var gVisible = this.clipboxVisible();

               if (material.__webglShader.uniforms["clipboxEnable"])
               {
                  if (gVisible == true)
                  {
                     material.__webglShader.uniforms["clipboxEnable"].value = 1;
                  }
                  else
                  {
                     material.__webglShader.uniforms["clipboxEnable"].value = 0;
                  }
               }

               // 이제 클립 사각형들을 설정하자.
               if (material.__webglShader.uniforms["vClipboxNormal"])
               {
                  material.__webglShader.uniforms["vClipboxNormal"].value = this.NormalsArray;
               }

               if (material.__webglShader.uniforms["vClipboxConst"])
               {
                  material.__webglShader.uniforms["vClipboxConst"].value = this.Const;
               }

               if (material.__webglShader.uniforms["clipInside"])
               {
                   if (cmworld.option.ClipboxInside == true)
                  {
                     material.__webglShader.uniforms["clipInside"].value = 1;
                  }
                  else
                  {
                     material.__webglShader.uniforms["clipInside"].value = 0;
                  }
               }
            }
         }
      }
   },

   render: function (renderer, writeBuffer, readBuffer, delta)
   {
      var gVisible = this.clipboxVisible();
      var cmworld = CmWorld3.getInstance();

      if (gVisible)
      {
         var plane;

         var offset = cmworld.option.RefCenter.clone();

         offset.x = -offset.x;
         offset.y = -offset.y;
         offset.z = -offset.z;

         
         // normal들을 설정해 보자
         for (var i = 0; i < this.Planes.length; i++)
         {
            plane = this.Planes[i].clone();
            plane.translate(offset);
            //plane.updateMatrix();
            this.Normals[i].x = plane.normal.x;
            this.Normals[i].y = plane.normal.y;
            this.Normals[i].z = plane.normal.z;

            this.Const[i] = plane.constant;
         }
      }
      else
      {
      }

      if (this.clipBox)
      {
          var pt = CmMathEngine.Geo2Cartesian(this.origin.x, this.origin.y, (this.origin.z * cmworld.option.VerticalExaggeration) + cm_const.EarthRadius);

          pt.sub(cmworld.option.RefCenter);

         this.clipBox.position.copy(pt);
      }

   }
}
