<?php
	$structure_links = array(
		'top'=>NULL,
		'index'=>'/order/orders/detail/%%Order.id%%/',
		'bottom'=>array(
			'add'=>'/order/orders/add/'
		)
	);
	
	$structure_override = array('Order.study_summary_id'=>$study_summary_id_findall);
	$structures->build( $atim_structure, array('type'=>'index','links'=>$structure_links,'override'=>$structure_links) );
?>