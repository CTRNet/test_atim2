<?php
	$structure_links = array(
		'bottom'=>array('cancel'=>'/order/order_items/listall/'.$atim_menu_variables['Order.id'].'/'.$atim_menu_variables['OrderLine.id'].'/')
	);

	$structures->build( $atim_structure, array('type'=>'datagrid','link'=>$structure_links));
?>