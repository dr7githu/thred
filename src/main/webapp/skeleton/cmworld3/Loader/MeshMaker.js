MeshMaker = function (geometry, hasTextures, imageUrls, diffuseColors)
{
   var objects = null;

   var realmake = function (deferred)
   {
      //var material;
      var matarray = [];
      for (var i = 0; i < hasTextures.length; i++)
      {
         if (hasTextures[i] == 1 && objects[i])
         {
            var texture = new THREE.Texture();
            texture.image = objects[i];
            //var texture = new THREE.Texture(objects[i]);
            //var loader = new THREE.TextureLoader();
            //var texture = loader.load("textures/a.jpg");

            texture.needUpdate = true;
            var mat = new THREE.MeshPhongMaterial({ map: texture, specular: 0x222222, shininess: 0, shading: THREE.SmoothShading });
            mat.side = THREE.DoubleSide;
            //mat.wireframe = true;
            matarray.push(mat);
         }
         else
         {
            //mat = new THREE.MeshPhongMaterial({ color: edata.data.diffuseColors[i], specular: 0x222222, shininess: 0, shading: THREE.SmoothShading });
            mat = new THREE.MeshPhongMaterial({ color: 0xffff00, specular: 0x222222, shininess: 0, shading: THREE.SmoothShading });
            mat.side = THREE.DoubleSide;
            //mat.wireframe = true;
            matarray.push(mat);
         }
      }

      material = new THREE.MultiMaterial(matarray);
      material.needUpdate = true;
                           
      var mesh = new THREE.Mesh(geometry, material);

      deferred.resolve(mesh);
   }

   var make = function (deferred)
   {
      var material = null;

      var images = [];

      for (var i = 0; i < imageUrls.length; i++)
      {
         if (hasTextures[i] == 1)
         {
            //var path = resourceurl.concat(imageUrls[i]);
            images.push($.cmloadImage(imageUrls[i]));
         }
         else
         {
            images.push("");
         }
      }

      $.when.apply($, images).then(
            function ()
            {
               // 완료된 이미지 들이 들어 있다.
               objects = arguments;

               realmake(deferred);

               
            }
         ).fail(
            function ()
            {
               //var objects = arguments;
               // 이미지가 없는 거니까 실패해도 일단은 그리자.
               deferred.reject(null);
            }
         );

      //deferred.resolve(geo);
   };

   return $.Deferred(make).promise();
}