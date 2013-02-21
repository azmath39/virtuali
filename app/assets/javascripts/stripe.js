//stripe

  $(function() {
  
  Stripe.setPublishableKey($('meta[name="stripe-key"]').attr('content'));
  $('#payment-form').submit(function(event) {
     
    // Disable the submit button to prevent repeated clicks
    $('.submit-button').prop('disabled', true);
if (!$("input[name='type_of_transaction']:checked").val()) {
    
       $('.payment-errors').text("choose type of transaction ");
        return false;
    }
    else {

  
    Stripe.createToken({
      number: $('#card-number').val(),
      cvc: $('#card-cvc').val(),
      exp_month: $('#card-expiry-month').val(),
      exp_year: $('#card-expiry-year').val()
    }, stripeResponseHandler);

    // Prevent the form from submitting with the default action
    return false;
    } });

});
function stripeResponseHandler(status, response) {
  if (response.error) {
    // Show the errors on the form
    $('.payment-errors').text("response.error.message");
    $('.submit-button').prop('disabled', false);
  } else {
    var $form = $('#payment-form');
    // token contains id, last4, and card type
    var token = response.id;
    // Insert the token into the form so it gets submitted to the server
    $form.append($('<input type="hidden" name="stripeToken" />').val(token));
    // and submit
    $form.get(0).submit();
  }
}