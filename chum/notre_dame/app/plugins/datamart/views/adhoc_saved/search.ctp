<?php 
		
	// display adhoc DETAIL
	
		$structures->build( $atim_structure_for_detail, array('type'=>'detail', 'settings'=>array('actions'=>false)) );
	
	// display adhoc SEARCH form
	
		// set bottom LINK based on FAVOURITE status
		$structure_links = array(
			'top' => '/datamart/adhoc_saved/results/'.$atim_menu_variables['Adhoc.id'].'/'.$atim_menu_variables['AdhocSaved.id'],
			'bottom'=>array(
				'edit'	=>'/datamart/adhoc_saved/edit/'.$atim_menu_variables['Adhoc.id'].'/'.$atim_menu_variables['AdhocSaved.id'],
				'delete'	=>'/datamart/adhoc_saved/delete/'.$atim_menu_variables['Adhoc.id'].'/'.$atim_menu_variables['AdhocSaved.id'],
				'cancel'	=>'/datamart/adhocs/index/saved'
			)
		);
		
		// Parse Saved info, and set as Form Override variable...
		
			$structure_overrides = array();
			
			$this->data['AdhocSaved']['search_params'] = explode('|', $this->data['AdhocSaved']['search_params']);
			
			foreach ( $this->data['AdhocSaved']['search_params'] as $override_set ) {
				$override_set = explode('=',$override_set);
				$structure_overrides[$override_set[0]] = $override_set[1];
			}
				
		$structures->build( $atim_structure_for_form, array('type'=>'search', 'links'=>$structure_links, 'override'=>$structure_overrides) );
	
?>