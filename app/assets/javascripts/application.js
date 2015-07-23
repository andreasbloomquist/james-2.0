//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require foundation
//= require foundation-datetimepicker


$(function(){ 
  $(document).foundation();
  $('.datetimepicker').fdatetimepicker()

  $('.radio').on('click', function(){
    var address = $(this).data('address');
    var subMarket = $(this).data('submarket');
    var type = $(this).data('propertytype');
    var sqFt = $(this).data('sq_ft');
    var price = $(this).data('price');
    var avail = $(this).data('available').substring(0,10);
    var min = $(this).data('min');
    var max = $(this).data('max');
    var desc = $(this).data('description');
    var img = $(this).data('image')

    $('#property_address').val(address);
    $('#property_sub_market').val(subMarket);
    $('#property_property_type').val(type);
    $('#property_sq_ft').val(sqFt);
    $('#propety_rent_price').val(price);
    $('#property_available').val(avail);
    $('#property_min').val(min);
    $('#property_max').val(max);
    $('#property_description').val(desc);
    $('#property_image_url').val(img);
  })
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
