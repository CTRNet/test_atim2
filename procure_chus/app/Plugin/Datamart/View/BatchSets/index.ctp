<?php 

	if($type_of_list) {
		
		// Specific batch sets list
		
		$structure_links = array(
			'index'=>array(
				'detail'=> '/Datamart/BatchSets/listall/%%BatchSet.id%%',
				'edit'	=> '/Datamart/BatchSets/edit/%%BatchSet.id%%',
				'save'	=> array('link' => '/Datamart/BatchSets/save/%%BatchSet.id%%', 'icon' => 'disk'),
				'delete'=> '/Datamart/BatchSets/delete/%%BatchSet.id%%'
			),
			'bottom'=>array()
		);
		
		$final_atim_structure = $atim_structure;
		$final_options = array(
			'type' => 'index',
			'links' => $structure_links,
			'settings'	=> array('pagination' => true, 'actions' => false),
			'override'=> array()
		);
		
		$hook_link = $this->Structures->hook('specific');
		if($hook_link){
			require($hook_link);
		}
		
		$this->Structures->build($final_atim_structure, $final_options);
		
	} else {
		
		// Manage list display
		
		$structure_links = array(
			'index'=>array(),
			'bottom'=>array(
				'delete in batch' => array('link' => '/Datamart/BatchSets/deleteInBatch', 'icon' => 'delete noPrompt')
			)
		);
		
		$list_data = array(
			'temporary' => 'temporary batch sets', 
			'saved' => 'saved batch sets', 
			'group' => 'group batch sets', 
			'all' => 'all batch sets'
		);
		
		$counter = 0;
		foreach($list_data as $type_of_list => $header) {
			$counter++;
			
			$final_atim_structure = array();
			$final_options = array(
				'type' => 'detail',
				'links'	=> $structure_links,
				'settings' => array(
					'header' => __($header, null),
					'actions'	=> ($counter == sizeof($list_data))? true : false),
				'extras' => $this->Structures->ajaxIndex('Datamart/BatchSets/index/'.$type_of_list)
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
		
	}
