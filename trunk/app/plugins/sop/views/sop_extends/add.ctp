<?php
	$structure_links = array(
		'top'=>'/sop/sop_extends/add/'.$atim_menu_variables['SopMaster.id'].'/',
		'bottom'=>array(
			'cancel'=>'/sop/sop_extends/listall/'.$atim_menu_variables['SopMaster.id'].'/'
		)
	);
	
	$structure_override = array('SopExtend.material_id'=>$material_id_findall);
	$structures->build( $atim_structure, array('links'=>$structure_links,'override'=>$structure_override) );
?>