<?php
$this->set('addLinkForProcureForms', $this->Participant->buildAddProcureFormsButton($participantId));

$procureChronologyWarnings = array();

// *** Treatment ***

$procureTreatmentTypesValues = $this->StructurePermissibleValuesCustom->getCustomDropdown(array(
    'Treatment Types (PROCURE values only)'
));
$procureTreatmentTypesValues = array_merge($procureTreatmentTypesValues['defined'], $procureTreatmentTypesValues['previously_defined']);
$procureTreatmentTypesValues[''] = '';

$procureTreatmentPrecisionValues = $this->StructurePermissibleValuesCustom->getCustomDropdown(array(
    'Treatment Precisions (PROCURE values only)'
));
$procureTreatmentPrecisionValues = array_merge($procureTreatmentPrecisionValues['defined'], $procureTreatmentPrecisionValues['previously_defined']);
$procureTreatmentPrecisionValues[''] = '';

$procureTreatmentSiteValues = $this->StructurePermissibleValuesCustom->getCustomDropdown(array(
    'Treatment Sites (PROCURE values only)'
));
$procureTreatmentSiteValues = array_merge($procureTreatmentSiteValues['defined'], $procureTreatmentSiteValues['previously_defined']);
$procureTreatmentSiteValues[''] = '';

$procureSurgeryTypeValues = $this->StructurePermissibleValuesCustom->getCustomDropdown(array(
    'Surgery Types (PROCURE values only)'
));
$procureSurgeryTypeValues = array_merge($procureSurgeryTypeValues['defined'], $procureSurgeryTypeValues['previously_defined']);
$procureSurgeryTypeValues[''] = '';

// *** Clinical Exam ***

$procureExamTypesValues = $this->StructurePermissibleValuesCustom->getCustomDropdown(array(
    'Clinical Exam - Types (PROCURE values only)'
));
$procureExamTypesValues = array_merge($procureExamTypesValues['defined'], $procureExamTypesValues['previously_defined']);
$procureExamTypesValues[''] = '';

$procureExamResultsValues = $this->StructurePermissibleValuesCustom->getCustomDropdown(array(
    'Clinical Exam - Results (PROCURE values only)'
));
$procureExamResultsValues = array_merge($procureExamResultsValues['defined'], $procureExamResultsValues['previously_defined']);
$procureExamResultsValues[''] = '';

$clinicalExamSiteValues = $this->StructurePermissibleValuesCustom->getCustomDropdown(array(
    'Clinical Exam - Sites (PROCURE values only)'
));
$clinicalExamSiteValues = array_merge($clinicalExamSiteValues['defined'], $clinicalExamSiteValues['previously_defined']);
$clinicalExamSiteValues[''] = '';

$procureProgressionsComorbiditiesValues = $this->StructurePermissibleValuesCustom->getCustomDropdown(array(
    'Progressions & Comorbidities (PROCURE values only)'
));
$procureProgressionsComorbiditiesValues = array_merge($procureProgressionsComorbiditiesValues['defined'], $procureProgressionsComorbiditiesValues['previously_defined']);
$procureProgressionsComorbiditiesValues[''] = '';

// *** Other Tumor ***

$procureOtherTumorSites = $this->StructureValueDomain->find('first', array(
    'conditions' => array(
        'StructureValueDomain.domain_name' => 'procure_other_tumor_sites'
    ),
    'recursive' => 2
));
$procureOtherTumorSitesValues = array();
if ($procureOtherTumorSites) {
    foreach ($procureOtherTumorSites['StructurePermissibleValue'] as $newValue) {
        $procureOtherTumorSitesValues[$newValue['value']] = __($newValue['language_alias']);
    }
}
$procureOtherTumorSitesValues[''] = '';

// *** Clinical Note ***

$procureEventNoteTypeValues = $this->StructurePermissibleValuesCustom->getCustomDropdown(array(
    'Clinical Note Types'
));
$procureEventNoteTypeValues = array_merge($procureEventNoteTypeValues['defined'], $procureEventNoteTypeValues['previously_defined']);
$procureEventNoteTypeValues[''] = '';