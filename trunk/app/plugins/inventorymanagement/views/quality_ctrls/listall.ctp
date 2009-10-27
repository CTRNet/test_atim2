<?php 
	$structure_links = array(
		'index'=>array(
			'detail'=>'/inventorymanagement/quality_ctrls/detail/%%QualityCtrl.id%%',
		),
		'bottom'=>array(
			'add'=>'/inventorymanagement/quality_ctrls/add/'
				.$atim_menu_variables['Collection.id'].'/'
				.$atim_menu_variables['SampleMaster.id'].'/',
				
		),
//add($specimen_group_menu_id=null, $group_specimen_type=null, $sample_category=null,
	//$collection_id=null, $sample_master_id=null		
		//TODO keep or not??
		/*'ajax'=>array(
			'index'=>array(
				'detail'=>'frame',
			),
			'bottom'=>array(
				'add'=>'frame',
			)
		)*/
	);
	
	$structures->build( $atim_structure, array('type'=>'index','links'=>$structure_links) );
	
?>