<?php 
$final_atim_structure = $atim_structure;
$final_options = array(
	'type' => 'index',
	'settings' => array(
		'pagination' => false,
		'form_inputs' => false,
		'header' => array(
			'title' => $title,
			'description' => __('select the identifiers you wish to delete permanently')
		)
	), 'links' => array(
		'bottom' => array(
			'list' => '/Administrate/MiscIdentifiers/index/'
		), 'top' => 'javascript:deleteConfirm();', //'/Administrate/MiscIdentifiers/manage/'.$atim_menu_variables['MiscIdentifierControl.id'],
		'checklist' => array(
			'MiscIdentifier.selected_id][' => '%%MiscIdentifier.id%%'
		)
	)
);

$hook_link = $this->Structures->hook();
if( $hook_link ) {
	require($hook_link);
}
$this->Structures->build( $final_atim_structure, $final_options );

?>
<script>
function deleteConfirm(participant_id, ctrl_id){
	if($(":checked").length > 0){
		var submitLink = root_url + 'administrate/MiscIdentifiers/manage/<?php  echo $atim_menu_variables['MiscIdentifierControl.id']; ?>';
		if($("#deleteConfirmPopup").length == 0){
			buildConfirmDialog('deleteConfirmPopup', STR_DELETE_CONFIRM, new Array({label : STR_YES, action: function(){ $("form").attr("action", submitLink).submit(); }, icon: "detail"}, {label : STR_NO, action: function(){ $("#deleteConfirmPopup").popup('close'); }, icon: "delete ignore"}));
		}
		$("#deleteConfirmPopup").popup();
	}else{
		var errorYouNeedToSelectAtLeastOneItem = "<?php echo __("you need to select at least one item"); ?>";
		if($("#atLeastOnePopup").length == 0){
			buildConfirmDialog('atLeastOnePopup', errorYouNeedToSelectAtLeastOneItem, new Array({label : "<?php echo __('ok') ?>", action: function(){ $("#atLeastOnePopup").popup('close'); }, icon: "detail"}));
		}
		$("#atLeastOnePopup").popup();
	}
}
</script>