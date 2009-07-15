<?php 

	$structure_links = array(
		'index'=>array('detail'=>'/order/order_lines/detail/'.$atim_menu_variables['Order.id'].'/%%OrderLine.id%%/'),
		'bottom'=>array(
			'add'=>'/order/order_lines/add/'.$atim_menu_variables['Order.id'].'/'
		)
	);
	
	$structure_override = array('OrderLine.sample_control_id'=>$sample_control_id_findall);
	$structures->build( $atim_structure, array('type'=>'index','links'=>$structure_links,'override'=>$structure_override) );

?>
