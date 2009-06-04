<?php 

	$structure_links = array(
		'index'=>array('detail'=>'/inventorymanagement/collections/detail/%%Collection.id%%'),
		'bottom'=>array(
			'add'=>'/inventorymanagement/collections/add',
			'search'=>'/inventorymanagement/collections/index'
		)
	);
	
	$structures->build( $atim_structure, array('type'=>'index','links'=>$structure_links) );

?>
