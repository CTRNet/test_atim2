<?php 
	$add_links = array();
	foreach ( $storage_controls as $storage_control ) {
		$add_links[$storage_control['StorageControl']['storage_type']] = '/storagelayout/storage_masters/add/';
	}

	$structure_links = array(
		'top'=>array('search'=>'/storagelayout/storage_masters/search/'),
		'bottom'=>array('add' => $add_links)
	);
	
	$structures->build( $atim_structure, array('type'=>'search','links'=>$structure_links) );
?>