<?php 

	if(in_array($list_type, array('all', 'current'))) {
		
		$structure_links = array(
			'index'=>array('detail'=>'/Customize/Announcements/detail/%%Announcement.id%%')
		);
	
		// CUSTOM CODE
		$hook_link = $this->Structures->hook();
		if( $hook_link ) { require($hook_link); }
		
		$this->Structures->build( $atim_structure, array('links'=>$structure_links));
		
	} else {
		
		// --------- Lists with current announcements ----------------------------------------------------------------------------------------------
		
		$final_atim_structure = array();
		$final_options = array(
			'type' => 'detail',
			'links'	=> array(),
			'settings' => array(
					'header' => __('news', null),
					'actions'	=> false),
			'extras' => $this->Structures->ajaxIndex('Customize/Announcements/index/current')
		);
		
		$display_next_form = true;
		
		// CUSTOM CODE
		$hook_link = $this->Structures->hook('current');
		if( $hook_link ) {
			require($hook_link);
		}
		
		// BUILD FORM
		if($display_next_form) $this->Structures->build( $final_atim_structure, $final_options );
		
		// --------- Empty lists ----------------------------------------------------------------------------------------------
		
		$final_atim_structure = array();
		$final_options = array(
			'type' => 'detail',
			'links'	=> array(),
			'settings' => array(
					'header' => __('all', null),
					'actions'	=> true),
			'extras' => $this->Structures->ajaxIndex('Customize/Announcements/index/all')
		);
		
		$display_next_form = true;
		
		// CUSTOM CODE
		$hook_link = $this->Structures->hook('all');
		if( $hook_link ) {
			require($hook_link);
		}
		
		// BUILD FORM
		if($display_next_form) $this->Structures->build( $final_atim_structure, $final_options );
	
	}
	
?>