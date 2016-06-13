<?php

class StorageLayoutAppController extends AppController {	

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
				if(strpos($menu_data['Menu']['use_link'], '/StorageLayout/StorageCoordinates/listAll/') !== false) {
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
				if(strpos($menu_data['Menu']['use_link'], '/StorageLayout/StorageMasters/storageLayout/') !== false) {
					$atim_menu[$menu_group_id][$menu_id]['Menu']['allowed'] = 0;
					return $atim_menu;
				}
			}
 		}	
 		
 		return $atim_menu;
	}
}

?>