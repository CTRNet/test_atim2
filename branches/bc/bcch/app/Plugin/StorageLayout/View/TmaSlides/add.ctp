<?php 
$structure_links = array(
	'top' => '/StorageLayout/TmaSlides/add/'.$tma_block_storage_master_id,
	'bottom' => array('cancel' => $url_to_cancel)
);

$parent_settings = array(
	'type' => 'edit',
	'links' => $structure_links,
	'settings' => array(
		'actions' => false,
		'form_top' => false,
		'form_bottom' => false,
		'header' => __('tma slides creation'),
		'stretch' => false,
		"language_heading" => __('tma block'),
		'section_start' => ($tma_block_storage_master_id? false : true)
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
		"language_heading" => __('tma slides'),
		'section_end' =>  ($tma_block_storage_master_id? false : true)
	)
);
	
$hook_link = $this->Structures->hook();
if($hook_link){
	require($hook_link); 
}
	
// Display empty structure with hidden fields to fix issue#2243
$empty_structure_options = $parent_settings;
$empty_structure_options['settings']['form_top'] = true;
$empty_structure_options['settings']['language_heading'] = '';
$empty_structure_options['settings']['header'] = '';
$empty_structure_options['data'] = array();
$empty_structure_options['extras'] = '<input type="hidden" name="data[url_to_cancel]" value="'.$url_to_cancel.'"/>';

$this->Structures->build(array(), $empty_structure_options);

//BUILD FORM

$hook_link = $this->Structures->hook('loop');
	
$first = true;
$creation = 0;

$many_tma_blocks = (sizeof($this->request->data) == 1)? false : true;
while($data_unit = array_shift($this->request->data)){
	$final_options_parent = $parent_settings;
	$final_options_children = $children_settings;
	
	$final_options_parent['settings']['header'] .= $many_tma_blocks? " #".(++$creation) : '';
	
	$final_options_parent['settings']['name_prefix'] = $data_unit['parent']['StorageMaster']['id'];
	$final_options_children['settings']['name_prefix'] = $data_unit['parent']['StorageMaster']['id'];
	
	$final_options_parent['data'] = $data_unit['parent'];
	$final_options_children['data'] = $data_unit['children'];
	
	if($first){
		$first = false;
		$final_options_parent['settings']['form_top'] = true;
	}
	if(empty($this->request->data)){
		$final_options_children['settings']['actions'] = true;
		$final_options_children['settings']['form_bottom'] = true;
		if($many_tma_blocks) $final_options_children['settings']['confirmation_msg'] = __('multi_entry_form_confirmation_msg');
	}
	
	$final_structure_parent = $tma_blocks_atim_structure;
	$final_structure_children = $atim_structure;
	
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