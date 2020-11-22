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


function toPersianNum( num, dontTrim ) {
  var i = 0,
      dontTrim = dontTrim || false,
      num = dontTrim ? num.toString() : num.toString().trim(),
      len = num.length,
      res = '',
      pos,
      persianNumbers = typeof persianNumber == 'undefined' ?
          ['۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹'] :
          persianNumbers;
  for (; i < len; i++)
      if (( pos = persianNumbers[num.charAt(i)] ))
          res += pos;
      else
          res += num.charAt(i);
  return res;
}

function likephoto(id,status,url){
  if (getCookie(id +"-sample") != status){
    sendToServer(id,status,url);
    if (status == 'like') {
      document.getElementById(id + "-sample" + "-dis" + status).classList.remove('btn-primary');
      document.getElementById(id + "-sample" + "-" + status).classList.remove('btn-default');
      document.getElementById(id + "-sample" + "-" + status).classList.add('btn-primary');
      span = document.getElementById(id + "-span-like-number")
      span.style.color = 'white'
      span2 = document.getElementById(id + "-span-dislike-number")
      span2.style.color = '#767575'
      var i = document.getElementById( "like-" + id);
      var ii = document.getElementById( "dislike-" + id);
      var heart = document.getElementById( "heart-" + id);
      i.classList.remove('fa-heart-o');
      i.classList.add('fa-heart');
      i.style.color = 'red'
      ii.style.color = '#afaeae'
      ii.classList.remove('gallery-frame-heart');
      i.classList.add('gallery-frame-heart');
      heart.removeAttribute("hidden")
    } else if (status == 'dislike') {
      document.getElementById(id + "-sample-like").classList.remove('btn-primary');
      document.getElementById(id + "-sample" + "-" + status).classList.remove('btn-default');
      document.getElementById(id + "-sample" + "-" + status).classList.add('btn-primary');
      span = document.getElementById(id + "-span-dislike-number")
      span.style.color = 'white'
      span2 = document.getElementById(id + "-span-like-number")
      span2.style.color = '#767575'
      var i = document.getElementById( "dislike-" + id);
      var ii = document.getElementById( "like-" + id);
      var heart = document.getElementById( "heart-" + id);
      i.style.color = 'red'
      i.classList.add('gallery-frame-heart');
      ii.style.color = '#afaeae'
      ii.classList.remove('gallery-frame-heart');
      heart.hidden = true
    }
  }
}



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
