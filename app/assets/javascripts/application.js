//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require foundation
//= require foundation-datetimepicker
//= require rails.validations

$(function(){ 
  $(document).foundation();
  $('.datetimepicker').fdatetimepicker()
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
