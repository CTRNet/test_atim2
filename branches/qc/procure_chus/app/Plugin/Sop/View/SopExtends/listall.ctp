<?php 

	$structure_links = array(
		'index'=>array(
			'detail'=>'/Sop/SopExtends/detail/'.$atim_menu_variables['SopMaster.id'].'/%%SopExtend.id%%/'
		),
		'bottom'=>array('add' => '/Sop/SopExtends/add/'.$atim_menu_variables['SopMaster.id'].'/')
	);
	
	$structure_override = array('SopExtend.material_id'=>$material_list);
	$this->Structures->build( $atim_structure, array('type'=>'index','links'=>$structure_links,'override'=>$structure_override) );
?>
