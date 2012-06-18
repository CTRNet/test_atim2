<?php
	
	// SETTINGS
	
	$structure_settings = array(
		'tree'=>array(
			'AliquotMaster'	=> 'AliquotMaster'
		)
	);
	
	// LINKS
	$bottom = array();

	$structure_links = array(
		'tree'=>array(
			'AliquotMaster' => array(
				'detail' => array(
					'link' => '/InventoryManagement/AliquotMasters/detail/%%AliquotMaster.collection_id%%/%%AliquotMaster.sample_master_id%%/%%AliquotMaster.id%%/1/',
					'icon' => 'aliquot'
				),
				'access to all data' => array(
					'link'=> '/InventoryManagement/AliquotMasters/detail/%%AliquotMaster.collection_id%%/%%AliquotMaster.sample_master_id%%/%%AliquotMaster.id%%/' ,
					'icon' => 'detail'
				)
			)
		),
		'tree_expand' => array(
			'AliquotMaster' => '/InventoryManagement/AliquotMasters/contentTreeView/%%AliquotMaster.collection_id%%/%%AliquotMaster.id%%/1/',
		),
		'bottom' => $bottom,
		'ajax' => array(
			'index' => array(
				'detail' => array(
					'json' => array(
						'update' => 'frame',
						'callback' => 'set_at_state_in_tree_root'
					)
				)
			)
		)
	);
	
	// EXTRAS
	
	$structure_extras = array();
	$structure_extras[10] = '<div id="frame"></div>';	
	
	// BUILD
	
	$final_atim_structure = $atim_structure; 
	$final_options = array('type' => 'tree', 'settings'=>$structure_settings, 'links'=>$structure_links, 'extras'=>$structure_extras);
	
	// CUSTOM CODE
	$hook_link = $this->Structures->hook();
	if($hook_link){
		require($hook_link); 
	}
		
	// BUILD FORM
	$this->Structures->build($final_atim_structure, $final_options);	
	
