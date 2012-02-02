<?php 
	$chronology['Accuracy']['custom']['date'] = 'date_accuracy';

	$final_atim_structure = $chronology;
	
	$links = array(
		'index' => array(
			'access to data' => array(
				'link' => '%%custom.link%%',
				'icon' => 'detail'
			), 'view data' => array(
				'link' => '%%custom.link%%',
				'icon' => 'jsChronology'
			)
		)
	);
	
	$final_options = array(
		'settings'=> array('pagination' => false), 
		'type' => 'index', 
		'links' => $links, 
		'extras' => array(10 => '<div id="frame">vive mich</div>')
	);
	
	$hook_link = $this->Structures->hook();
	if( $hook_link ){
		require($hook_link); 
	}
	
	
	$this->Structures->build($final_atim_structure, $final_options);
?>