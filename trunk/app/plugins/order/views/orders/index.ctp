<?php
	$structure_links = array(
		'top'=>array('search'=>'/order/orders/search/'),
		'bottom'=>array(
			'add'=>'/order/orders/add/'
		)
	);
	
	$structures->build( $atim_structure, array('type'=>'search','links'=>$structure_links, 'override'=>array('Order.study_summary_id'=>$atim_menu_variables['StudySummary'])) );
?>