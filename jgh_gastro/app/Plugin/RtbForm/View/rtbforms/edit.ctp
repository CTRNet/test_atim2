<?php 
	$structure_links = array(
		'top'=>'/rtbform/rtbforms/edit/'.$atim_menu_variables['Rtbform.id'],
		'bottom'=>array(
			'cancel'=>'/rtbform/rtbforms/profile/'.$atim_menu_variables['Rtbform.id']
		)
	);
	
	$this->Structures->build( $atim_structure, array('links'=>$structure_links) );
?>