<?php

	$filter_links = array( 'no filter'=>'/inventorymanagement/sample_masters/tree/'.$atim_menu_variables['Collection.id'].'/' );
	foreach ( $sample_controls as $sample_control ) {
		$filter_links[ $sample_control['SampleControl']['sample_category'].' - '.$sample_control['SampleControl']['sample_type'] ] = '/inventorymanagement/sample_masters/tree/'.$atim_menu_variables['Collection.id'].'/';
	}

	$structure_links = array(
		'index'=>array(
			'detail'=>'/inventorymanagement/sample_masters/detail/'.$atim_menu_variables['Collection.id'].'/%%SampleMaster.id%%'
			),
		'bottom' => array(
			'filter' => $filter_links
		)
	);
	
	$structures->build( $atim_structure, array('type'=>'tree', 'links'=>$structure_links) );
?>