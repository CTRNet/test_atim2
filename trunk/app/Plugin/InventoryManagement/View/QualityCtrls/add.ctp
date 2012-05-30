<?php 
function updateHeading(array &$sfs_array, $heading){
	foreach($sfs_array as &$sfs){
		if($sfs['flag_edit']){
			$sfs['language_heading'] = $heading;
			break;
		}
	}
}

//preparing structures
$parent_structure = $samples_structure;
$parent_structure_w_vol = null;
$children_structure = $qc_structure;
$children_structure_w_vol = $qc_volume_structure;

if(isset($this->request->data[0]['parent']['AliquotMaster'])){
	//we've got aliquots, prep parent with and w/o vol
	foreach($parent_structure['Sfs'] as &$sfs){
		$sfs['display_column'] -= 10;
	}
	
	//updating headings
	updateHeading($parent_structure['Sfs'], 'sample');
	updateHeading($aliquots_structure['Sfs'], 'used aliquot');
	updateHeading($aliquots_volume_structure['Sfs'], 'used aliquot');

	$parent_structure_w_vol['Structure'] = array_merge(array($parent_structure['Structure']), $aliquots_volume_structure['Structure']);
	$parent_structure_w_vol['Sfs'] = array_merge($parent_structure['Sfs'], $aliquots_volume_structure['Sfs']);

	$parent_structure['Structure'] = array($parent_structure['Structure'], $aliquots_structure['Structure']);
	$parent_structure['Sfs'] = array_merge($parent_structure['Sfs'], $aliquots_structure['Sfs']);
}

$links = array(
	'top' 		=> '/InventoryManagement/QualityCtrls/add/'.$sample_master_id_parameter,
	'bottom'	=> array('cancel' => $cancel_button)
);

$options_parent = array(
	'type'		=> 'edit',
	'links'		=> $links,
	'settings'	=> array(
		'header'		=> __('quality control creation process') . ' - ' . __('creation'),
		'form_top'		=> false,
		'actions'		=> false,
		'form_bottom'	=> false,
		'stretch'		=> false,
		'section_start'	=> true
	)
);

$options_children = array(
	'type'		=> 'addgrid',
	'links'		=> $links,
	'settings'	=> array(
		'form_top'		=> false,
		'actions'		=> false,
		'form_bottom'	=> false,
		"add_fields"	=> true, 
		"del_fields"	=> true,
		"language_heading" => __('quality controls'),
		'section_end'	=> true
	)
);

$first = true;
$counter = 0;

$hook_link = $this->Structures->hook();
if( $hook_link ) {
	require($hook_link);
}

$hook_link = $this->Structures->hook('loop');

$final_structure_parent = null;
$final_structure_children = null;

$one_parent = (sizeof($this->request->data) == 1)? true : false;

while($data = array_shift($this->request->data)){
	$parent = $data['parent'];
	$prefix = isset($parent['AliquotMaster']) ? $parent['AliquotMaster']['id'] : $parent['ViewSample']['sample_master_id'];
	$final_options_parent = $options_parent;
	$final_options_children = $options_children; 
	
	if($first){
		//first row
		$final_options_parent['settings']['form_top'] = true;
	}
	
	if(empty($this->request->data)){
		//last row
		$final_options_children['settings']['actions'] = true;
		$final_options_children['settings']['form_bottom'] = true;
		if(!$one_parent) $final_options_children['settings']['confirmation_msg'] = __('multi_entry_form_confirmation_msg');
		$final_options_children['extras'] = '<input type="hidden" name="data[url_to_cancel]" value="'.$cancel_button.'"/>';
	}
	
	$final_options_parent['data'] = $parent;
	
	$final_options_parent['settings']['header'] .=  $one_parent? '' : " #".(++ $counter);
	$final_options_parent['settings']['name_prefix'] = $prefix;
	
	$final_options_children['settings']['name_prefix'] = $prefix;
	$final_options_children['data'] = $data['children'];
	
	if(isset($parent['AliquotControl']['volume_unit']) && strlen($parent['AliquotControl']['volume_unit']) > 0){
		$final_structure_parent = $parent_structure_w_vol;
		$final_structure_children = $children_structure_w_vol;
		$final_options_children['override']['AliquotControl.volume_unit'] = $parent['AliquotControl']['volume_unit'];
	}else{
		$final_structure_parent = $parent_structure;
		$final_structure_children = $children_structure;
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