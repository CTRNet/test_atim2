<?php
$this->set('add_link_for_procure_forms', $this->Participant->buildAddProcureFormsButton($participant_id));

$procure_chronology_warnings = array();

// *** Treatment ***

$procure_treatment_types_values = $this->StructurePermissibleValuesCustom->getCustomDropdown(array(
    'Treatment Types (PROCURE values only)'
));
$procure_treatment_types_values = array_merge($procure_treatment_types_values['defined'], $procure_treatment_types_values['previously_defined']);
$procure_treatment_types_values[''] = '';

$procure_treatment_precision_values = $this->StructurePermissibleValuesCustom->getCustomDropdown(array(
    'Treatment Precisions (PROCURE values only)'
));
$procure_treatment_precision_values = array_merge($procure_treatment_precision_values['defined'], $procure_treatment_precision_values['previously_defined']);
$procure_treatment_precision_values[''] = '';

$procure_treatment_site_values = $this->StructurePermissibleValuesCustom->getCustomDropdown(array(
    'Treatment Sites (PROCURE values only)'
));
$procure_treatment_site_values = array_merge($procure_treatment_site_values['defined'], $procure_treatment_site_values['previously_defined']);
$procure_treatment_site_values[''] = '';

$procure_surgery_type_values = $this->StructurePermissibleValuesCustom->getCustomDropdown(array(
    'Surgery Types (PROCURE values only)'
));
$procure_surgery_type_values = array_merge($procure_surgery_type_values['defined'], $procure_surgery_type_values['previously_defined']);
$procure_surgery_type_values[''] = '';

// *** Clinical Exam ***

$procure_exam_types_values = $this->StructurePermissibleValuesCustom->getCustomDropdown(array(
    'Clinical Exam - Types (PROCURE values only)'
));
$procure_exam_types_values = array_merge($procure_exam_types_values['defined'], $procure_exam_types_values['previously_defined']);
$procure_exam_types_values[''] = '';

$procure_exam_results_values = $this->StructurePermissibleValuesCustom->getCustomDropdown(array(
    'Clinical Exam - Results (PROCURE values only)'
));
$procure_exam_results_values = array_merge($procure_exam_results_values['defined'], $procure_exam_results_values['previously_defined']);
$procure_exam_results_values[''] = '';

$clinical_exam_site_values = $this->StructurePermissibleValuesCustom->getCustomDropdown(array(
    'Clinical Exam - Sites (PROCURE values only)'
));
$clinical_exam_site_values = array_merge($clinical_exam_site_values['defined'], $clinical_exam_site_values['previously_defined']);
$clinical_exam_site_values[''] = '';

$procure_progressions_comorbidities_values = $this->StructurePermissibleValuesCustom->getCustomDropdown(array(
    'Progressions & Comorbidities (PROCURE values only)'
));
$procure_progressions_comorbidities_values = array_merge($procure_progressions_comorbidities_values['defined'], $procure_progressions_comorbidities_values['previously_defined']);
$procure_progressions_comorbidities_values[''] = '';

// *** Other Tumor ***

$procure_other_tumor_sites = $this->StructureValueDomain->find('first', array(
    'conditions' => array(
        'StructureValueDomain.domain_name' => 'procure_other_tumor_sites'
    ),
    'recursive' => 2
));
$procure_other_tumor_sites_values = array();
if ($procure_other_tumor_sites) {
    foreach ($procure_other_tumor_sites['StructurePermissibleValue'] as $new_value) {
        $procure_other_tumor_sites_values[$new_value['value']] = __($new_value['language_alias']);
    }
}
$procure_other_tumor_sites_values[''] = '';

// *** Clinical Note ***

$procure_event_note_type_values = $this->StructurePermissibleValuesCustom->getCustomDropdown(array(
    'Clinical Note Types'
));
$procure_event_note_type_values = array_merge($procure_event_note_type_values['defined'], $procure_event_note_type_values['previously_defined']);
$procure_event_note_type_values[''] = '';
	