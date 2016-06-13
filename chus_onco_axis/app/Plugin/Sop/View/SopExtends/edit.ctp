<?php
	$structure_links = array(
		'top'=>'/Sop/SopExtends/edit/'.$atim_menu_variables['SopMaster.id'].'/%%SopExtend.id%%/',
		'bottom'=>array(
			'delete'=>'/Sop/SopExtends/delete/'.$atim_menu_variables['SopMaster.id'].'/%%SopExtend.id%%/',
			'cancel'=>'/Sop/SopExtends/detail/'.$atim_menu_variables['SopMaster.id'].'/%%SopExtend.id%%/'
		)
	);
	
	$structure_override = array('SopExtend.material_id'=>$material_list);
	$this->Structures->build( $atim_structure, array('links'=>$structure_links) );
?>