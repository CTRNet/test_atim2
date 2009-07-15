<?php 

	$structure_links = array(
		'index'=>array('detail'=>'/order/orders/detail/%%Order.id%%'),
		'bottom'=>array(
			'add'=>'/order/orders/add',
			'search'=>'/order/orders/index'
		)
	);
	
	$structure_override = array('Order.study_summary_id'=>$study_summary_id_findall);
	$structures->build( $atim_structure, array('type'=>'index','links'=>$structure_links,'override'=>$structure_override) );

?>