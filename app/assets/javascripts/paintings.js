jQuery(function() {

    return $('#new_painting').fileupload({
      type:'POST',
      dataType: "script",
      cache:false,

      add: function(e, data) {

        var file, types;
        types = /(\.|\/)(gif|jpe?g|png)$/i;
        file = data.files[0];
        if (types.test(file.type) || types.test(file.name)) {

          data.context = $(tmpl("template-upload", file));
          $('#new_painting').append(data.context);
          return data.submit();
        } else {
          return alert("" + file.name + " is not a gif, jpeg, or png image file");
        }
        
      },
      progress: function(e, data) {
        var progress;
        if (data.context) {
          progress = parseInt(data.loaded / data.total * 100, 10);
          return data.context.find('.bar').css('width', progress + '%');
        }
      },
      beforeSend: function (XMLHttpRequest) {

        // alert("ok");
        //Specifying this header ensures that the results will be returned as JSON.
        XMLHttpRequest.setRequestHeader("Accept", "text/javascript");
      }

    });

  });