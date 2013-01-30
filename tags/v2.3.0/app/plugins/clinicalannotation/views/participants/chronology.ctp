<?php 
	$chronology['Accuracy']['custom']['date'] = 'date_accuracy';

	$final_atim_structure = $chronology;
	
	$links['index'] = array(array(
			'link' => '%%custom.link%%',
			'icon' => 'detail'
		)
	);
	
	$final_options = array('settings'=> array('pagination' => false), 'type' => 'index', 'links' => $links);
	
	$hook_link = $structures->hook();
	if( $hook_link ){
		require($hook_link); 
	}
	
	
	$structures->build($final_atim_structure, $final_options);
?>