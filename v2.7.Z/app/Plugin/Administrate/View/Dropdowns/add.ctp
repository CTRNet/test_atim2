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
$structureLinks = array(
    "top" => "/Administrate/Dropdowns/add/" . $controlData['StructurePermissibleValuesCustomControl']['id'] . "/",
    "bottom" => array(
        "cancel" => "/Administrate/Dropdowns/view/" . $controlData['StructurePermissibleValuesCustomControl']['id'] . "/"
    )
);
$structureOverride = array(
    'StructurePermissibleValuesCustom.use_as_input' => 1
);
$structureSettings = array(
    'pagination' => false,
    'add_fields' => true,
    'del_fields' => true,
    'header' => __('list') . ' : ' . $controlData['StructurePermissibleValuesCustomControl']['name']
);
$finalOptions = array(
    'links' => $structureLinks,
    'override' => $structureOverride,
    'type' => 'addgrid',
    'settings' => $structureSettings
);

$this->Structures->build($administrateDropdownValues, $finalOptions);