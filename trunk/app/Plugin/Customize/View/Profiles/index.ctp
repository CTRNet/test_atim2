<?php 
	$structure_links = array(
		'bottom'=>array(
			'edit'=>'/Customize/profiles/edit'
		)
	);
	
	$this->Structures->build( $atim_structure, array('type'=>'detail', 'links'=>$structure_links) );
?>