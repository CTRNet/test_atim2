<?php

	$filter_links = array( 
		'no filter'=>'/inventorymanagement/sample_masters/tree/'.$atim_menu_variables['Collection.id'].'/' 
	);
	
	foreach ( $sample_controls as $sample_control ) {
		$filter_links[ $sample_control['SampleControl']['sample_category'].' - '.$sample_control['SampleControl']['sample_type'] ] = '/inventorymanagement/sample_masters/tree/'.$atim_menu_variables['Collection.id'].'/';
	}

	$structure_links = array(
		'index'=>array(
			'detail'=>'/inventorymanagement/sample_masters/detail/'.$atim_menu_variables['Collection.id'].'/%%SampleMaster.id%%'
		),
		'bottom' => array(
			'filter' => $filter_links
		),
		
		'ajax' => array(
			'index' => array(
				'detail' => 'frame'
			)
		)
	);
	
	$structure_extras = array(
		2 => '<div id="frame"></div>'
	);
	
	$structures->build( $atim_structure, array('type'=>'tree', 'links'=>$structure_links, 'extras'=>$structure_extras) );
?>