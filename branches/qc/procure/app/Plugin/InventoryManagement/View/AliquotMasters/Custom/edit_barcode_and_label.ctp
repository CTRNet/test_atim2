<?php 

	$structure_links = array(
		'top'=>'/InventoryManagement/AliquotMasters/editBarcodeAndLabel/',
		'bottom'=>array('cancel'=>$url_to_cancel)
	);
	
	$final_atim_structure = $atim_structure; 
	$final_options = array(
		'type' => 'editgrid', 
		'links'=>$structure_links, 
		'extras' => $this->Form->input('url_to_cancel', array('type' => 'hidden', 'value' => $url_to_cancel)).$this->Form->input('aliquot_ids_to_update', array('type' => 'hidden', 'value' => $aliquot_ids_to_update)),
		'settings'=> array('pagination' => false, 'header' => __('aliquot barcode (and label) update')));
	
	// CUSTOM CODE
	$hook_link = $this->Structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$this->Structures->build( $final_atim_structure, $final_options );	
?>

