jQuery(function($) {
  $('#payment-form').submit(function(event) {
    var $form = $(this);
    $form.find('button').prop('disabled', true);
    Stripe.card.createToken($form, stripeResponseHandler);
    return false;
  });
});

var stripeResponseHandler = function(status, response) {
  var $form = $('#payment-form');

  if (response.error) {
    $form.find('.payment-errors').text(response.error.message);
    $form.find('button').prop('disabled', false);
  } else {
    var token = response.id;
    $form.append($('<input type="hidden" name="stripeToken" />').val(token));
    $form.get(0).submit();
  }
};








// jQuery(function($) {
//   $('#payment-form').submit(function(event) {
//     var $form = $(this);
//     $form.find('.payment_submit').prop('disabled', true);
// alert("hello");
//     Stripe.card.createToken({
//         number: $('.card-number').val(),
//         cvc: $('.card-cvc').val(),
//         exp_month: $('.card-expiry-month').val(),
//         exp_year: $('.card-expiry-year').val()
//     }, stripeResponseHandler);
// return false;
// });

// var stripeResponseHandler = function(status, response) {
//     var $form = $('#payment-form');

//     if (response.error) {
//         $form.find('.payment-errors').text(response.error.message);
//         $form.find('.payment-submit').prop('disabled', false);
//     } else {
//         var token = response.id;
//         $form.append($('<input type="hidden" name="stripeToken" />').val(token));
//         $form.get(0).submit();
//     }
// };
// });
