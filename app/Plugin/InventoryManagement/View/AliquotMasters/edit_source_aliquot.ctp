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
    'top' => '/InventoryManagement/AliquotMasters/editSourceAliquot/' . $atimMenuVariables['SampleMaster.id'] . '/' . $atimMenuVariables['AliquotMaster.id'] . '/',
    'bottom' => array(
        'cancel' => '/InventoryManagement/SampleMasters/detail/' . $atimMenuVariables['Collection.id'] . '/' . $atimMenuVariables['SampleMaster.id']
    )
);

if (! $showSubmitButton)
    unset($structureLinks['top']);

$finalAtimStructure = $atimStructure;
$finalOptions = array(
    'type' => 'edit',
    'links' => $structureLinks,
    'settings' => array(
        'header' => __('listall source aliquots')
    )
);

// CUSTOM CODE
$hookLink = $this->Structures->hook();
if ($hookLink) {
    require ($hookLink);
}

// BUILD FORM
$this->Structures->build($finalAtimStructure, $finalOptions);