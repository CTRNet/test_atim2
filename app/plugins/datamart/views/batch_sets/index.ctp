<?php 
	$structure_links = array(
		'index'=>array(
			'detail'=>'/datamart/batch_sets/listall/%%BatchSet.id%%'
		),
		'bottom'=>array(
			'filter'=>array(
				'my batch sets'=>'/datamart/batch_sets/index',
				'group batch sets'=>'/datamart/batch_sets/index/group'
			)
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>