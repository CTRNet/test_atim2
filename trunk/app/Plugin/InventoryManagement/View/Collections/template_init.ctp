<?php
	ob_start();

	$structure_build_options = array(
		'type' => 'edit',
		'links' => array('top' => '/InventoryManagement/collections/templateInit/'.$collection_id.'/'.$template_id),
		'settings' => empty($template_init_structure['Sfs'])? 
			array(): 
			array('header' => array('title' => __('default values')),
		), 'extras' => $this->Form->input('template_init_id', array('type' => 'hidden', 'value' => $template_init_id, 'id' => false))
	);
	
	$hook_link = $this->Structures->hook();
	if( $hook_link ) { 
		require($hook_link); 
	}	
		
	$this->Structures->build($template_init_structure, $structure_build_options);
	
	$display = $this->Shell->validationHtml().ob_get_contents();
	ob_end_clean();
	$display = ob_get_contents().$display;
	ob_clean();
	$this->Shell->validationErrors = null;
	echo json_encode(array('goToNext' => isset($goToNext), 'display' => $display));
	