var ec=0;
//$(document).ready(function() {
//    $('#slides').slidesjs({
//        width: 600,
//        height: 1500,
//        navigation: true
//    });
//});


    $("#user_name").blur(function(event){


        $('#personal_info_error_name').html("");
        if($("#user_name").val()==""){
            $('#personal_info_error_name').append("<br/>* Full Name Can't be empty.");
        }else{
            $('#btn_personal').prop('disabled', false);
        }

    });
    $("#password").blur(function(event){
        $('#personal_info_error_password').html("");
        if($("#password").val()==""){
            $('#personal_info_error_password').append("<br/>* Password can't be empty.");
        }else if($("#password").val().length<8){
            $('#personal_info_error_password').append("<br/>* Password should be more than 8 characters. ");
        }else{
            $('#btn_personal').prop('disabled', false);
        }


    });

    $("#password_confirmation").blur(function(event){
        $('#personal_info_error_cpassword').html("");
        if($("#password_confirmation").val()==""){
            $('#personal_info_error_cpassword').append("<br/>* Password Confirmation should not be empty.");
        }else if($("#password_confirmation").val()!=$("#password").val()){
            $('#personal_info_error_cpassword').append("<br/>* Password and Password Confirmation should match.");
        }else{
            $('#btn_personal').prop('disabled', false);
        }

    });

    $("#user_add1").blur(function(event){
        $('#personal_info_error_add1').html("");
        if($("#user_add1").val()==""){
            $('#personal_info_error_add1').append("<br/>* Address1 can't be empty.");
        }else{
            $('#btn_personal').prop('disabled', false);
        }

    });

    $("#user_state").blur(function(event){
        $('#personal_info_error_state').html("");
        if($("#user_state").val()==""){
            $('#personal_info_error_state').append("<br/>* State Can't be empty.");
        }else{
            $('#btn_personal').prop('disabled', false);
        }

    });

    $("#user_city").blur(function(event){
        $('#personal_info_error_city').html("");
        if($("#user_city").val()==""){
            $('#personal_info_error_city').append("<br/>* City Can't be empty.");
        }else{
            $('#btn_personal').prop('disabled', false);
        }

    });

    $("#user_zipcode").blur(function(event){
        $('#personal_info_error_zipcode').html("");
        if($("#user_zipcode").val()==""){
            $('#personal_info_error_zipcode').append("<br/>* ZIP Code Can't be empty.");
        }else{
            $('#btn_personal').prop('disabled', false);
        }

    });


    $('#btn_personal').click(function(event) {
        $('#btn_personal').prop('disabled', true);
        var count=0;
        $('#personal_info_error').html("");
        if($("#user_name").val()==""){
            $('#personal_info_error_name').html("<br/>* Required Full Name.");
            count +=1;

        }
        if($("#company_name").val()==""){
            $('#company_name_error').html("<br/>* Required Company Name.");
            count +=1;

        }

        if($("#password").val()==""){
            $('#personal_info_error_password').html("<br/>* Required field Password.");
            count +=1;
        }
        if(($("#password").val()).length<8){
            $('#personal_info_error_password').html("<br/>* Password should be more than 8 characters.");
            count +=1;
        }

        if($("#password_confirmation").val()==""){
            $('#personal_info_error_cpassword').html("<br/>* Required field password confirmation.");
            count +=1;
        }
        if($("#password_confirmation").val()!=$("#password").val()){
            $('#personal_info_error_cpassword').html("<br/>* Password and password confirmation should match.");
            count +=1;
        }


        if(!validEmail($("#email_id").val())){
            $('#personal_info_error_email').html("<br/>* Enter valid Email address.");
            count +=1;

        }
        if (ec==0){
            $('#personal_info_error_email').html("<br/>* Email already exists");
            count +=1;

        }
        if($("#user_add1").val()==""){
            $('#personal_info_error_add1').html("<br/>* Address1 Can't be empty.");
            count +=1;
        }
        if($("#user_state").val()==""){
            $('#personal_info_error_state').html("<br/>* State Can't be empty.");
            count +=1;
        }
        if($("#user_city").val()==""){
            $('#personal_info_error_city').html("<br/>* City Can't be empty.");
            count +=1
        }
        if($("#user_zipcode").val()==""){
            $('#personal_info_error_zipcode').html("<br/>* ZIP Code Can't be empty.");
            count +=1;
        }




        if (count == 0){
            $('#btn_personal').prop('disabled', false);
        }
    });

    $('#btn_product').click(function(event) {

        var product_id=$("input[name='user[product]']:checked").val();


        if (!product_id)
        {
            $('#product_error').html("* Select any Product to continue..... <br/>");
            //$('#btn_product').die( "click" );
            $('#btn_product').prop('disabled', true);
        }else{
            //alert($("input[name='user[product]']:checked").val());
            $('#btn_product').prop('disabled', false);
            $.ajax({
                type: 'GET',
                url: '/packages/show',
                data:{
                    product:product_id
                }

            }).done(function(html_data) {
                //alert(html_data);
                $("#packages").html(html_data);
            });
        }
    });

    $('#btn_package').click(function(event) {
        var payment_type= $("#user_package_type_of_payment").val() || 2;
        if (!$("input[name='user[package][id]']:checked").val())
        {
            $('#package_error').html("* Select any Package  to continue..... <br/>");
            //$('#btn_package').die( "click" );
            $('#btn_package').prop('disabled', true);
        }else{
            //alert($("input[name='user[package]']:checked").val());
            $('#btn_package').prop('disabled', false);
            $.ajax({
                type: 'GET',
                url: '/packages/total_value',
                data:{
                    package_id:$("input[name='user[package][id]']:checked").val(),
                    type_of_payment:payment_type
                }

            }).done(function(text) {
                $("#total_amount").val(text);
                $('#total_amount1').val(text);
            });
        }
    });


function email_validation(){
    $('#personal_info_error_email').html("");
    if(validEmail($("#email_id").val())){
        $.ajax({
            type: 'GET',
            url:'/home/validate_email',
            data:{
                email:$("#email_id").val()
            }
        }).done(function(text){
            if(text==1){
                ec=1;
            }else {
                $('#personal_info_error_email').append("<br/>* Email already exists. ");
                ec=0;
            }
        });

        $('#btn_personal').prop('disabled', false);
    

    }else{
        $('#personal_info_error_email').append(" <br/>* Enter valid Email address. ");
    }

}
$('#btn_terms').click(function(event){


 if ($('#user_terms').is(':checked')) {
   $('#btn_terms').prop('disabled', false);
 }
 else{
   $('#btn_terms').prop('disabled', true);
   $('#term_error').html("* Read and Accept terms and conditions.. <br/>");
 }

});

function validEmail(v) {
    var r = new RegExp("[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?");
    return (v.match(r) == null) ? false : true;
}

function enable_btn_package(){
      
    $('#btn_package').prop('disabled', false);

}
  //menu handling
  