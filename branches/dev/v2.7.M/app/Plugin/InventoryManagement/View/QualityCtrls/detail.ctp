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

// 1- QUALITY CONTROL DATA
$structureLinks = array(
    'index' => array(
        'detail' => '/InventoryManagement/AliquotMasters/detail/%%AliquotMaster.collection_id%%/%%AliquotMaster.sample_master_id%%/%%AliquotMaster.id%%',
        'delete' => '/InventoryManagement/QualityCtrls/deleteTestedAliquot/' . $atimMenuVariables['QualityCtrl.id'] . '/%%AliquotMaster.id%%/quality_controls_details/'
    ),
    'bottom' => array(
        'used aliquot' => '/InventoryManagement/AliquotMasters/detail/' . $atimMenuVariables['Collection.id'] . '/' . $atimMenuVariables['SampleMaster.id'] . '/' . $qualityCtrlData['QualityCtrl']['aliquot_master_id'],
        'edit' => '/InventoryManagement/QualityCtrls/edit/' . $atimMenuVariables['Collection.id'] . '/' . $atimMenuVariables['SampleMaster.id'] . '/' . $atimMenuVariables['QualityCtrl.id'] . '/',
        'delete' => '/InventoryManagement/QualityCtrls/delete/' . $atimMenuVariables['Collection.id'] . '/' . $atimMenuVariables['SampleMaster.id'] . '/' . $atimMenuVariables['QualityCtrl.id'] . '/'
    )
);
if (empty($qualityCtrlData['QualityCtrl']['aliquot_master_id']))
    unset($structureLinks['bottom']['used aliquot']);

$finalAtimStructure = $atimStructure;
$finalOptions = array(
    'data' => $qualityCtrlData,
    'links' => $structureLinks
);

if ($isFromTreeView) {
    $finalOptions['settings']['header'] = __('quality control');
}

// CUSTOM CODE
$hookLink = $this->Structures->hook();
if ($hookLink) {
    require ($hookLink);
}

// BUILD FORM
$this->Structures->build($finalAtimStructure, $finalOptions);