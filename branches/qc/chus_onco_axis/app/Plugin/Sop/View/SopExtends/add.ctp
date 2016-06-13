<?php
	$structure_links = array(
		'top'=>'/Sop/SopExtends/add/'.$atim_menu_variables['SopMaster.id'].'/',
		'bottom'=>array(
			'cancel'=>'/Sop/SopExtends/listall/'.$atim_menu_variables['SopMaster.id'].'/'
		)
	);
	
	$structure_override = array('SopExtend.material_id'=>$material_list);
	$this->Structures->build( $atim_structure, array('links'=>$structure_links,'override'=>$structure_override) );
?>