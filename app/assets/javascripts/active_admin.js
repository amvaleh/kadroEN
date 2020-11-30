//= require kadro/jquery
//= require arctic_admin/base
//= require activeadmin_addons/all
//= require underscore-min
//= require gmaps/google
//= require bootstrap.min
//= require bootstrap-multiselect

//= require persian-date.min
//= require persian-datepicker.min

$(document).ready(function() {
    if (((document.URL) == 'https://app.kadro.me/admin/crm') || ((document.URL) == 'http://app.localhost:3000/admin/crm')) {
     $('body.active_admin.logged_in').css('display','flex');
     $('body.active_admin.logged_in').css('padding-left','250px')
    }
});