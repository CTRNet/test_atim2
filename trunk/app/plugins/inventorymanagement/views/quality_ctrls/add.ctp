<?php 
//preparing structures
$parent_structure = $samples_structure;
$parent_w_vol_structure = null;
$children_structure = $qc_structure;
$children_structure_w_vol = $qc_volume_structure;

if(isset($this->data[0]['parent']['AliquotMaster'])){
	//we've got aliquots
	$max_col = max(1, $aliquots_structure['Sfs'][0]['display_column']);
	foreach($aliquots_structure['Sfs'] as $sfs){
		$max_col = max($max_col, $sfs['display_column']);
	}
	foreach($aliquots_structure['Sfs'] as &$sfs){
		$sfs['display_column'] += $max_col;
	}
	
	//updating headings
	foreach($parent_structure['Sfs'] as &$sfs){
		if($sfs['flag_edit']){
			$sfs['language_heading'] = 'parent sample';
			break;
		}
	}
	foreach($aliquots_structure['Sfs'] as &$sfs){
		if($sfs['flag_edit']){
			$sfs['language_heading'] = 'used aliquot';
			break;
		}
	}
	
	$parent_structure['Structure'] = array($parent_structure['Structure'], $aliquots_structure['Structure']);
	$parent_structure['Sfs'] = array_merge($parent_structure['Sfs'], $aliquots_structure['Sfs']);
	
	//create volume structures
	$parent_structure_w_vol = $parent_structure;
	$parent_structure_w_vol['Structure'][] = $aliquots_volume_structure['Structure'];
	$last_sfs_index = count($parent_structure_w_vol['Sfs']) - 1;
	array_shift($aliquots_volume_structure['Sfs']);//dumping non wanted field
	$aliquots_volume_structure['Sfs'][0]['display_column'] = $parent_structure_w_vol['Sfs'][$last_sfs_index]['display_column'];
	$aliquots_volume_structure['Sfs'][0]['display_order'] = $parent_structure_w_vol['Sfs'][$last_sfs_index]['display_order'] + 1;
	$aliquots_volume_structure['Sfs'][1]['display_column'] = $parent_structure_w_vol['Sfs'][$last_sfs_index]['display_column'];
	$aliquots_volume_structure['Sfs'][1]['display_order'] = $parent_structure_w_vol['Sfs'][$last_sfs_index]['display_order'] + 2;
	$parent_structure_w_vol['Sfs'][] = array_shift($aliquots_volume_structure['Sfs']);
	$parent_structure_w_vol['Sfs'][] = array_shift($aliquots_volume_structure['Sfs']);
}

$links = array(
	'top' 		=> '/inventorymanagement/quality_ctrls/add/',
	'bottom'	=> array('cancel' => 'todo')
);

$options_parent = array(
	'type'		=> 'edit',
	'links'		=> $links,
	'settings'	=> array(
		'header'		=> __('quality control creation process', true) . ' - ' . __('creation', true) ." #",
		'form_top'		=> false,
		'actions'		=> false,
		'form_bottom'	=> false,
		'stretch'		=> false
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
		"del_fields"	=> true
	)
);

$first = true;
$counter = 0;

$hook_link = $structures->hook();
if( $hook_link ) {
	require($hook_link);
}

$hook_link = $structures->hook('loop');

$final_structure_parent = null;
$final_structure_children = null;

while($data = array_shift($this->data)){
	$parent = $data['parent'];
	$prefix = isset($parent['AliquotMaster']) ? $parent['AliquotMaster']['id'] : $parent['ViewSample']['sample_master_id'];
	$final_options_parent = $options_parent;
	$final_options_children = $options_children; 
	
	if($first){
		//first row
		$final_options_parent['settings']['form_top'] = true;
	}
	
	if(empty($this->data)){
		//last row
		$final_options_children['settings']['actions'] = true;
		$final_options_children['settings']['form_bottom'] = true;
	}
	
	$final_options_parent['data'] = $parent;
	$final_options_parent['settings']['header'] .= ++ $counter;
	$final_options_parent['settings']['name_prefix'] = $prefix;
	
	$final_options_children['settings']['name_prefix'] = $prefix;
	$final_options_children['data'] = $data['children'];
	
	if(isset($parent['AliquotControl']['volume_unit']) && strlen($parent['AliquotControl']['volume_unit']) > 0){
		$final_structure_parent = $parent_structure_w_vol;
		$final_structure_children = $children_structure_w_vol;
	}else{
		$final_structure_parent = $parent_structure;
		$final_structure_children = $children_structure;
	}
	
	if( $hook_link ) {
		require($hook_link);
	}
	
	$structures->build($final_structure_parent, $final_options_parent);
	$structures->build($final_structure_children, $final_options_children);
}

?>
<script>
var copyControl = true;
</script>