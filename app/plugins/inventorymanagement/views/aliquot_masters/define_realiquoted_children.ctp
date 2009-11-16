<?php 

	$structure_links = array(
		'top'=>'/inventorymanagement/aliquot_masters/defineRealiquotedChildren/'
			.$atim_menu_variables['Collection.id'].'/'
			.$atim_menu_variables['SampleMaster.id'].'/'
				.$atim_menu_variables['AliquotMaster.id'].'/',
		'bottom'=>array(
			'cancel'=>'/inventorymanagement/quality_ctrls/listallTestedAliquots/'
				.$atim_menu_variables['Collection.id'].'/'
				.$atim_menu_variables['SampleMaster.id'].'/'
				.$atim_menu_variables['AliquotMaster.id'].'/'
		),
//		'datagrid' => array(
//				'id' => '%%AliquotMaster.id%%'
//			),
	);
	$structure_settings = array(
//		'form_bottom'=>false, 
//		'form_inputs'=>false,//this makes the barcode work or not, looks like a bug
		'actions'=>false,
		'pagination'=>false
	);
//	pr($aliquot_data);
	$structure_override = array();
	
//	$structure_override = array();
//	pr($aliquot_data);
//	$structures->build($atim_structure, array('links' => $structure_links, 'override' => $structure_override, 'type' => 'datagrid', 'settings'=> array('pagination' => false)));
//	$structures->build( $atim_structure_consent_detail, array('type'=>'radiolist', 'data'=>$consent_data, 'settings'=>$structure_settings, 'links'=>$structure_links) );
	$structures->build( $atim_structure_aliquot, array('type'=>'datagrid', 'data'=>$aliquot_data, 'links'=>$structure_links, 'settings' => $structure_settings) );
?>


