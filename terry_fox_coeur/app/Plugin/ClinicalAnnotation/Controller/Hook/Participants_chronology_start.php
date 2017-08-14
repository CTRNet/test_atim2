<?php 
	

$Drug = AppModel::getInstance("Drug", "Drug", true);
$all_drugs = $Drug->getDrugPermissibleValues();

$this->TreatmentExtendMaster = AppModel::getInstance("ClinicalAnnotation", "TreatmentExtendMaster", true);

$qc_tf_tumor_sites = $this->StructureValueDomain->find('first', array('conditions' => array('StructureValueDomain.domain_name' => 'qc_tf_tumor_site'), 'recursive' => 2));
$qc_tf_tumor_site_values = array();
if($qc_tf_tumor_sites) {
	foreach($qc_tf_tumor_sites['StructurePermissibleValue'] as $new_value) {
		$qc_tf_tumor_site_values[$new_value['value']] = __($new_value['language_alias']);
	}
}
$qc_tf_progression_detection_methods = $this->StructureValueDomain->find('first', array('conditions' => array('StructureValueDomain.domain_name' => 'qc_tf_progression_detection_method'), 'recursive' => 2));
$qc_tf_progression_detection_method_values = array();
if($qc_tf_progression_detection_methods) {
	foreach($qc_tf_progression_detection_methods['StructurePermissibleValue'] as $new_value) {
		$qc_tf_progression_detection_method_values[$new_value['value']] = __($new_value['language_alias']);
	}
}

$qc_tf_biopsy_contexts_values = $this->StructurePermissibleValuesCustom->getCustomDropdown(array('Biopsy Sites'));
$qc_tf_biopsy_contexts_values = array_merge($qc_tf_biopsy_contexts_values['defined'], $qc_tf_biopsy_contexts_values['previously_defined']);
$qc_tf_biopsy_contexts_values[''] = '';
