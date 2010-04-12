<?php

class StoragelayoutAppController extends AppController {	

	function beforeFilter() {
		parent::beforeFilter();
		$this->Auth->actionPath = 'controllers/Storagelayout/';
	} 
	 
	/**
	 * Inactivate the storage coordinate menu.
	 * 
	 * @param $atim_menu ATiM menu.
	 * 
	 * @return Modified ATiM menu.
	 * 
	 * @author N. Luc
	 * @since 2009-08-12
	 */
		 
	 function inactivateStorageCoordinateMenu($atim_menu) {
 		foreach($atim_menu as $menu_group_id => $menu_group) {
			foreach($menu_group as $menu_id => $menu_data) {
				if(strpos($menu_data['Menu']['use_link'], '/storagelayout/storage_coordinates/listAll/') !== false) {
					$atim_menu[$menu_group_id][$menu_id]['Menu']['allowed'] = 0;
					return $atim_menu;
				}
			}
 		}	
 		
 		return $atim_menu;
	 }	
	 
	/**
	 * Inactivate the storage layout menu.
	 * 
	 * @param $atim_menu ATiM menu.
	 * 
	 * @return Modified ATiM menu.
	 * 
	 * @author N. Luc
	 * @since 2009-08-12
	 */
		 
	 function inactivateStorageLayoutMenu($atim_menu) {
 		foreach($atim_menu as $menu_group_id => $menu_group) {
			foreach($menu_group as $menu_id => $menu_data) {
				if(strpos($menu_data['Menu']['use_link'], '/storagelayout/storage_masters/storageLayout/') !== false) {
					$atim_menu[$menu_group_id][$menu_id]['Menu']['allowed'] = 0;
					return $atim_menu;
				}
			}
 		}	
 		
 		return $atim_menu;
	}
}

?>