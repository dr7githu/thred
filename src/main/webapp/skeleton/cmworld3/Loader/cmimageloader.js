cmimageloader = function ()
{
}



cmimageloader.prototype.Load = function (imageurl, completeFunc)
{
   if (imageurl === "")
   {
      //deffered.reject();
      return;
   }

   $.loadDXT1FromImage = function (url)
   {
      // Define a "worker" function that should eventually resolve or reject the deferred object.
      var loadImage = function (deferred)
      {
         var image = new Image();

         // Set up event handlers to know when the image has loaded
         // or fails to load due to an error or abort.
         image.onload = loaded;
         image.onerror = errored; // URL returns 404, etc
         image.onabort = errored; // IE may call this if user clicks "Stop"

         // Setting the src property begins loading the image.
         image.crossOrigin = "Anonymous";
         image.src = url;

         function loaded()
         {
            unbindEvents();
            // Calling resolve means the image loaded sucessfully and is ready to use.
            deferred.resolve(image);
         }
         function errored()
         {
            unbindEvents();
            // Calling reject means we failed to load the image (e.g. 404, server offline, etc).
            deferred.reject(image);
         }
         function unbindEvents()
         {
            // Ensures the event callbacks only get called once.
            image.onload = null;
            image.onerror = null;
            image.onabort = null;
         }
      };

      // Create the deferred object that will contain the loaded image.
      // We don't want callers to have access to the resolve() and reject() methods, 
      // so convert to "read-only" by calling `promise()`.
      return $.Deferred(loadImage).promise();
   };


   $.loadImage(imageurl).done(
      function(image)
      {
         var canvas = document.createElement("canvas");
         var context = canvas.getContext('2d');
         context.drawImage(image, 0, 0);
         var w = image.width, h = image.height;
         var imgdata = context.getImageData(0, 0, w, h);
         var rgba = imgdata.data;
         var worker = CMWORLD.CmWorld3.getInstance().option.getDXTImageWorker();

         worker.onmessage(event)
         {

         };


         var params = {
             height: imgdata.height,
             width: imgdata.width,
             rgba: imgdata.data
         };

         worker.postMessage(
             params, [params.rgba]);
      }).fail(
         function(image)
         {
            var deffered = new $.deffered();
            deffered.reject();
         }
      );
}