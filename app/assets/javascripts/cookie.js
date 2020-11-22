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
