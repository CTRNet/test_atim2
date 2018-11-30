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
if (isset($derivativesData)) {
    $structureLinks = array();
    $structureLinks['index']['detail'] = '/InventoryManagement/SampleMasters/detail/%%Collection.id%%/%%SampleMaster.id%%';
    $structureLinks['index']['edit'] = '/InventoryManagement/SampleMasters/edit/%%Collection.id%%/%%SampleMaster.id%%';
    $structureLinks['index']['delete'] = '/InventoryManagement/SampleMasters/delete/%%Collection.id%%/%%SampleMaster.id%%';
    
    $hookLink = $this->Structures->hook();
    if ($hookLink) {
        require ($hookLink);
    }
    
    $i = 0;
    $arrSize = count($derivativesData);
    $hookLink = $this->Structures->hook('unit');
    foreach ($derivativesData as $sampleControlId => $derivatives) {
        $finalAtimStructure = $derivativesStructures[$sampleControlId];
        $finalOptions = array(
            'type' => 'index',
            'links' => $structureLinks,
            'dropdown_options' => array(),
            'data' => $derivatives,
            'settings' => array(
                'language_heading' => __($derivatives[0]['SampleControl']['sample_type']),
                'header' => array(),
                'actions' => ++ $i == $arrSize,
                'pagination' => false
            )
        );
        
        // CUSTOM CODE
        if ($hookLink) {
            require ($hookLink);
        }
        
        // BUILD FORM
        $this->Structures->build($finalAtimStructure, $finalOptions);
    }
} else {
    
    // Display empty form
    
    $finalAtimStructure = $noDataStructure;
    $finalOptions = array(
        'type' => 'index',
        'data' => array(),
        'settings' => array(
            'pagination' => false
        )
    );
    
    // CUSTOM CODE
    $hookLink = $this->Structures->hook('empty');
    if ($hookLink) {
        require ($hookLink);
    }
    
    // BUILD FORM
    $this->Structures->build($finalAtimStructure, $finalOptions);
}