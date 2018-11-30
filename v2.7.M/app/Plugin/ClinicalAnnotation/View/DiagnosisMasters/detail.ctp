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
        'edit' => '/ClinicalAnnotation/DiagnosisMasters/edit/%%DiagnosisMaster.participant_id%%/%%DiagnosisMaster.id%%/',
        'delete' => '/ClinicalAnnotation/DiagnosisMasters/delete/%%DiagnosisMaster.participant_id%%/%%DiagnosisMaster.id%%/',
        'redefine unknown primary' => '/underdevelopment/'
    )
);
if (in_array($this->data['DiagnosisControl']['category'], array(
    'primary',
    'secondary - distant'
))) {
    $structureLinks['bottom']['add'] = 'javascript:addPopup(' . $this->data['DiagnosisMaster']['id'] . ', ' . $this->data['DiagnosisControl']['id'] . ');';
}

if (isset($primaryCtrlToRedefineUnknown) && ! empty($primaryCtrlToRedefineUnknown)) {
    $redefineLinks = array();
    foreach ($primaryCtrlToRedefineUnknown as $diagnosisControl) {
        $redefineLinks[__($diagnosisControl['DiagnosisControl']['controls_type'])] = '/ClinicalAnnotation/DiagnosisMasters/edit/%%DiagnosisMaster.participant_id%%/%%DiagnosisMaster.id%%/' . $diagnosisControl['DiagnosisControl']['id'];
    }
    ksort($redefineLinks);
    $structureLinks['bottom']['redefine unknown primary'] = $redefineLinks;
} else {
    unset($structureLinks['bottom']['redefine unknown primary']);
}

// Set form structure and option
$finalAtimStructure = $atimStructure;
$finalOptions = array(
    'links' => $structureLinks,
    'settings' => array(
        'actions' => $isAjax
    )
);

// CUSTOM CODE
$hookLink = $this->Structures->hook();
if ($hookLink) {
    require ($hookLink);
}

// BUILD FORM
$this->Structures->build($finalAtimStructure, $finalOptions);

if (! $isAjax) {
    $finalAtimStructure = array();
    $finalOptions['settings']['header'] = __('links to collections');
    $finalOptions['settings']['actions'] = true;
    $finalOptions['extras'] = $this->Structures->ajaxIndex('ClinicalAnnotation/ClinicalCollectionLinks/listall/' . $atimMenuVariables['Participant.id'] . '/noActions:/filterModel:DiagnosisMaster/filterId:' . $atimMenuVariables['DiagnosisMaster.id']);
    
    $hookLink = $this->Structures->hook('ccl');
    if ($hookLink) {
        require ($hookLink);
    }
    
    $this->Structures->build(array(), $finalOptions);
    
    require ('add_popup.php');
}