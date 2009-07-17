<?php 

	$structure_links = array(
		'index'=>array('detail'=>'/inventorymanagement/collections/detail/%%Collection.id%%'),
		'bottom'=>array(
			'add'=>'/inventorymanagement/collections/add',
			'search'=>'/inventorymanagement/collections/index'
		)
	);
	
	$structure_override = array('Collection.bank_id'=>$bank_id_findall,'Collection.sop_master_id'=>$sop_master_id_findall);
	$structures->build( $atim_structure, array('type'=>'index','links'=>$structure_links,'override'=>$structure_override) );

?>
