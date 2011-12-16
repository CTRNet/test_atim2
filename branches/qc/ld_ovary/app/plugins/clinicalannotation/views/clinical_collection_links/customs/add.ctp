<?php
	//Collection-------------
	$structure_links = array(
		'top'=> '/clinicalannotation/clinical_collection_links/add/'.$atim_menu_variables['Participant.id'].'/',
		'radiolist' => array(
				'ClinicalCollectionLink.collection_id'=>'%%Collection.id%%'
			),
	);
	$structure_settings = array(
		'form_bottom'	=> false, 
		'form_inputs'	=> false,
		'actions'		=> false,
		'pagination'	=> false,
		'header'		=> __('collection', null)
	);
	$structure_override = array();

	$final_options = array(
		'settings' => $structure_settings, 
		'links' => $structure_links, 
		'override' => $structure_override, 
		'extras' => array(
			'start' => '<input type="radio" id="collection_new" name="data[ClinicalCollectionLink][collection_id]" checked="checked" value=""/>'.__('new collection', true).'<div id="collection_frame"></div>
			<div class="loading">'.__('loading', true).'</div>',
			'end'	=> '<span class="button"><a id="collection_search" href="#">'.__('search', true).'</a></span>'
		)
	);

	// CUSTOM CODE
	$hook_link = $structures->hook('collection_detail');
	if( $hook_link ) { 
		require($hook_link); 
	}
		
	// BUILD FORM
	$structures->build( $empty_structure, $final_options );
	
	
	//Consent----------------
	$structure_links = array(
		'top'=> '/clinicalannotation/clinical_collection_links/add/'.$atim_menu_variables['Participant.id'].'/',
		'radiolist' => array(
				'ClinicalCollectionLink.consent_master_id'=>'%%ConsentMaster.id%%'
			),'bottom'=>array(
			'cancel'=>'/clinicalannotation/clinical_collection_links/listall/'.$atim_menu_variables['Participant.id'].'/'
		)
	);
	$structure_settings['header'] = __('consent', true);
	$structure_settings['form_bottom'] =	true;
	$structure_settings['form_top'] =	true;
	$structure_settings['actions'] =	true;

	//consent
	$final_atim_structure = $atim_structure_consent_detail; 
	$final_options = array(
		'type'		=> 'index', 
		'data'		=> $consent_data, 
		'settings'	=> $structure_settings, 
		'links'		=> $structure_links,
		'extras'	=> array('end' => '<input type="radio" name="data[ClinicalCollectionLink][consent_master_id]" checked="checked" value=""/>'.__('n/a', true))
	);

	// CUSTOM CODE
	$hook_link = $structures->hook('consent_detail');
	if( $hook_link ) { 
		require($hook_link); 
	}
		
	// BUILD FORM
	$structures->build($final_atim_structure, $final_options );

?>

<div id="popup" class="std_popup question">
	
</div>

<script>
var ccl = true;
</script>