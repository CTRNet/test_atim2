<?php 
	$structure_links = array(
		'top'=>'/order/orders/add/',
		'bottom'=>array(
			'cancel'=>'/order/orders/listall/'
		)
	);
	
	$structure_override = array('Order.study_summary_id'=>$study_summary_id_findall);
	$structures->build( $atim_structure, array('links'=>$structure_links,'override'=>$structure_override) );
?>