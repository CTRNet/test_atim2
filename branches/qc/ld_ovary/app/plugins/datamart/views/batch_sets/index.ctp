<?php 
	$structure_links = array(
		'index'=>array(
			'detail'=>'/datamart/batch_sets/listall/%%BatchSet.id%%'
		),
		'bottom'=>array(
			'delete in batch' => array('link' => '/datamart/batch_sets/deleteInBatch', 'icon' => 'delete noPrompt'),
			'filter'=>array(
				'my batch sets'=>'/datamart/batch_sets/index',
				'group batch sets'=>'/datamart/batch_sets/index/group',
				'all batch sets'=>'/datamart/batch_sets/index/all'
			)
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>