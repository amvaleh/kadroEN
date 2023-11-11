// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery-3.2.1.min
//= require fotorama
//= require gallery/jquery.cubeportfolio.min
//= require cookie
//= require popper.min
//= require bootstrap-4.3.1.min
//= require jquery_ujs



function sendToServer(id, status,url) {
  var result = $.ajax({
    data: {
      id: id,
      status: status,
      cookie: getCookie(id +"-sample")
    },
    dataType: 'json',
    async: false,
    success: function(){
      var cname = id + "-sample" ;
      var cvalue = status;
      setCookie(cname, cvalue);
    },
    type: 'POST',
    url: url,
  })
  console.log(result.responseJSON);
  document.getElementById(id + "-span-like-number").innerHTML = toPersianNum(result.responseJSON.like_number);
  document.getElementById(id + "-span-dislike-number").innerHTML = toPersianNum(result.responseJSON.dislike_number);

}

function btnProcess(cname, status){
  id = cname.replace(/(^\d+)(.+$)/i,'$1');
  if (status == 'like') {
    btn = document.getElementById(cname + "-like");
    btn.classList.remove('btn-default');
    btn.classList.add('btn-primary');
    span = document.getElementById(id + "-span-like-number");
    span.style.color = 'white';
    var i = document.getElementById( "like-" + id);
    i.classList.remove('fa-heart-o');
    i.classList.add('fa-heart');
    i.style.color = 'red';
  } else if (status == 'dislike') {
    btn = document.getElementById(cname + "-dislike");
    btn.classList.remove('btn-default');
    btn.classList.add('btn-primary');
    span = document.getElementById(id + "-span-dislike-number");
    span.style.color = 'white';
    var i = document.getElementById( "dislike-" + id);
    i.style.color = 'red';
  }
}

function checkCookie(cname) {
  var status = getCookie(cname);
  btnProcess(cname,status);
}

$( document ).ready(function() {
    console.log( "ready!" );
    $('.faqs .faq .question').on('click', function () {
        $(this).siblings('.answer').toggleClass('open');
    });

    $(window).scroll(function () {
        if ($(window).scrollTop() > $('body').height() / 5) {
            $('.pineapple-man').show();
            // $('#main_navbar').animate({'position': 'absolute'}, 'slow');
            $('#main_navbar').css('position', 'absolute');
        }
    });

});
