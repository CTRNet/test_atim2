<?php
$atimStructure['DiagnosisMaster'] = $this->Structures->get('form', 'view_diagnosis,qbcf_view_diagnosis');
$this->set('atimStructure', $atimStructure);

App::uses('StructureValueDomain', 'Model');
$this->StructureValueDomain = new StructureValueDomain();
$ctrnetSubmissionDiseaseSite = $this->StructureValueDomain->find('first', array(
    'conditions' => array(
        'StructureValueDomain.domain_name' => 'ctrnet_submission_disease_site'
    ),
    'recursive' => 2
));
$ctrnetSubmissionDiseaseSiteValues = array();
if ($ctrnetSubmissionDiseaseSite) {
    foreach ($ctrnetSubmissionDiseaseSite['StructurePermissibleValue'] as $newValue) {
        $ctrnetSubmissionDiseaseSiteValues[$newValue['value']] = __($newValue['language_alias']);
    }
}

$StructurePermissibleValuesCustomModel = AppModel::getInstance('', 'StructurePermissibleValuesCustom', true);
$qbcfDiagnosisProgressionSites = $StructurePermissibleValuesCustomModel->getCustomDropdown(array(
    'DX : Progressions Sites'
));
$qbcfDiagnosisProgressionSites = array_merge($qbcfDiagnosisProgressionSites['defined'], $qbcfDiagnosisProgressionSites['previously_defined']);
$qbcfOtherCancerProgressionSites = $StructurePermissibleValuesCustomModel->getCustomDropdown(array(
    'Other Cancer Progression Sites'
));
$qbcfOtherCancerProgressionSites = array_merge($qbcfOtherCancerProgressionSites['defined'], $qbcfOtherCancerProgressionSites['previously_defined']);

foreach ($this->request->data as &$tmpDxData) {
    switch ($tmpDxData['DiagnosisControl']['controls_type']) {
        case 'breast':
            break;
        case 'breast progression':
            $tmpDxData['Generated']['qbcf_dx_detail_for_tree_view'] = $qbcfDiagnosisProgressionSites[$tmpDxData['DiagnosisDetail']['site']];
            break;
        case 'other cancer':
            $tmpDxData['Generated']['qbcf_dx_detail_for_tree_view'] = $ctrnetSubmissionDiseaseSiteValues[$tmpDxData['DiagnosisDetail']['disease_site']];
            break;
        case 'other cancer progression':
            $tmpDxData['Generated']['qbcf_dx_detail_for_tree_view'] = $qbcfOtherCancerProgressionSites[$tmpDxData['DiagnosisDetail']['secondary_disease_site']];
            break;
        default:
            $tmpDxData['Generated']['qbcf_dx_detail_for_tree_view'] = '';
    }
}

$atimStructure['TreatmentMaster'] = $this->Structures->get('form', 'treatmentmasters,chus_tx_for_dx_tree_view');
$this->set('atimStructure', $atimStructure);