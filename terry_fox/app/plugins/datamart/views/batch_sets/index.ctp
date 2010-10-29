<?php 
	$structure_links = array(
		'index'=>array(
			'detail'=>'/datamart/batch_sets/listall/'.$atim_menu_variables['Param.Type_Of_List'].'/%%BatchSet.id%%'
		),
		'bottom'=>array(
			'delete in batch' => '/datamart/batch_sets/deleteInBatch',
			'filter'=>array(
				'my batch sets'=>'/datamart/batch_sets/index',
				'group batch sets'=>'/datamart/batch_sets/index/group',
				'all batch sets'=>'/datamart/batch_sets/index/all'
			)
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>