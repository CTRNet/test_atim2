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
    'top' => '/ClinicalAnnotation/DiagnosisMasters/add/' . $atimMenuVariables['Participant.id'] . '/' . $atimMenuVariables['tableId'] . '/' . $atimMenuVariables['DiagnosisMaster.parent_id'] . '/',
    'bottom' => array(
        'cancel' => '/ClinicalAnnotation/DiagnosisMasters/listall/' . $atimMenuVariables['Participant.id'] . '/'
    )
);

// 1- DIAGNOSTIC DATA

$structureSettings = array(
    'tabindex' => 100,
    'header' => __('new ' . $dxCtrl['DiagnosisControl']['category']) . ' : ' . __($dxCtrl['DiagnosisControl']['controls_type'], null)
);

$structureOverride = array();
if ($dxCtrl['DiagnosisControl']['id'] == 15) {
    // unknown primary, add a disease code
    $structureOverride['DiagnosisMaster.icd10_code'] = 'D489';
}

$finalAtimStructure = $atimStructure;
$finalOptions = array(
    'links' => $structureLinks,
    'settings' => $structureSettings,
    'override' => $structureOverride
);

$hookLink = $this->Structures->hook();
if ($hookLink) {
    require ($hookLink);
}

$this->Structures->build($finalAtimStructure, $finalOptions);