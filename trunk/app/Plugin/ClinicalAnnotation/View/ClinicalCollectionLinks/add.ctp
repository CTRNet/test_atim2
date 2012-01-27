<?php
	//Collection-------------
	$structure_links = array(
		'top'=> '/ClinicalAnnotation/ClinicalCollectionLinks/add/'.$atim_menu_variables['Participant.id'].'/',
		'radiolist' => array(
				'Collection.id'=>'%%Collection.id%%'
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
			'start' => '<input type="radio" id="collection_new" name="data[Collection][id]" value="" data-json="'.htmlentities('{"id" : "'.$collection_id.'"}').'"/>'.__('new collection').'<div id="collection_frame"></div>
			<div class="loading">'.__('loading').'</div>',
			'end'	=> '<span class="button"><a id="collection_search" href="#">'.__('search').'</a></span>'
		)
	);

	// CUSTOM CODE
	$hook_link = $this->Structures->hook('collection_detail');
	if( $hook_link ) { 
		require($hook_link); 
	}
		
	// BUILD FORM
	$this->Structures->build( $empty_structure, $final_options );
	
	
	//Consent----------------
	$structure_links = array(
		'radiolist' => array(
				'Collection.consent_master_id'=>'%%ConsentMaster.id%%'
			),
	);
	$structure_settings['header'] = __('consent');
	//consent
	$final_atim_structure = $atim_structure_consent_detail; 
	$final_options = array(
		'type'		=> 'index', 
		'data'		=> $consent_data, 
		'settings'	=> $structure_settings, 
		'links'		=> $structure_links,
		'extras'	=> array('end' => '<input type="radio" name="data[Collection][consent_master_id]" '.($consent_found ? '' : 'checked="checked"').'" value=""/>'.__('n/a'))
	);

	// CUSTOM CODE
	$hook_link = $this->Structures->hook('consent_detail');
	if( $hook_link ) { 
		require($hook_link); 
	}
		
	// BUILD FORM
	$this->Structures->build($final_atim_structure, $final_options );

	
	
	
	//Dx---------------------
	$structure_links = array(
		'top'=> '/ClinicalAnnotation/ClinicalCollectionLinks/add/'.$atim_menu_variables['Participant.id'].'/',
		'radiolist' => array(
				'Collection.diagnosis_master_id'=>'%%DiagnosisMaster.id'.'%%'
		),'bottom'=>array(
			'cancel'=>'/ClinicalAnnotation/ClinicalCollectionLinks/listall/'.$atim_menu_variables['Participant.id'].'/'
		),'tree' => array(
			'DiagnosisMaster' => array(
					'radiolist' => array('Collection.diagnosis_master_id'=>'%%DiagnosisMaster.id'.'%%')
			)
		) 
	);
	//consent
	$final_atim_structure = array('DiagnosisMaster' => $atim_structure_diagnosis_detail); 
	$final_options = array(
		'type'		=> 'tree', 
		'data'		=> $diagnosis_data, 
		'settings'	=> array(
			'form_inputs'	=> false,
			'form_bottom'	=> true, 
			'form_top'		=> true, 
			'actions'		=> true, 
			'header'		=> __('diagnosis'),
			'tree'			=> array(
				'DiagnosisMaster' => 'DiagnosisMaster'
			)
		), 'links'	=> $structure_links,
		'extras'	=> array('end' => '<input type="radio" name="data[Collection][diagnosis_master_id]"  '.($found_dx ? '' : 'checked="checked"').' value=""/>'.__('n/a'))
	);

	// CUSTOM CODE
	$hook_link = $this->Structures->hook('diagnosis_detail');
	if( $hook_link ) { 
		require($hook_link); 
	}
		
	// BUILD FORM
	$this->Structures->build( $final_atim_structure, $final_options );
?>

<div id="popup" class="std_popup question">
	
</div>

<script>
var ccl = true;
var treeView = true;
</script>