<?php
$beastDxIntervention = $this->StructurePermissibleValuesCustom->getCustomDropdown(array(
    'DX : Type of intervention'
));
$beastDxIntervention = array_merge($beastDxIntervention['defined'], $beastDxIntervention['previously_defined']);

$beastDxProgressionSite = $this->StructurePermissibleValuesCustom->getCustomDropdown(array(
    'DX : Progressions Sites'
));
$beastDxProgressionSite = array_merge($beastDxProgressionSite['defined'], $beastDxProgressionSite['previously_defined']);

$otherDxProgressionSites = $this->StructurePermissibleValuesCustom->getCustomDropdown(array(
    'Other Cancer Progression Sites'
));
$otherDxProgressionSites = array_merge($otherDxProgressionSites['defined'], $otherDxProgressionSites['previously_defined']);

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

$otherCancerTx = $this->StructurePermissibleValuesCustom->getCustomDropdown(array(
    'Tx : Other Cancer Treatment'
));
$otherCancerTx = array_merge($otherCancerTx['defined'], $otherCancerTx['previously_defined']);

$qbcfDxLaterality = $this->StructurePermissibleValuesCustom->getCustomDropdown(array(
    'DX : Laterality'
));
$qbcfDxLaterality = array_merge($qbcfDxLaterality['defined'], $qbcfDxLaterality['previously_defined']);

$treatmentExtendModel = AppModel::getInstance('ClinicalAnnotation', 'TreatmentExtendMaster', true);
$this->ViewCollection = AppModel::getInstance('InventoryManagement', 'ViewCollection', true);

$healthStatus = $this->StructureValueDomain->find('first', array(
    'conditions' => array(
        'StructureValueDomain.domain_name' => 'health_status'
    ),
    'recursive' => 2
));
$healthStatusValues = array();
if ($healthStatus) {
    foreach ($healthStatus['StructurePermissibleValue'] as $newValue) {
        $healthStatusValues[$newValue['value']] = __($newValue['language_alias']);
    }
}