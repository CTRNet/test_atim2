<?php
	
	// SETTINSG
	
	$structure_settings = array(
		'tree'=>array(
			'SampleMaster'		=> 'SampleMaster',
			'AliquotMaster'	=> 'AliquotMaster'
		)
	);
	
	// LINKS
	
		$filter_links = array( 
			'no filter'=>'/inventorymanagement/sample_masters/tree/'.$atim_menu_variables['Collection.id'].'/' 
		);
		
		foreach ( $sample_controls as $sample_control ) {
			$filter_links[ $sample_control['SampleControl']['sample_category'].' - '.$sample_control['SampleControl']['sample_type'] ] = '/inventorymanagement/sample_masters/tree/'.$atim_menu_variables['Collection.id'].'/';
		}

	$structure_links = array(
		'tree'=>array(
			'SampleMaster' => array(
				'detail'=>'/inventorymanagement/sample_masters/detail/'.$atim_menu_variables['Collection.id'].'/%%SampleMaster.id%%'
			),
			'AliquotMaster' => array(
				'detail'=>'/inventorymanagement/aliquot_masters/detailAliquot/'.$atim_menu_variables['Collection.id'].'/%%AliquotMaster.sample_master_id%%/%%AliquotMaster.id%%'
			)
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
	
	// EXTRAS
	
	$structure_extras = array(
		2 => '<div id="frame"></div>'
	);
	
	// BUILD
	
	$structures->build( $atim_structure, array('type'=>'tree', 'settings'=>$structure_settings, 'links'=>$structure_links, 'extras'=>$structure_extras) );
?>