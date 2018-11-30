<?php
 /**
 *
 * ATiM - Advanced Tissue Management Application
 * Copyright (c) Canadian Tissue Repository Network (http://www.ctrnet.ca)
 *
 * Licensed under GNU General Public License
 * For full copyright and license information, please see the LICENSE.txt
 * Redistributions of files must retain the above copyright notice.
 *
 * @author        Canadian Tissue Repository Network <info@ctrnet.ca>
 * @copyright     Copyright (c) Canadian Tissue Repository Network (http://www.ctrnet.ca)
 * @link          http://www.ctrnet.ca
 * @since         ATiM v 2
 * @license       http://www.gnu.org/licenses  GNU General Public License
 */

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