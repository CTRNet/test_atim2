<?php 
	$structure_links = array(
		'top'=>'/order/orders/add/',
		'bottom'=>array(
			'cancel'=>'/order/orders/listall/'
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>