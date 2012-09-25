<?php 
	$structure_links = array(
		'index'=>array(
			'detail'=> '/Datamart/BatchSets/listall/%%BatchSet.id%%',
			'edit'	=> '/Datamart/BatchSets/edit/%%BatchSet.id%%',
			'save'	=> array('link' => '/Datamart/BatchSets/save/%%BatchSet.id%%', 'icon' => 'disk'),
			'delete'=> '/Datamart/BatchSets/delete/%%BatchSet.id%%'	
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
	
	$settings = array(
			'header' => array('title' => __('temporary batch sets'). ' ('.__($filter_value).')', 'description' => __('unsaved batch sets that are automatically deleted when there are more than %d', BatchSetsController::$tmp_batch_set_limit)),
			'actions' => false,
			'pagination' => false
	);
	$this->Structures->build( $atim_structure, array('data' => $tmp_batch, 'links'=>$structure_links, 'settings' => $settings) );

	unset($structure_links['index']['save']);
	$settings = array(
		'header' => __('saved batch sets'). ' ('.__($filter_value).')',
		'actions' => true,
		'pagination' => true
	);
	
	$this->Structures->build( $atim_structure, array('links'=>$structure_links, 'settings' => $settings) );
