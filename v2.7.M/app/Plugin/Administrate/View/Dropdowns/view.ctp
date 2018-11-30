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
$links = array(
    "bottom" => array(
        "add" => "/Administrate/Dropdowns/add/" . $controlData['StructurePermissibleValuesCustomControl']['id'] . "/",
        "configure" => "/Administrate/Dropdowns/configure/" . $controlData['StructurePermissibleValuesCustomControl']['id'] . "/"
    ),
    'index' => array(
        'edit' => '/Administrate/Dropdowns/edit/' . $controlData['StructurePermissibleValuesCustomControl']['id'] . '/%%StructurePermissibleValuesCustom.id%%'
    )
);
$structureSettings = array(
    "pagination" => false,
    'header' => __('list') . ' : ' . $controlData['StructurePermissibleValuesCustomControl']['name']
);
$finalOptions = array(
    "type" => "index",
    "data" => $this->request->data,
    "links" => $links,
    "settings" => $structureSettings
);

$this->Structures->build($administrateDropdownValues, $finalOptions);