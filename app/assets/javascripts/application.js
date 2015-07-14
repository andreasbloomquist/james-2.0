//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require foundation
//= require angular/angular 

$(function(){ 
  $(document).foundation(); 
    $('input').onFocus=window.scrollTo(0, 0);
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
});
