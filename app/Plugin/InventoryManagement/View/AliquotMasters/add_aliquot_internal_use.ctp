<?php 
$structure_links = array(
	'top' => '/InventoryManagement/AliquotMasters/addAliquotInternalUse/'.$aliquot_master_id,
	'bottom' => array('cancel' => $url_to_cancel)
);

$parent_settings = array(
	'type' => 'edit',
	'links' => $structure_links,
	'settings' => array(
		'actions' => false,
		'form_top' => false,
		'form_bottom' => false,
		'header' => __('internal use'),
		'stretch' => false,
		"language_heading" => __('used aliquot (for update)'),
		'section_start' => true
	)
);

$children_settings = array(
	'type' => 'addgrid',
	'links' => $structure_links,
	'settings' => array(
		'actions' => false,
		'form_top' => false,
		'form_bottom' => false,
		"add_fields"	=> true, 
		"del_fields"	=> true,
		"language_heading" => __('internal use creation'),
		'section_end' => true
	)
);
	
$hook_link = $this->Structures->hook();
if($hook_link){
	require($hook_link); 
}

$hook_link = $this->Structures->hook('loop');
	
$first = true;
$creation = 0;

$many_studied_aliquots = (sizeof($this->request->data) == 1)? false : true;
while($data_unit = array_shift($this->request->data)){
	$final_options_parent = $parent_settings;
	$final_options_children = $children_settings;
	
	$final_options_parent['settings']['header'] .= $many_studied_aliquots? " #".(++$creation) : '';
	$final_options_parent['data'] = $data_unit['parent'];
	$final_options_parent['settings']['name_prefix'] = $data_unit['parent']['AliquotMaster']['id'];
	$final_options_children['settings']['name_prefix'] = $data_unit['parent']['AliquotMaster']['id'];
	
	$final_options_parent['data'] = $data_unit['parent'];
	$final_options_children['data'] = $data_unit['children'];
	
	if($first){
		$first = false;
		$final_options_parent['settings']['form_top'] = true;
	}
	if(empty($this->request->data)){
		$final_options_children['settings']['actions'] = true;
		$final_options_children['settings']['form_bottom'] = true;
		if($many_studied_aliquots) $final_options_children['settings']['confirmation_msg'] = __('multi_entry_form_confirmation_msg');
		$final_options_children['extras'] = '<input type="hidden" name="data[url_to_cancel]" value="'.$url_to_cancel.'"/>';
	}
	
	if(empty($data_unit['parent']['AliquotControl']['volume_unit'])){
		$final_structure_parent = $aliquots_structure;
		$final_structure_children = $aliquotinternaluses_structure;
	}else{
		$final_structure_parent = $aliquots_volume_structure;
		$final_structure_children = $aliquotinternaluses_volume_structure;
		$final_options_children['override']['AliquotControl.volume_unit'] = $data_unit['parent']['AliquotControl']['volume_unit'];
	}
		
	if( $hook_link ) { 
		require($hook_link); 
	}
	
	$this->Structures->build($final_structure_parent, $final_options_parent);
	$this->Structures->build($final_structure_children, $final_options_children);
}				
?>
<script>
var copyControl = true;
</script>