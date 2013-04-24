<?php 
		
	// display adhoc SEARCH form
	
		// set bottom LINK based on FAVOURITE status
			
			if ( count($data_for_detail['AdhocFavourite']) ) {
				$structure_links = array(
					'top' => '/datamart/adhocs/results/'.$atim_menu_variables['Param.Type_Of_List'].'/'.$atim_menu_variables['Adhoc.id'],
					'bottom'=>array(
						'reload form'=>array('icon' => 'redo', 'link'=> '/datamart/adhocs/search/'.$atim_menu_variables['Param.Type_Of_List'].'/'.$atim_menu_variables['Adhoc.id']),
						'remove as favourite'=>'/datamart/adhocs/unfavourite/'.$atim_menu_variables['Param.Type_Of_List'].'/'.$atim_menu_variables['Adhoc.id'], 
						'queries list'=>array('icon' => 'list', 'link'=> '/datamart/adhocs/index/'.$atim_menu_variables['Param.Type_Of_List'])
					)
				);
			} else {
				$structure_links = array(
					'top' => '/datamart/adhocs/results/'.$atim_menu_variables['Param.Type_Of_List'].'/'.$atim_menu_variables['Adhoc.id'],
					'bottom'=>array(
						'reload form'=> array('icon' => 'redo', 'link'=> '/datamart/adhocs/search/'.$atim_menu_variables['Param.Type_Of_List'].'/'.$atim_menu_variables['Adhoc.id']),
						'add as favourite'=>'/datamart/adhocs/favourite/'.$atim_menu_variables['Param.Type_Of_List'].'/'.$atim_menu_variables['Adhoc.id'], 
						'queries list'=> array('icon' => 'list', 'link'=> '/datamart/adhocs/index/'.$atim_menu_variables['Param.Type_Of_List'])
					)
				);
			}
		
		$structures->build( $atim_structure_for_form, array('type'=>'search', 'links'=>$structure_links) );
	
?>