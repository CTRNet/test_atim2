<?php 

	// Build Link
	$add_identifiers_link = array();
	$link_availability = AppController::checkLinkPermission('/clinicalannotation/misc_identifiers/add/');
	foreach($identifier_controls_list as $option){
		$add_identifiers_link[__($option['MiscIdentifierControl']['misc_identifier_name'], true)] = 
			isset($option['reusable']) && $link_availability ? 
			'javascript:miscIdPopup('.$atim_menu_variables['Participant.id'].' ,'.$option['MiscIdentifierControl']['id'].');' : 
			'/clinicalannotation/misc_identifiers/add/'.$atim_menu_variables['Participant.id'].'/'.$option['MiscIdentifierControl']['id'].'/';
	}
	ksort($add_identifiers_link);

	$bottom = empty($add_identifiers_link) ? array(__("no identifier available", true) => "bad link") : array('add'=>$add_identifiers_link); 
		
	$structure_links = array(
		'index' => array('detail'=>'/clinicalannotation/misc_identifiers/detail/'.$atim_menu_variables['Participant.id'].'/%%MiscIdentifier.id%%/'),
		'bottom' => $bottom
	);
	
	$structure_override = array();

	// Set form structure and option
	$final_atim_structure = $atim_structure; 
	$final_options = array('type'=>'index','links'=>$structure_links, 'override' => $structure_override);
	
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if( $hook_link ) { 
		require($hook_link); 
	}
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );
	
?>
<script>
	function miscIdPopup(participant_id, ctrl_id){
		buildConfirmDialog('miscIdPopup', "<?php __('misc_identifier_reuse'); ?>", new Array(
			{label : "<?php __('new'); ?>", action: function(){document.location = root_url + "clinicalannotation/misc_identifiers/add/" + participant_id + "/" + ctrl_id + "/";}, icon: "add"}, 
			{label : "<?php __('reuse'); ?>", action: function(){document.location = root_url + "clinicalannotation/misc_identifiers/reuse/" + participant_id + "/" + ctrl_id + "/";}, icon: "redo"})
		);
		$("#miscIdPopup").popup();
	}
</script>