<?php 
	$structure_links = array(
		'top'=>'/order/shipments/add/'.$atim_menu_variables['Order.id'].'/',
		'bottom'=>array(
			'cancel'=>'/order/shipments/listall/'.$atim_menu_variables['Order.id'].'/'
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>