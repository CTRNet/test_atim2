<?php


//Consent----------------
$structure_links['radiolist'] = array('Collection.consent_master_id'=>'%%ConsentMaster.id%%');
$structure_settings['header'] = __('consent');
$structure_settings['form_top'] = false;
//consent
$final_atim_structure = $atim_structure_consent_detail;
$final_options = array(
		'type'		=> 'index',
		'data'		=> $consent_data,
		'settings'	=> $structure_settings,
		'links'		=> $structure_links,
		'extras'	=> array('end' => '<input type="radio" name="data[Collection][consent_master_id]" '.($consent_found ? '' : 'checked="checked"').'" value=""/>'.__('n/a'))
);

$display_next_sub_form = true;

// CUSTOM CODE
$hook_link = $this->Structures->hook('consent_detail');
if( $hook_link ) {
	require($hook_link);
}

// BUILD FORM
if($display_next_sub_form) $this->Structures->build($final_atim_structure, $final_options );


//Dx---------------------
$structure_links['radiolist'] = array('Collection.diagnosis_master_id'=>'%%DiagnosisMaster.id'.'%%');
$structure_links['tree'] = array(
		'DiagnosisMaster' => array(
				'radiolist' => array('Collection.diagnosis_master_id'=>'%%DiagnosisMaster.id'.'%%')
		)
);

$structure_settings['header'] = __('diagnosis');
$structure_settings['tree'] = array('DiagnosisMaster' => 'DiagnosisMaster');

$final_atim_structure = array('DiagnosisMaster' => $atim_structure_diagnosis_detail);
$final_options = array(
		'type'		=> 'tree',
		'data'		=> $diagnosis_data,
		'settings'	=> $structure_settings,
		'links'	=> $structure_links,
		'extras'	=> array('end' => '<input type="radio" name="data[Collection][diagnosis_master_id]"  '.($found_dx ? '' : 'checked="checked"').' value=""/>'.__('n/a'))
);

$display_next_sub_form = true;

// CUSTOM CODE
$hook_link = $this->Structures->hook('diagnosis_detail');
if( $hook_link ) {
	require($hook_link);
}

// BUILD FORM
if($display_next_sub_form) $this->Structures->build( $final_atim_structure, $final_options );


//tx----------------
$structure_links['radiolist'] = array('Collection.treatment_master_id' => '%%TreatmentMaster.id%%');
unset($structure_links['tree']);

$structure_settings['header'] = __('treatments');
unset($structure_settings['tree']);

$final_atim_structure = $atim_structure_tx;
$final_options = array(
		'type'		=> 'index',
		'data'		=> $tx_data,
		'settings'	=> $structure_settings,
		'links'		=> $structure_links,
		'extras'	=> array('end' => '<input type="radio" name="data[Collection][treatment_master_id]"  '.($found_tx ? '' : 'checked="checked"').' value=""/>'.__('n/a'))
);

$display_next_sub_form = true;

// CUSTOM CODE
$hook_link = $this->Structures->hook('event_detail');
if( $hook_link ) {
	require($hook_link);
}

// BUILD FORM
if($display_next_sub_form) $this->Structures->build( $final_atim_structure, $final_options );



//event----------------
$structure_links['radiolist'] = array('Collection.event_master_id' => '%%EventMaster.id%%');

$structure_settings['header'] = __('annotation');
$structure_settings['form_bottom'] = true;
$structure_settings['actions'] = true;

$final_atim_structure = $atim_structure_event;
$final_options = array(
		'type'		=> 'index',
		'data'		=> $event_data,
		'settings'	=> $structure_settings,
		'links'		=> $structure_links,
		'extras'	=> array('end' => '<input type="radio" name="data[Collection][event_master_id]"  '.($found_event ? '' : 'checked="checked"').' value=""/>'.__('n/a'))
);

$display_next_sub_form = true;

// CUSTOM CODE
$hook_link = $this->Structures->hook('event_detail');
if( $hook_link ) {
	require($hook_link);
}

// BUILD FORM
if($display_next_sub_form) $this->Structures->build( $final_atim_structure, $final_options );
