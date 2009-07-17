<?php 

	$structure_links = array(
		'index'=>array('detail'=>'/inventorymanagement/collections/detail/%%Collection.id%%'),
		'bottom'=>array(
			'add'=>'/inventorymanagement/collections/add',
			'search'=>'/inventorymanagement/collections/index'
		)
	);
	
	$structure_override = array('Collection.bank_id'=>$bank_find_all);
	$structures->build( $atim_structure, array('type'=>'index','links'=>$structure_links,'override'=>$bank_id_findall) );

?>
