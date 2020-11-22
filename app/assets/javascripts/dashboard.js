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
//= require jquery-ui.min
//= require jquery_ujs
//= require popper.min
//= require bootstrap-4.3.1.min
//= require Chart.min
//= require jquery.slimscroll.min
//= require fastclick
//= require raphael.min
//= require datatables.min
//= require dashboard/template
//= require dashboard/demo
//= require kadro/sweetalert.min
//= require kadro/ui-sweetalert.min
//= require gallery/jquery.cubeportfolio.min
//= require gmaps/google
//= require jquery.fileDownload
//= require kadro/jquery.sticky.min



$.widget.bridge('uibutton', $.ui.button);



$(document).ready(function() {
    // executes when HTML-Document is loaded and DOM is ready
    console.log("document is ready");


    $( ".card" ).hover(
        function() {
            $(this).addClass('shadow-lg');
        }, function() {
            $(this).removeClass('shadow-lg');
        }
    );

// document ready
});

function cartItemForm() {
    jQuery('.loading-spinner').show();
}


function delete_alert() {
    jQuery.rails.allowAction = function(link) {
        if (!link.attr('data-confirm')) {
            return true;
        }
        jQuery.rails.showConfirmDialog(link);
        return false;
    };

    jQuery.rails.confirmed = function(link) {
        link.removeAttr('data-confirm');
        return link.trigger('click.rails');
    };

    jQuery.rails.showConfirmDialog = function(link) {
        var html, message;
        message = link.attr('data-confirm');
        swal({
            title: 'تایید حذف',
            text: message,
            type: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#DD6B55',
            confirmButtonText: 'بله',
            cancelButtonText: 'خیر',
            closeOnConfirm: false,
            closeOnCancel: false
        }, (function(_this) {
            return function(confirmed) {
                if (confirmed) {
                    console.log(link);
                    swal.close();
                    return jQuery.rails.confirmed(link);
                } else {
                    swal.close();
                    jQuery('.loading-spinner').hide();
                }
            };
        })(this));
    };
}

function persian_number() {
    persian={0:'۰',1:'۱',2:'۲',3:'۳',4:'۴',5:'۵',6:'۶',7:'۷',8:'۸',9:'۹'};
    function traverse(el){
        if(el.nodeType==3){
            var list=el.data.match(/[0-9]/g);
            if(list!=null && list.length!=0){
                for(var i=0;i<list.length;i++)
                    el.data=el.data.replace(list[i],persian[list[i]]);
            }
        }
        for(var i=0;i<el.childNodes.length;i++){
            traverse(el.childNodes[i]);
        }
    }
    traverse(document.body);
}

var ready;
ready = function () {
    setTimeout(function () {
        delete_alert();
        persian_number();
    }, 500);
};
jQuery(document).ready(ready);
