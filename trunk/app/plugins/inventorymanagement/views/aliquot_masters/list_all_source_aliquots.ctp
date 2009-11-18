<?php 
	$structure_links = array(
		'index'=>array(
			'detail' => '/inventorymanagement/aliquot_masters/detail/%%AliquotMaster.collection_id%%/%%AliquotMaster.sample_master_id%%/%%AliquotMaster.id%%',
			'delete' => '/inventorymanagement/aliquot_masters/deleteAliquotUse/%%SampleMaster.collection_id%%/%%SampleMaster.id%%/%%AliquotMaster.id%%/%%AliquotUse.id%%/2/'
		),
		'bottom'=>array(
			'add'=>'/inventorymanagement/aliquot_masters/addSourceAliquots/'
				.$atim_menu_variables['Collection.id'].'/'
				.$atim_menu_variables['SampleMaster.id'].'/'
		),
	);
		
	$structures->build( $atim_structure, array('type'=>'index','links'=>$structure_links) );
	
?>