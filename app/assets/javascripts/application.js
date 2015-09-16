//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require foundation
//= require foundation-datetimepicker
//= require rails.validations
//= require jquery.formance.min

$(document).ready(function(){ 
  $(document).foundation();
  
  $('.datetimepicker').fdatetimepicker({
    minuteStep: 30,
    autoclose: true,
    linkField: true,
    showMeridian: true,
    daysOfWeekDisabled: [0,6]
  });

  $(".brokerAuthBtn").prop("disabled", true); // disable the submit button
  $(".brokerNumber").formance("format_phone_number") // setup the formatter
                         .on( 'keyup change blur', function (event) { // setup the event listeners to validate the field whenever the user takes an action
                           if ( $('.brokerNumber').formance('validate_phone_number'))
                             $("button").prop("disabled", false); // enable the submit button if valid phone number
                           else
                             $("button").prop("disabled", true); // disable the submit button if invalid phone number
                         });

});

$(window).bind("load", function () {
    var footer = $("#footer");
    var pos = footer.position();
    var height = $(window).height();
    height = height - pos.top;
    height = height - footer.height();
    if (height > 0) {
        footer.css({
            'margin-top': height + 'px'
        });
    }
    $(".uploadcare-widget-button.uploadcare-widget-button-open").addClass("button cust-btn");
});

var removeAmTimes = function(){
    $('.hour_am').each(function(){
        if($(this).html() < 7 || $(this).html() > 11){
            $(this).remove()
        }
    });
};

var removePmTimes = function(){
    $('.hour_pm').each(function(){
        if($(this).html() > 7 && $(this).html() != 12){
            $(this).remove()
        }
    });
}
