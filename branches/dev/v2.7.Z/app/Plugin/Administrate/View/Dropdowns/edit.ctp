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
    "top" => "/Administrate/Dropdowns/edit/" . $atimMenuVariables['StructurePermissibleValuesCustom.control_id'] . "/" . $atimMenuVariables['StructurePermissibleValuesCustom.id'] . "/",
    'bottom' => array(
        'cancel' => '/Administrate/Dropdowns/view/' . $atimMenuVariables['StructurePermissibleValuesCustom.control_id']
    )
);
$structureOverride = array();
$structureSettings = array(
    'header' => __('list') . ' : ' . $controlData['StructurePermissibleValuesCustomControl']['name']
);
$finalOptions = array(
    'links' => $structureLinks,
    'override' => $structureOverride,
    'type' => 'edit',
    'settings' => $structureSettings
);

$this->Structures->build($administrateDropdownValues, $finalOptions);