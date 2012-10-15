<?php 
	
	$this->Structures->build($final_atim_structure, $final_options);
	
	$final_atim_structure = $qcroc_aliquot_transfer;
	$final_options = array(
		'type' => 'index',
		'data' => $transfers_data,
		'links' => array(
			'index'	=> array('detail' => "/InventoryManagement/AliquotMasters/detailAliquotInternalUse/%%AliquotMaster.id%%/%%AliquotInternalUse.id%%/")
		),'settings'	=> array(
			'pagination'	=> false,
			'actions'		=> false,
			'language_heading' => __('transfers')
		)	
	);
		