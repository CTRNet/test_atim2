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
        'edit' => '/ClinicalAnnotation/TreatmentMasters/edit/' . $atimMenuVariables['Participant.id'] . '/' . $atimMenuVariables['TreatmentMaster.id'],
        'delete' => '/ClinicalAnnotation/TreatmentMasters/delete/' . $atimMenuVariables['Participant.id'] . '/' . $atimMenuVariables['TreatmentMaster.id']
    )
);

// TRT DATA

$structureSettings = array(
    'actions' => ($isAjax && ! isset($extendFormAlias)),
    'form_bottom' => ! ($isAjax && ! isset($extendFormAlias))
);

$structureOverride = array();

$finalOptions = array(
    'links' => $structureLinks,
    'settings' => $structureSettings,
    'override' => $structureOverride
);
$finalAtimStructure = $atimStructure;

$hookLink = $this->Structures->hook();
if ($hookLink) {
    require ($hookLink);
}

$this->Structures->build($finalAtimStructure, $finalOptions);

if (isset($extendFormAlias)) {
    $structureSettings = array(
        'pagination' => false,
        'actions' => $isAjax,
        ($isAjax ? 'language_heading' : 'header') => ($txExtendType ? __($txExtendType) : __('precision'))
    );
    
    $structureLinks['bottom']['add'][($txExtendType ? __($txExtendType) : __('add precision'))] = array(
        'link' => '/ClinicalAnnotation/TreatmentExtendMasters/add/' . $atimMenuVariables['Participant.id'] . '/' . $atimMenuVariables['TreatmentMaster.id'],
        'icon' => 'treatment precision'
    );
    if (isset($extendedDataImportProcess)) {
        $structureLinks['bottom']['add'][($txExtendType ? __($txExtendType) . ' (' . __('from associated protocol') . ')' : __('import precisions from associated protocol'))] = array(
            'link' => '/ClinicalAnnotation/TreatmentExtendMasters/' . $extendedDataImportProcess . '/' . $atimMenuVariables['Participant.id'] . '/' . $atimMenuVariables['TreatmentMaster.id'],
            'icon' => 'treatment precision'
        );
    }
    
    $structureLinks['index'] = array(
        'edit' => '/ClinicalAnnotation/TreatmentExtendMasters/edit/' . $atimMenuVariables['Participant.id'] . '/' . $atimMenuVariables['TreatmentMaster.id'] . '/%%TreatmentExtendMaster.id%%',
        'delete' => '/ClinicalAnnotation/TreatmentExtendMasters/delete/' . $atimMenuVariables['Participant.id'] . '/' . $atimMenuVariables['TreatmentMaster.id'] . '/%%TreatmentExtendMaster.id%%'
    );
    
    $finalOptions = array(
        'data' => $txExtendData,
        'type' => 'index',
        'settings' => $structureSettings,
        'links' => $structureLinks
    );
    $finalAtimStructure = $extendFormAlias;
    
    $displayNextSubForm = true;
    
    $hookLink = $this->Structures->hook('tx_extend_list');
    if ($hookLink) {
        require ($hookLink);
    }
    
    if ($displayNextSubForm)
        $this->Structures->build($finalAtimStructure, $finalOptions);
}

if (! $isAjax) {
    
    $flagUseForCcl = $this->data['TreatmentControl']['flag_use_for_ccl'];
    
    // DIAGNOSTICS
    
    $structureSettings = array(
        'form_inputs' => false,
        'pagination' => false,
        'actions' => $flagUseForCcl ? false : true,
        'form_bottom' => true,
        'header' => __('related diagnosis', null),
        'form_top' => false
    );
    
    $structureLinks['index'] = array(
        'detail' => '/ClinicalAnnotation/DiagnosisMasters/detail/%%DiagnosisMaster.participant_id%%/%%DiagnosisMaster.id%%'
    );
    
    $finalOptions = array(
        'data' => $diagnosisData,
        'type' => 'index',
        'settings' => $structureSettings,
        'links' => $structureLinks
    );
    $finalAtimStructure = $diagnosisStructure;
    
    if (! AppController::checkLinkPermission('/ClinicalAnnotation/DiagnosisMasters/listall')) {
        $finalOptions['type'] = 'detail';
        $finalAtimStructure = array();
        $finalOptions['extras'] = '<div>' . __('You are not authorized to access that location.') . '</div>';
    }
    
    $displayNextSubForm = true;
    
    $hookLink = $this->Structures->hook('dx_list');
    if ($hookLink) {
        require ($hookLink);
    }
    
    if ($displayNextSubForm)
        $this->Structures->build($finalAtimStructure, $finalOptions);
    
    $finalAtimStructure = array();
    $finalOptions['type'] = 'detail';
    $finalOptions['settings']['header'] = __('links to collections');
    $finalOptions['settings']['actions'] = true;
    $finalOptions['extras'] = $this->Structures->ajaxIndex('ClinicalAnnotation/ClinicalCollectionLinks/listall/' . $atimMenuVariables['Participant.id'] . '/noActions:/filterModel:TreatmentMaster/filterId:' . $atimMenuVariables['TreatmentMaster.id']);
    
    $displayNextSubForm = $flagUseForCcl ? true : false;
    
    $hookLink = $this->Structures->hook('ccl');
    if ($hookLink) {
        require ($hookLink);
    }
    
    if ($displayNextSubForm)
        $this->Structures->build(array(), $finalOptions);
}