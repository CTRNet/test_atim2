<?php 
	$structure_links = array(
		'top'=>'/inventorymanagement/collections/edit/%%Collection.id%%',
		'bottom'=>array(
			'delete'=>'/inventorymanagement/collections/delete/%%Collection.id%%',
			'cancel'=>'/inventorymanagement/collections/profile/%%Collection.id%%'
		)
	);
	
	$structure_override = array('Collection.bank_id'=>$bank_id_findall,'Collection.sop_master_id'=>$sop_master_id_findall);
	$structures->build( $atim_structure, array('links'=>$structure_links,'override'=>$structure_override) );
?>