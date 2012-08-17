<?php 
		
	// display adhoc SEARCH form
	
		// set bottom LINK based on FAVOURITE status
			
			if ( count($data_for_detail['AdhocFavourite']) ) {
				$structure_links = array(
					'top' => '/Datamart/adhocs/results/'.$atim_menu_variables['Param.Type_Of_List'].'/'.$atim_menu_variables['Adhoc.id'],
					'bottom'=>array(
						'reload form'=>array('icon' => 'redo', 'link'=> '/Datamart/adhocs/search/'.$atim_menu_variables['Param.Type_Of_List'].'/'.$atim_menu_variables['Adhoc.id']),
						'remove as favourite'=>'/Datamart/adhocs/unfavourite/'.$atim_menu_variables['Param.Type_Of_List'].'/'.$atim_menu_variables['Adhoc.id'], 
						'queries list'=>array('icon' => 'list', 'link'=> '/Datamart/adhocs/index/'.$atim_menu_variables['Param.Type_Of_List'])
					)
				);
			} else {
				$structure_links = array(
					'top' => '/Datamart/adhocs/results/'.$atim_menu_variables['Param.Type_Of_List'].'/'.$atim_menu_variables['Adhoc.id'],
					'bottom'=>array(
						'reload form'=> array('icon' => 'redo', 'link'=> '/Datamart/adhocs/search/'.$atim_menu_variables['Param.Type_Of_List'].'/'.$atim_menu_variables['Adhoc.id']),
						'add as favourite'=>'/Datamart/adhocs/favourite/'.$atim_menu_variables['Param.Type_Of_List'].'/'.$atim_menu_variables['Adhoc.id'], 
						'queries list'=> array('icon' => 'list', 'link'=> '/Datamart/adhocs/index/'.$atim_menu_variables['Param.Type_Of_List'])
					)
				);
			}
		
		$this->Structures->build( $atim_structure_for_form, array('type'=>'search', 'links'=>$structure_links) );
	
?>