<?php

foreach($identifier_controls_list as $new_option) {
	if(preg_match('/bank no lab$/', $new_option['MiscIdentifierControl']['autoincrement_name'])){
		$final_options['links']['bottom']['add identifier'][$new_option['MiscIdentifierControl']['misc_identifier_name']] =
		isset($new_option['reusable']) && $link_availability ?
		'javascript:noLaboReuseQcNdPopup('.$atim_menu_variables['Participant.id'].' ,'.$new_option['MiscIdentifierControl']['id'].', "'.$new_option['MiscIdentifierControl']['misc_identifier_name'].'");' :
		'javascript:noLaboWarningQcNdPopup('.$atim_menu_variables['Participant.id'].' ,'.$new_option['MiscIdentifierControl']['id'].', "'.$new_option['MiscIdentifierControl']['misc_identifier_name'].'");';
	}
}

?>
<script>

var QC_ND_STR_NO_LABO_CREATION = "<?php echo __('creation of a new no labo'); ?>";
var QC_ND_STR_YES = "<?php echo __('yes'); ?>";
var QC_ND_STR_NO = "<?php echo __('no'); ?>";

function noLaboReuseQcNdPopup(participant_id, ctrl_id, no_labo_name){
	buildConfirmDialog('noLaboReuseQcNdPopup', no_labo_name + ' : ' + STR_MISC_IDENTIFIER_REUSE, new Array(
		{label : STR_NEW, action: function(){document.location = root_url + "ClinicalAnnotation/MiscIdentifiers/add/" + participant_id + "/" + ctrl_id + "/"; return false;}, icon: "add"}, 
		{label : STR_REUSE, action: function(){document.location = root_url + "ClinicalAnnotation/MiscIdentifiers/reuse/" + participant_id + "/" + ctrl_id + "/"; return false;}, icon: "redo"})
	);
	$("#noLaboReuseQcNdPopup").popup();
}

function noLaboWarningQcNdPopup(participant_id, ctrl_id, no_labo_name){
	var no_action = function(){
		$("#noLaboWarningQcNdPopup").popup('close');
		return false;
	}; 
	buildConfirmDialog('noLaboWarningQcNdPopup', QC_ND_STR_NO_LABO_CREATION + ' ' + no_labo_name, new Array(
		{label : QC_ND_STR_YES, action: function(){document.location = root_url + "ClinicalAnnotation/MiscIdentifiers/add/" + participant_id + "/" + ctrl_id + "/"; return false;}, icon: "add"}, 
		{label : QC_ND_STR_NO, action: no_action, icon: "delete noPrompt"})
	);
	$("#noLaboWarningQcNdPopup").popup();
}

</script>

