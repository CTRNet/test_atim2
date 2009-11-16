<?php 

	$structure_links = array(
		'top'=>'/inventorymanagement/quality_ctrls/addTestedAliquots/'
			.$atim_menu_variables['Collection.id'].'/'
			.$atim_menu_variables['SampleMaster.id'].'/'
				.$atim_menu_variables['QualityCtrl.id'].'/',
		'bottom'=>array(
			'cancel'=>'/inventorymanagement/quality_ctrls/listallTestedAliquots/'
				.$atim_menu_variables['Collection.id'].'/'
				.$atim_menu_variables['SampleMaster.id'].'/'
				.$atim_menu_variables['QualityCtrl.id'].'/'
		)
	);
	
	$structure_override = array();
	
	$structures->build($atim_structure, array('links' => $structure_links, 'override' => $structure_override, 'type' => 'datagrid', 'settings'=> array('pagination' => false)));





?>