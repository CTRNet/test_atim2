<?php 

	$structure_links = array(
		'index' => array( 
			'detail' => '/inventorymanagement/sample_masters/detail/'.$atim_menu_variables['Collection.id'].'/%%SampleMaster.id%%
		),
		'bottom' => array(
	//		'filter' => $filter_links,
	//		'add' => $add_links
		)
	); 
	
	$structures->build( $atim_structure, array('type'=>'search','links'=>$structure_links) );	
	
?>