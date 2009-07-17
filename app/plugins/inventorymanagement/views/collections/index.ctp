<?php 

	$structure_links = array(
		'top'=>'/inventorymanagement/collections/search',
		'bottom'=>array(
			'add'=>'/inventorymanagement/collections/add'
		)
	);
	
	$structure_override = array('Collection.bank_id'=>$bank_id_findall,'Collection.sop_master_id'=>$sop_master_id_findall);
	$structures->build( $atim_structure, array('type'=>'search','links'=>$structure_links,'override'=>$structure_override) );

?>