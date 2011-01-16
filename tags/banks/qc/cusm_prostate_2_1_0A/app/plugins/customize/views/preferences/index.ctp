<?php 
	$structure_links = array(
		'bottom'=>array(
			'edit'=>'/customize/preferences/edit'
		)
	);
	
	$structures->build( $atim_structure, array('type'=>'detail', 'links'=>$structure_links) );
?>