function HandleError(identity1, error_keys, complete_errors) {
	jQuery("#new_" + identity1 + " div").removeClass("has-error");
    jQuery('.help-block.has-error').remove();


	for (var i=0; i < error_keys.length; i++) {
		var res = String(error_keys[i]);
    if (res.indexOf(".") != -1) {
        res = res.replace(".", "_attributes_");
    }

	var id_error_key = jQuery('#' + identity1 + '_' + res);
    console.log(id_error_key);
    id_error_key.parent('div').addClass('has-error');
    id_error_key.parent('div').append("<span class='help-block has-error'>" + complete_errors[i] +"</span>");
	}
}