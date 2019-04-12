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
    'top' => null,
    'bottom' => array(
        'edit' => '/InventoryManagement/AliquotMasters/editAliquotInternalUse/' . $atimMenuVariables['AliquotMaster.id'] . '/%%AliquotInternalUse.id%%/',
        'delete' => '/InventoryManagement/AliquotMasters/deleteAliquotInternalUse/' . $atimMenuVariables['AliquotMaster.id'] . '/%%AliquotInternalUse.id%%/'
    )
);

$structureSettings = array(
    'header' => __('aliquot use/event', null)
);

// Set form structure and option
$finalAtimStructure = $atimStructure;
$finalOptions = array(
    'links' => $structureLinks,
    'type' => 'detail',
    'settings' => $structureSettings
);

// CUSTOM CODE
$hookLink = $this->Structures->hook();
if ($hookLink) {
    require ($hookLink);
}

// BUILD FORM
$this->Structures->build($finalAtimStructure, $finalOptions);