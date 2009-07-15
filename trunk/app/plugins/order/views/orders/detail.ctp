<?php 
	$structure_links = array(
		'bottom'=>array(
			'list'=>'/order/orders/listall/',
			'edit'=>'/order/orders/edit/%%Order.id%%/',
			'delete'=>'/order/orders/delete/%%Order.id%%/'
		)
	);
	
	$structure_override = array('Order.study_summary_id'=>$study_summary_id_findall);
	$structures->build( $atim_structure, array('links'=>$structure_links, 'override'=>$structure_override) );
?>