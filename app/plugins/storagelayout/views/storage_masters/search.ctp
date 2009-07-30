<?php
	$add_links = array();
	foreach ( $storage_controls as $storage_control ) {
		$add_links[$storage_control['StorageControl']['storage_type']] = '/storagelayout/storage_masters/add/'.$storage_control['StorageControl']['id'];
	}
	
	$structure_links = array(
		'index'=>array('detail'=>'/storagelayout/storage_masters/detail/%%StorageMaster.id%%'),
		'bottom'=>array(
			'add'=> $add_links,
			'search'=>'/storagelayout/storage_masters/index'
		)
	);
	
	$structures->build( $atim_structure, array('type'=>'index','links'=>$structure_links) );
?>