<?php 
	$structure_links = array(
		'index'=>array(
			'detail'=>'/Datamart/BatchSets/listall/%%BatchSet.id%%'
		),
		'bottom'=>array(
			'delete in batch' => array('link' => '/Datamart/BatchSets/deleteInBatch', 'icon' => 'delete noPrompt'),
			'filter'=>array(
				'my batch sets'=>'/Datamart/BatchSets/index',
				'group batch sets'=>'/Datamart/BatchSets/index/group',
				'all batch sets'=>'/Datamart/BatchSets/index/all'
			)
		)
	);
	
	$this->Structures->build( $atim_structure, array('links'=>$structure_links) );
?>