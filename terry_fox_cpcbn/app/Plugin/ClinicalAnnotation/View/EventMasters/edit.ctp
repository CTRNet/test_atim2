<?php 

	$structure_links = array(
		'top'=>'/ClinicalAnnotation/EventMasters/edit/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['EventMaster.id'],
	);
	
	// 1- EVENT DATA
	
	$structure_settings = array(
		'actions'		=> false, 
		'form_bottom'	=> false);
		
	$final_atim_structure = $atim_structure;
	$final_options = array( 'settings'=>$structure_settings, 'links'=>$structure_links );
	
	$hook_link = $this->Structures->hook();
	if( $hook_link ) { 
		require($hook_link); 
	}
	
	$this->Structures->build( $final_atim_structure, $final_options);		

	// 2- SEPARATOR & HEADER
	
	$structure_settings = array(
		'header'		=> __('related diagnosis'),
		'form_top'		=> false,
		'tree'			=> array('DiagnosisMaster' => 'DiagnosisMaster'),
		'form_inputs'	=> false
	);

	// Define radio should be checked
	$radio_checked = empty($this->request->data['EventMaster']['diagnosis_master_id']); 
	
	$structure_links = array(
		'top'=>'/ClinicalAnnotation/EventMasters/edit/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['EventMaster.id'],
		'bottom'=>array(
				'cancel'=>'/ClinicalAnnotation/EventMasters/detail/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['EventMaster.id']
		),'tree'	=> array(
			'DiagnosisMaster' => array(
				'radiolist' => array('EventMaster.diagnosis_master_id'=>'%%DiagnosisMaster.id'.'%%')			
			)
		)
	);
	
	
	$final_options = array(
		'type'		=> 'tree',
		'data'		=> $data_for_checklist,
		'settings'	=> $structure_settings,
		'links'		=> $structure_links,
		'extras'	=> array('start' => '<input type="radio" name="data[EventMaster][diagnosis_master_id]" '.($radio_checked ? 'checked="checked"' : '').' value=""/>'.__('n/a', null))
	);
	$final_atim_structure = array('DiagnosisMaster' => $diagnosis_structure);
	
	$display_next_sub_form =true;
	
	$hook_link = $this->Structures->hook('dx_list');
	if($hook_link){
		require($hook_link);
	}
	
	if($display_next_sub_form) $this->Structures->build( $final_atim_structure, $final_options);
?>
<script>
var treeView = true;
</script>