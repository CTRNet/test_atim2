<?php 

	$structure_links = array(
		'top'=>'/inventorymanagement/aliquot_masters/addSourceAliquots/'
			.$atim_menu_variables['Collection.id'].'/'
			.$atim_menu_variables['SampleMaster.id'].'/',
		'bottom'=>array(
			'cancel'=>'/inventorymanagement/aliquot_masters/listAllSourceAliquots/'
				.$atim_menu_variables['Collection.id'].'/'
				.$atim_menu_variables['SampleMaster.id'].'/'
		)
	);
	
	$structure_override = array();
	
	$structures->build($atim_structure, array('links' => $structure_links, 'override' => $structure_override, 'type' => 'datagrid', 'settings'=> array('pagination' => false)));

?>