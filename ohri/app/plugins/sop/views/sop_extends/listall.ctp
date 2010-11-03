<?php 

	$structure_links = array(
		'index'=>array(
			'detail'=>'/sop/sop_extends/detail/'.$atim_menu_variables['SopMaster.id'].'/%%SopExtend.id%%/'
		),
		'bottom'=>array('add' => '/sop/sop_extends/add/'.$atim_menu_variables['SopMaster.id'].'/')
	);
	
	$structure_override = array('SopExtend.material_id'=>$material_list);
	$structures->build( $atim_structure, array('type'=>'index','links'=>$structure_links,'override'=>$structure_override) );
?>
