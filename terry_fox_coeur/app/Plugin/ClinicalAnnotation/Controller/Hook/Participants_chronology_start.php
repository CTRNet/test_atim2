<?php
$Drug = AppModel::getInstance("Drug", "Drug", true);
$allDrugs = $Drug->getDrugPermissibleValues();

$this->TreatmentExtendMaster = AppModel::getInstance("ClinicalAnnotation", "TreatmentExtendMaster", true);

$qcTfTumorSites = $this->StructureValueDomain->find('first', array(
    'conditions' => array(
        'StructureValueDomain.domain_name' => 'qc_tf_tumor_site'
    ),
    'recursive' => 2
));
$qcTfTumorSiteValues = array();
if ($qcTfTumorSites) {
    foreach ($qcTfTumorSites['StructurePermissibleValue'] as $newValue) {
        $qcTfTumorSiteValues[$newValue['value']] = __($newValue['language_alias']);
    }
}
$qcTfProgressionDetectionMethods = $this->StructureValueDomain->find('first', array(
    'conditions' => array(
        'StructureValueDomain.domain_name' => 'qc_tf_progression_detection_method'
    ),
    'recursive' => 2
));
$qcTfProgressionDetectionMethodValues = array();
if ($qcTfProgressionDetectionMethods) {
    foreach ($qcTfProgressionDetectionMethods['StructurePermissibleValue'] as $newValue) {
        $qcTfProgressionDetectionMethodValues[$newValue['value']] = __($newValue['language_alias']);
    }
}

$qcTfBiopsyContextsValues = $this->StructurePermissibleValuesCustom->getCustomDropdown(array(
    'Biopsy Sites'
));
$qcTfBiopsyContextsValues = array_merge($qcTfBiopsyContextsValues['defined'], $qcTfBiopsyContextsValues['previously_defined']);
$qcTfBiopsyContextsValues[''] = '';