<?php 
	$structure_links = array(
		'index'=>array(
			'detail'=>'/inventorymanagement/aliquot_masters/detail/%%AliquotMaster.collection_id%%/%%AliquotMaster.sample_master_id%%/%%AliquotMaster.id%%',
			'delete'=>'/inventorymanagement/aliquot_masters/deleteAliquotUse/%%AliquotMaster.collection_id%%/%%AliquotMaster.sample_master_id%%/%%AliquotMaster.id%%/%%AliquotUse.id%%/3/%%QualityCtrl.id%%/'
		),
		'bottom'=>array(
			'add'=>'/inventorymanagement/quality_ctrls/addTestedAliquots/'
				.$atim_menu_variables['Collection.id'].'/'
				.$atim_menu_variables['SampleMaster.id'].'/'
				.$atim_menu_variables['QualityCtrl.id'].'/'
		),
	);
		
	$structures->build( $atim_structure, array('type'=>'index','links'=>$structure_links) );
	
?>