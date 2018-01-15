<?php
foreach ($identifierControlsList as $newOption) {
    if (preg_match('/bank no lab$/', $newOption['MiscIdentifierControl']['autoincrement_name'])) {
        $finalOptions['links']['bottom']['add identifier'][$newOption['MiscIdentifierControl']['misc_identifier_name']] = isset($newOption['reusable']) && $linkAvailability ? 'javascript:noLaboReuseQcNdPopup(' . $atimMenuVariables['Participant.id'] . ' ,' . $newOption['MiscIdentifierControl']['id'] . ', "' . $newOption['MiscIdentifierControl']['misc_identifier_name'] . '");' : 'javascript:noLaboWarningQcNdPopup(' . $atimMenuVariables['Participant.id'] . ' ,' . $newOption['MiscIdentifierControl']['id'] . ', "' . $newOption['MiscIdentifierControl']['misc_identifier_name'] . '");';
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