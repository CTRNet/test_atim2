<?php
	$structure_links = array(
		'top'=>array('search'=>'/material/materials/search/'.AppController::getNewSearchId()),
		'bottom'=>array(
			'add'=>'/material/materials/add/'
		)
	);
	
	$this->Structures->build( $atim_structure, array('type'=>'search','links'=>$structure_links) );
?>