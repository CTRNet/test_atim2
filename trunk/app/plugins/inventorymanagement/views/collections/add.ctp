<?php 
	$structure_links = array(
		'top'=>'/inventorymanagement/collections/add',
		'bottom'=>array(
			'cancel'=>'/inventorymanagement/collections/index'
		)
	);
	
	$structure_override = array('Collection.sop_master_id'=>$sop_master_id_findall,'Collection.bank_id'=>$bank_id_findall);
	$structures->build( $atim_structure, array('links'=>$structure_links,'override'=>$structure_override) );
?>