<?php
	$structure_links = array(
		'bottom'=>array(
			'list'=>'/Sop/SopExtends/listall/'.$atim_menu_variables['SopMaster.id'].'/',
			'edit'=>'/Sop/SopExtends/edit/'.$atim_menu_variables['SopMaster.id'].'/%%SopExtend.id%%/', 
			'delete'=>'/Sop/SopExtends/delete/'.$atim_menu_variables['SopMaster.id'].'/%%SopExtend.id%%/'
		)
	);
	
	$structure_override = array('SopExtend.material_id'=>$material_list);
	$this->Structures->build( $atim_structure, array('links'=>$structure_links,'override'=>$structure_override) );
?>