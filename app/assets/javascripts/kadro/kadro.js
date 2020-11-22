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
//= require jquery
//= require kadro/bootstrap.min
//= require kadro/jquery.sticky.min
//= require kadro/general
//= require kadro/foobox.free.min
//= require kadro/lightgallery.min
//= require gallery/jquery.cubeportfolio.min
//= require owl.carousel.min
//= require underscore
//= require gmaps/google


/* When the user clicks on the button,
toggle between hiding and showing the dropdown content */
function myFunction() {
  document.getElementById("myDropdown").classList.toggle("show");
}

function filterFunction() {
  var input, filter, ul, li, a, i;
  input = document.getElementById("myInput");
  filter = input.value.toUpperCase();
  div = document.getElementById("myDropdown");
  a = div.getElementsByTagName("a");
  for (i = 0; i < a.length; i++) {
    txtValue = a[i].textContent || a[i].innerText;
    if (txtValue.toUpperCase().indexOf(filter) > -1) {
      a[i].style.display = "";
    } else {
      a[i].style.display = "none";
    }
  }
}

function setCookie(cname, cvalue) {
  var d = new Date();
  d.setTime(d.getTime() + (365*24*60*60*1000));
  var expires = "expires="+d.toUTCString();
  document.cookie = cname + "=" + cvalue + "; " + expires + ";path=/";
}

function getCookie(cname) {
  var cookie= document.cookie.split(';');
  for(var i=0; i < cookie.length; i++){
    var cke = cookie[i].trim();
    if(cke.indexOf(cname) == 0){
      cke = cke.replace(cname + "=", '');
      return cke
      break;
    }
  }
}


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

  function likephoto(id,status,url,photo_id) {
    if (getCookie(id +"-sample") != status) {
      sendToServer(id,status,url);
      if (status == 'like') {
        span = document.getElementById(id + "-span-like-number");
        span.style.color = 'black';
        span2 = document.getElementById(id + "-span-dislike-number");
        span2.style.color = '#767575';
        var i = document.getElementById( "like-" + id);
        var ii = document.getElementById( "dislike-" + id);
        var heart = document.getElementById( "heart-" + photo_id);
        i.classList.remove('fa-heart-o');
        i.classList.add('fa-heart');
        i.style.color = 'red';
        ii.style.color = '#afaeae';
        ii.classList.remove('gallery-frame-heart');
        i.classList.add('gallery-frame-heart');
        heart.removeAttribute("hidden");
      } else if (status == 'dislike') {
        span = document.getElementById(id + "-span-dislike-number");
        span.style.color = 'black';
        span2 = document.getElementById(id + "-span-like-number");
        span2.style.color = '#767575';
        var i = document.getElementById( "dislike-" + id);
        var ii = document.getElementById( "like-" + id);
        var heart = document.getElementById( "heart-" + photo_id);
        i.style.color = 'red';
        i.classList.add('gallery-frame-heart');
        ii.style.color = '#afaeae';
        ii.classList.remove('gallery-frame-heart');
        heart.hidden = true;
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
    span = document.getElementById(id + "-span-like-number");
    span.style.color = 'black';
    span = document.getElementById(id + "-span-dislike-number");
    span.style.color = 'black';
    var i = document.getElementById( "like-" + id);
    i.classList.remove('fa-heart-o');
    i.classList.add('fa-heart');
    i.style.color = 'red';
  } else if (status == 'dislike') {
    btn = document.getElementById(cname + "-dislike");
    span = document.getElementById(id + "-span-dislike-number");
    span.style.color = 'black';
    span = document.getElementById(id + "-span-like-number");
    span.style.color = 'black';
    var i = document.getElementById( "dislike-" + id);
    i.style.color = 'red';
  }
}

function checkCookie(cname) {
  var status = getCookie(cname);
  btnProcess(cname,status);
}


function create_selectable(photo_id, status, url, shoot_type_id){
  $.ajax({
    data: {
      photo_id: photo_id,
      status: status,
      shoot_type_id: shoot_type_id
    },
    dataType: 'script',
    async: false,
    type: 'POST',
    url: url,
  })
}
