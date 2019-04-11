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
    'bottom' => array(
        'edit' => '/labbook/LabBookMasters/edit/' . $atimMenuVariables['LabBookMaster.id'],
        'delete' => '/labbook/LabBookMasters/delete/' . $atimMenuVariables['LabBookMaster.id']
    )
);
$structureOverride = array();
$settings = array();

if ($fullDetailScreen) {
    $settings['actions'] = false;
    $structureLinks['bottom'] = array_merge(array(
        'edit synchronization option' => '/labbook/LabBookMasters/editSynchOptions/' . $atimMenuVariables['LabBookMaster.id']
    ), $structureLinks['bottom']);
}

$finalAtimStructure = $atimStructure;
$finalOptions = array(
    'links' => $structureLinks,
    'override' => $structureOverride,
    'settings' => $settings
);

$hookLink = $this->Structures->hook();
if ($hookLink) {
    require ($hookLink);
}

$this->Structures->build($finalAtimStructure, $finalOptions);

if ($fullDetailScreen) {
    
    // DERIVATIVE DETAILS
    
    $structureLinks['index'] = array(
        'sample' => array(
            'link' => '/InventoryManagement/SampleMasters/detail/%%SampleMaster.collection_id%%/%%SampleMaster.id%%',
            'icon' => 'flask'
        )
    );
    $structureOverride = array();
    $settings = array(
        'header' => __('derivative', null),
        'actions' => false,
        'pagination' => false
    );
    
    $finalAtimStructure = $labBookDerivativesSummary;
    $finalOptions = array(
        'type' => 'index',
        'links' => $structureLinks,
        'override' => $structureOverride,
        'data' => $derivativesList,
        'settings' => $settings
    );
    
    $hookLink = $this->Structures->hook('derivatives');
    if ($hookLink) {
        require ($hookLink);
    }
    
    $this->Structures->build($finalAtimStructure, $finalOptions);
    
    // REALIQUOTING
    
    $structureLinks['index'] = array(
        'sample' => array(
            'link' => '/InventoryManagement/SampleMasters/detail/%%SampleMaster.collection_id%%/%%SampleMaster.id%%',
            'icon' => 'flask'
        ),
        'parent aliquot' => array(
            'link' => '/InventoryManagement/AliquotMasters/detail/%%AliquotMaster.collection_id%%/%%AliquotMaster.sample_master_id%%/%%AliquotMaster.id%%',
            'icon' => 'aliquot'
        )
    );
    
    $structureOverride = array();
    $settings = array(
        'header' => __('realiquoting', null),
        'pagination' => false
    );
    
    $finalAtimStructure = $labBookRealiquotingsSummary;
    $finalOptions = array(
        'type' => 'index',
        'links' => $structureLinks,
        'override' => $structureOverride,
        'data' => $realiquotingsList,
        'settings' => $settings
    );
    
    $hookLink = $this->Structures->hook('derivatives');
    if ($hookLink) {
        require ($hookLink);
    }
    
    $this->Structures->build($finalAtimStructure, $finalOptions);
}