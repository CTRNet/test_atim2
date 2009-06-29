<?php 
		
	// display adhoc DETAIL
	
		$structures->build( $atim_structure_for_detail, array('type'=>'detail') );
	
	// display adhoc SEARCH form
	
		// set bottom LINK based on FAVOURITE status
		
			if ( $atim_menu_variables['Param.Type_Of_List']=='favourites' ) {
				$structure_links = array(
					'top' => '/datamart/adhocs/results/favourites/',
					'bottom'=>array(
						'remove as favourite'=>'/datamart/adhocs/unfavourite/'.$atim_menu_variables['Adhoc.id'], 
						'cancel'=>'/datamart/adhocs/index/favourites/'
					)
				);
			} else {
				$structure_links = array(
					'top' => '/datamart/adhocs/results/favourites/',
					'bottom'=>array(
						'remove as favourite'=>'/datamart/adhocs/favourite/'.$atim_menu_variables['Adhoc.id'], 
						'cancel'=>'/datamart/adhocs/index/favourites/'
					)
				);
			}
		
		// if a SAVED Adhoc query...
		
			$structure_overrides = array();
			if ( $atim_menu_variables['Param.Type_Of_List']=='saved' && count($this->data['AdhocSaved']) ) {
				
				// Parse Saved info, and set as Form Override variable...
				$this->data['AdhocSaved'][0]['search_params'] = explode('|', $this->data['AdhocSaved'][0]['search_params']);
				foreach ( $this->data['AdhocSaved'][0]['search_params'] as $override_set ) {
					$override_set = explode('=',$override_set);
					$structure_overrides[$override_set[0]] = $override_set[1];
				}
			}
				
		$structures->build( $atim_structure_for_form, array('type'=>'search', 'links'=>$structure_links, 'override'=>$structure_overrides) );
	
?>