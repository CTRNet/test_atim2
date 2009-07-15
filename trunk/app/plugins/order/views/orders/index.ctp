<?php
	$structure_links = array(
		'top'=>array('search'=>'/order/orders/search/'),
		'bottom'=>array(
			'add'=>'/order/orders/add/'
		)
	);
	
	$structure_override = array('Order.study_summary_id'=>$study_summary_id_findall);
	$structures->build($atim_structure, array('type'=>'search', 'links'=>$structure_links, 'override'=>$structure_override));
?>