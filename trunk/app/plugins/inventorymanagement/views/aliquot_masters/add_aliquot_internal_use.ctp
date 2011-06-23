<?php 
$structure_links = array(
	'top' => '/inventorymanagement/aliquot_masters/addAliquotInternalUse/',
	'bottom' => array('cancel' => $cancel_button)
);

$parent_settings = array(
	'type' => 'edit',
	'links' => $structure_links,
	'settings' => array(
		'actions' => false,
		'form_top' => false,
		'form_bottom' => false,
		'header' => __('used aliquot', true). " - ".__('creation', true)." #",
		'stretch' => false
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
		"del_fields"	=> true
	)
);
	
$hook_link = $structures->hook();
if($hook_link){
	require($hook_link); 
}

$hook_link = $structures->hook('loop');
	
$first = true;
$creation = 0;

while($data_unit = array_shift($this->data)){
	$final_options_parent = $parent_settings;
	$final_options_children = $children_settings;
	
	$final_options_parent['settings']['header'] .= (++$creation);
	$final_options_parent['data'] = $data_unit['parent'];
	$final_options_parent['settings']['name_prefix'] = $data_unit['parent']['AliquotMaster']['id'];
	$final_options_children['settings']['name_prefix'] = $data_unit['parent']['AliquotMaster']['id'];
	
	$final_options_parent['data'] = $data_unit['parent'];
	$final_options_children['data'] = $data_unit['children'];
	
	if($first){
		$first = false;
		$final_options_parent['settings']['form_top'] = true;
	}
	if(empty($this->data)){
		$final_options_children['settings']['actions'] = true;
		$final_options_children['settings']['form_bottom'] = true;
	}
	
	if(empty($data_unit['parent']['AliquotControl']['volume_unit'])){
		$final_structure_parent = $aliquots_structure;
		$final_structure_children = $aliquotinternaluses_structure;
	}else{
		$final_structure_parent = $aliquots_volume_structure;
		$final_structure_children = $aliquotinternaluses_volume_structure;
	}
		
	if( $hook_link ) { 
		require($hook_link); 
	}
	
	$structures->build($final_structure_parent, $final_options_parent);
	$structures->printLightHeader(__('internal use', true));
	$structures->build($final_structure_children, $final_options_children);
}				
?>
<script>
var copyControl = true;
</script>