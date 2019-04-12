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
    'bottom' => array(
        'edit' => '/InventoryManagement/SpecimenReviews/edit/' . $atimMenuVariables['Collection.id'] . '/' . $atimMenuVariables['SampleMaster.id'] . '/' . $atimMenuVariables['SpecimenReviewMaster.id'] . '/',
        'delete' => '/InventoryManagement/SpecimenReviews/delete/' . $atimMenuVariables['Collection.id'] . '/' . $atimMenuVariables['SampleMaster.id'] . '/' . $atimMenuVariables['SpecimenReviewMaster.id'] . '/'
    )
);

// 1- SPECIMEN REVIEW

$structureSettings = array(
    'actions' => ($isAliquotReviewDefined ? false : true),
    'form_bottom' => ($isAliquotReviewDefined ? false : true)
);

$finalAtimStructure = $specimenReviewStructure;
$finalOptions = array(
    'settings' => $structureSettings,
    'links' => $structureLinks,
    'data' => $specimenReviewData
);

if ($aliquotMasterIdFromTreeView) {
    $finalOptions['settings']['header'] = __('specimen review');
}

$hookLink = $this->Structures->hook('specimen_review');
if ($hookLink) {
    require ($hookLink);
}

$this->Structures->build($finalAtimStructure, $finalOptions);

if ($isAliquotReviewDefined) {
    // 2- SEPARATOR & HEADER
    
    $structureSettings = array(
        'actions' => false,
        
        'header' => __('aliquot review', null),
        'form_top' => false,
        'form_bottom' => false
    );
    
    $this->Structures->build($emptyStructure, array(
        'settings' => $structureSettings
    ));
    
    // 3- ALIQUOT REVIEW
    
    $structureSettings = array(
        'pagination' => false,
        'add_fields' => true,
        'del_fields' => true,
        'form_top' => false
    );
    
    $dropdownOptions = array();
    
    $finalAtimStructure = $aliquotReviewStructure;
    $finalOptions = array(
        'links' => $structureLinks,
        'data' => $aliquotReviewData,
        'type' => 'index',
        'settings' => $structureSettings,
        'dropdown_options' => $dropdownOptions
    );
    
    $hookLink = $this->Structures->hook('aliquot_review');
    if ($hookLink) {
        require ($hookLink);
    }
    
    $this->Structures->build($finalAtimStructure, $finalOptions);
}