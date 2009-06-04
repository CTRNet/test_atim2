<?php 

	$structure_links = array(
		'index'=>array('detail'=>'/order/orders/detail/%%Order.id%%'),
		'bottom'=>array(
			'add'=>'/order/orders/add',
			'search'=>'/order/orders/index'
		)
	);
	
	$structures->build( $atim_structure, array('type'=>'index','links'=>$structure_links) );

?>