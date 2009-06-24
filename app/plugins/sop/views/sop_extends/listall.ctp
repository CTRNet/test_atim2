<?php 

	$structure_links = array(
		'index'=>array(
			'detail'=>'/sop/sop_extends/detail/'.$atim_menu_variables['SopMaster.id'].'/%%SopExtend.id%%/'
		),
		'bottom'=>array('add' => '/sop/sop_extends/add/'.$atim_menu_variables['SopMaster.id'].'/')
	);
	
	$structures->build( $atim_structure, array('type'=>'index','links'=>$structure_links) );
?>
