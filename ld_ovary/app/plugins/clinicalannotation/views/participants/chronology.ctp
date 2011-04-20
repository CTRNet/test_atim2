<?php 
	$final_atim_structure = $chronology;
	$final_options = array('settings'=> array('pagination' => false), 'type' => 'index');
	
	$hook_link = $structures->hook();
	if( $hook_link ){
		require($hook_link); 
	}
	
	$structures->build($final_atim_structure, $final_options);
?>