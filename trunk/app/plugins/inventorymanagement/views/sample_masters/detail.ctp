<?php

	// Set links
	$structure_links = array();
	
	// If a parent sample is defined then set the 'Show Parent' button
	$show_parent_link = '/underdevelopment/';
	if(!empty($parent_sample_data)) { $show_parent_link = '/inventorymanagement/sample_masters/detail/' . $atim_menu_variables['Collection.id'] . '/' . $parent_sample_data['SampleMaster']['id']; }
	
	// Create array of derivative type that could be created from studied sample for the ADD button
	$add_derivatives = array();
	foreach($allowed_derivative_type as $sample_control) {
		$add_derivatives[$sample_control['SampleControl']['sample_type']] = '/inventorymanagement/sample_masters/add/' . $atim_menu_variables['Collection.id'] . '/' . $sample_control['SampleControl']['id'] . '/' . $atim_menu_variables['SampleMaster.id'];
	}		
	$add_derivatives = empty($add_derivatives)? '/underdevelopment/': $add_derivatives;
	
	// Create array of aliquot type that could be created for the studied sample for the ADD button 
	$add_aliquots = array();	
	foreach($allowed_aliquot_type as $aliquot_control) {
		$add_aliquots[$aliquot_control['AliquotControl']['aliquot_type']] = '/inventorymanagement/aliquot_masters/add/' . $atim_menu_variables['Collection.id'] . '/' . $atim_menu_variables['SampleMaster.id'] . '/' . $aliquot_control['AliquotControl']['id'];
	}		
	$add_aliquots = empty($add_aliquots)? '/underdevelopment/': $add_aliquots;
	
	$structure_links = array();
	if($is_inventory_plugin_form){
		$structure_links['bottom'] = array(
			'edit' => '/inventorymanagement/sample_masters/edit/' . $atim_menu_variables['Collection.id'] . '/' . $atim_menu_variables['SampleMaster.id'], 
			'delete' => '/inventorymanagement/sample_masters/delete/' . $atim_menu_variables['Collection.id'] . '/' . $atim_menu_variables['SampleMaster.id'], 
			'see parent sample' => $show_parent_link,
			'add derivative' => $add_derivatives,
			'add aliquot' => $add_aliquots
		);
	}
		
	if($is_tree_view_detail_form) {
		// Detail form displayed in tree view: Add button to access all sample data
		$structure_links['bottom']['access to all data'] = '/inventorymanagement/sample_masters/detail/' . $atim_menu_variables['Collection.id'] . '/' . $atim_menu_variables['SampleMaster.id'];
	} else {
		// General detail form display
		$search_type_links = array();
		$search_type_links['collection'] = '/inventorymanagement/collections/index/';
		$search_type_links['sample'] = '/inventorymanagement/sample_masters/index/';
		$search_type_links['aliquot'] = '/inventorymanagement/aliquot_masters/index/';
	
		$structure_links['bottom']['search'] = $search_type_links;
	}

	$structure_override = array();
	
	$structure_override['SampleMaster.sop_master_id'] = $arr_sample_sops;
	$structure_override['SampleMaster.parent_id'] = (empty($parent_sample_data))? '' : $parent_sample_data['SampleMaster']['sample_code'] . ' [' . __($parent_sample_data['SampleMaster']['sample_type'], TRUE) . ']';

	//$structures->build($atim_structure, array('links'=>$structure_links, 'override' => $structure_override));
	if(isset($aliquots_listall_structure)){
		$structures->build($atim_structure, array('override' => $structure_override, 'settings' => array('actions' => false), 'data' => $sample_master_data));
		$structure_links['index']['detail'] = '/inventorymanagement/aliquot_masters/detail/%%Collection.id%%/%%SampleMaster.id%%/%%AliquotMaster.id%%';
		
		$structure_override = array();
		$bank_list = array();
		foreach($banks as $new_bank) {
			$bank_list[$new_bank['Bank']['id']] = $new_bank['Bank']['name'];
		}
		$structure_override['Collection.bank_id'] = $bank_list;
		?>
		<table class="structure" cellspacing="0">
			<tbody><tr><th style='text-align: left; padding-left: 10px; padding-right: 10px;'><hr/><?php echo(__('Aliquots', null)); ?></th></tr>
		</tbody></table>
		<?php
		$structures->build($aliquots_listall_structure, array('type' => 'index', 'links' => $structure_links, 'override' => $structure_override, 'data' => $aliquots_data));
	}else{
		$structures->build($atim_structure, array('override' => $structure_override, 'links' => $structure_links, 'data' => $sample_master_data));
	}
	
?>