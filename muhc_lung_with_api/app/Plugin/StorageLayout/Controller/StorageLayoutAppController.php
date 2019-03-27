<?php

/**
 * Class StorageLayoutAppController
 */
class StorageLayoutAppController extends AppController
{

    /**
     * Inactivate the storage coordinate menu.
     *
     * @param $atimMenu ATiM menu.
     *       
     * @return Modified ATiM menu.
     *        
     * @author N. Luc
     * @since 2009-08-12
     */
    public function inactivateStorageCoordinateMenu($atimMenu)
    {
        foreach ($atimMenu as $menuGroupId => $menuGroup) {
            foreach ($menuGroup as $menuId => $menuData) {
                if (strpos($menuData['Menu']['use_link'], '/StorageLayout/StorageCoordinates/listAll/') !== false) {
                    $atimMenu[$menuGroupId][$menuId]['Menu']['allowed'] = 0;
                    return $atimMenu;
                }
            }
        }
        
        return $atimMenu;
    }

    /**
     * Inactivate the storage layout menu.
     *
     * @param $atimMenu ATiM menu.
     *       
     * @return Modified ATiM menu.
     *        
     * @author N. Luc
     * @since 2009-08-12
     */
    public function inactivateStorageLayoutMenu($atimMenu)
    {
        foreach ($atimMenu as $menuGroupId => $menuGroup) {
            foreach ($menuGroup as $menuId => $menuData) {
                if (strpos($menuData['Menu']['use_link'], '/StorageLayout/StorageMasters/storageLayout/') !== false) {
                    $atimMenu[$menuGroupId][$menuId]['Menu']['allowed'] = 0;
                    return $atimMenu;
                }
            }
        }
        
        return $atimMenu;
    }
}