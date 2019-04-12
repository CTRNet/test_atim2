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
 * Class StructurePermissibleValuesCustomControl
 */
class StructurePermissibleValuesCustomControl extends AppModel
{

    public $name = 'StructurePermissibleValuesCustomControl';

    public function getLink($data)
    {
        $link = "";
        if (strpos($data["source"], "StructurePermissibleValuesCustom::getCustomDropdown(") === 0){
            preg_match("/(StructurePermissibleValuesCustom::getCustomDropdown\()(.+)(\))/", $data["source"], $a);
            if (count($a) == 4){
                $a = substr($a[2], 1, strlen($a[2])-2);
                $id = $this->find("first", array(
                    'conditions' => array(
                        'StructurePermissibleValuesCustomControl.name' => $a
                    ),
                    'fields' => array(
                        "StructurePermissibleValuesCustomControl.id"
                    ) 
                ));
                $id = $id["StructurePermissibleValuesCustomControl"]["id"];
                $link =  "Administrate/Dropdowns/view/" .$id;
            }
        }
        return (empty($link)) ? $link : array("link" => $link, "text" => $a);
    }
    
}