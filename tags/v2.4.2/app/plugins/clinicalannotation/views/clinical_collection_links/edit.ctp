<?php 
	$structure_links = array(
		'top'=> '/clinicalannotation/clinical_collection_links/edit/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['ClinicalCollectionLink.id'],
		'radiolist' => array(
				'ClinicalCollectionLink.collection_id'=>'%%Collection.id%%'
			),
	);
	$structure_settings = array(
		'form_bottom'=>false, 
		'form_inputs'=>false,
		'actions'=>false,
		'pagination'=>false,
		'header' => __('collection', true)
	);
	
	$structure_override = array();
	
		
	// ************** 1- COLLECTION **************
	
	
	$final_atim_structure = $atim_structure_collection_detail; 
	$final_options = array('type'=>'index', 'data'=>$collection_data, 'settings'=>$structure_settings, 'links'=>$structure_links, 'override' => $structure_override);

	// CUSTOM CODE
	$hook_link = $structures->hook('collection_detail');
	if( $hook_link ) { 
		require($hook_link); 
	}
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options ); 
	
	
	// ************** 2- CONSENT **************
	$structure_links = array(
		'radiolist' => array(
				'ClinicalCollectionLink.consent_master_id'=>'%%ConsentMaster.id%%'
			),
	);
	$structure_settings['header'] = __('consent', true);
	$structure_settings['form_top'] = false;
	$final_atim_structure = $atim_structure_consent_detail; 
	$final_options = array(
		'type'		=> 'index', 
		'data'		=> $consent_data, 
		'settings'	=> $structure_settings, 
		'links'		=> $structure_links,
		'extras'	=> array('end' => '<input type="radio" name="data[ClinicalCollectionLink][consent_master_id]" '.(!$found_consent ? 'checked="checked"' : '').' value=""/>'.__('n/a', true))
	);

	// CUSTOM CODE
	$hook_link = $structures->hook('consent_detail');
	if( $hook_link ) { 
		require($hook_link); 
	}
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );

	
	
	// ************** 3- DIAGNOSIS **************
	
	$structure_links = array(
		'radiolist' => array(
				'ClinicalCollectionLink.diagnosis_master_id'=>'%%DiagnosisMaster.id%%'
		),'top'=> '/clinicalannotation/clinical_collection_links/details/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['ClinicalCollectionLink.id'],
		'bottom'=>array(
			'cancel'=>'/clinicalannotation/clinical_collection_links/listall/'.$atim_menu_variables['Participant.id'].'/'
		), 'tree' => array(
			'DiagnosisMaster' => array(
				'radiolist' => array('ClinicalCollectionLink.diagnosis_master_id'=>'%%DiagnosisMaster.id'.'%%')
			)
		)
	);
	$structure_settings['header'] = __('diagnosis', true);
	$structure_settings['form_top'] = false;
	$structure_settings['form_bottom'] = true;
	$structure_settings['actions'] = true;
	$structure_settings['tree']	= array('DiagnosisMaster' => 'DiagnosisMaster');
	$final_atim_structure = array('DiagnosisMaster' => $atim_structure_diagnosis_detail); 
	$final_options = array(
		'type'		=> 'tree', 
		'data'		=> $diagnosis_data, 
		'settings'	=> $structure_settings, 
		'links'		=> $structure_links,
		'extras'	=> array('end' => '<input type="radio" name="data[ClinicalCollectionLink][diagnosis_master_id]" '.(!$found_dx ? 'checked="checked"' : '').' value=""/>'.__('n/a', true))
	);
	
	// CUSTOM CODE
	$hook_link = $structures->hook('diagnosis_detail');
	if( $hook_link ) { 
		require($hook_link); 
	}	
	
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );
?>
<script>
var treeView = true;
</script>