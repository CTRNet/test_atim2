<?php 

	// Build Link
	$add_identifiers_link = array();
	$link_availability = AppController::checkLinkPermission('/ClinicalAnnotation/MiscIdentifiers/add/');
	foreach($identifier_controls_list as $option){
		$add_identifiers_link[__($option['MiscIdentifierControl']['misc_identifier_name'])] = 
			isset($option['reusable']) && $link_availability ? 
			'javascript:miscIdPopup('.$atim_menu_variables['Participant.id'].' ,'.$option['MiscIdentifierControl']['id'].');' : 
			'/ClinicalAnnotation/MiscIdentifiers/add/'.$atim_menu_variables['Participant.id'].'/'.$option['MiscIdentifierControl']['id'].'/';
	}
	ksort($add_identifiers_link);

	$bottom = empty($add_identifiers_link) ? array(__("no identifier available") => "bad link") : array('add'=>$add_identifiers_link); 
		
	$structure_links = array(
		'index' => array('detail'=>'/ClinicalAnnotation/MiscIdentifiers/detail/'.$atim_menu_variables['Participant.id'].'/%%MiscIdentifier.id%%/'),
		'bottom' => $bottom
	);
	
	$structure_override = array();

	// Set form structure and option
	$final_atim_structure = $atim_structure; 
	$final_options = array('type'=>'index','links'=>$structure_links, 'override' => $structure_override);
	
	// CUSTOM CODE
	$hook_link = $this->Structures->hook();
	if( $hook_link ) { 
		require($hook_link); 
	}
		
	// BUILD FORM
	$this->Structures->build( $final_atim_structure, $final_options );
	
?>
<script>
	function miscIdPopup(participant_id, ctrl_id){
		buildConfirmDialog('miscIdPopup', "<?php echo __('misc_identifier_reuse'); ?>", new Array(
			{label : "<?php echo __('new'); ?>", action: function(){document.location = root_url + "ClinicalAnnotation/MiscIdentifiers/add/" + participant_id + "/" + ctrl_id + "/";}, icon: "add"}, 
			{label : "<?php echo __('reuse'); ?>", action: function(){document.location = root_url + "ClinicalAnnotation/MiscIdentifiers/reuse/" + participant_id + "/" + ctrl_id + "/";}, icon: "redo"})
		);
		$("#miscIdPopup").popup();
	}
</script>