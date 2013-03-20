<?php 
	$structure_links = array(
		'bottom'=>array(
			'edit'=>'/Customize/Profiles/edit'
		)
	);
	
	$this->Structures->build( $atim_structure, array('type'=>'detail', 'links'=>$structure_links) );
?>