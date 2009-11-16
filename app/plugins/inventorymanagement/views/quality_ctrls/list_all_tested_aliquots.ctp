<?php 
	$structure_links = array(
		'index'=>array(
			'detail'=>'/inventorymanagement/aliquot_masters/detail/%%AliquotMaster.collection_id%%/%%AliquotMaster.sample_master_id%%/%%AliquotMaster.id%%',
			'delete'=>'/inventorymanagement/quality_ctrls/deleteTestedAliquot/%%AliquotMaster.collection_id%%/%%AliquotMaster.sample_master_id%%/%%QualityCtrl.id%%/%%QualityCtrlTestedAliquot.id%%'
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