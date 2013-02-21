// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require twitter/bootstrap
//= require jquery-fileupload/basic
//= require jquery-fileupload/vendor/tmpl
//= require galleria-1.2.9.min
//= require galleria.classic
//= require stripe
//= require_tree .
function packages(){
    var products = new Array();
    var i=0;
    $("input:checked").each(function(){
        products[i]=$(this).val();
        i++;
        //$(this).attr('checked',false);
    });
    //alert(products);
    
    var xmlhttp;
    if (window.XMLHttpRequest)
    { // code for IE7+, Firefox, Chrome, Opera, Safari
      xmlhttp=new XMLHttpRequest();
    }
    else
    {// code for IE6, IE5
      xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
    }
    xmlhttp.onreadystatechange=function()
    {
      if (xmlhttp.readyState==4 && xmlhttp.status==200)
      {
        document.getElementById("packages").innerHTML=xmlhttp.responseText;
      }
    }
    xmlhttp.open("GET","/packages/show?products="+products,true);
    xmlhttp.send();
  }
  
  //package amount
  function package_amount(){
      //alert(price);
      var packages = new Array();
    var i=0;
      $("input[type='radio']:checked").each(function(){
        packages[i]=$(this).val();
        i++;
        //$(this).attr('checked',false);
         //alert(packages);
    });
   var xmlhttp;
    if (window.XMLHttpRequest)
    { // code for IE7+, Firefox, Chrome, Opera, Safari
      xmlhttp=new XMLHttpRequest();
    }
    else
    {// code for IE6, IE5
      xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
    }
    xmlhttp.onreadystatechange=function()
    {
      if (xmlhttp.readyState==4 && xmlhttp.status==200)
      {
        document.getElementById("total_amount").value=xmlhttp.responseText;
        
      }
    }
    xmlhttp.open("GET","/packages/total_value?packeges="+packages,true);
    xmlhttp.send();
      //var total=parseFloat($('#total_amount')).val()||0;

  //$('#total_amount').val(price+total);
  //$("#amount_label").text(price+total);

  $('#total_amount1').val($('#total_amount').val());
  }