<?php 

$atim_structure['DiagnosisMaster'] = $this->Structures->get('form', 'view_diagnosis,qbcf_view_diagnosis');
$this->set('atim_structure', $atim_structure);

App::uses('StructureValueDomain', 'Model');
$this->StructureValueDomain = new StructureValueDomain();
$ctrnet_submission_disease_site = $this->StructureValueDomain ->find('first', array('conditions' => array('StructureValueDomain.domain_name' => 'ctrnet_submission_disease_site'), 'recursive' => 2));
$ctrnet_submission_disease_site_values = array();
if($ctrnet_submission_disease_site) {
	foreach($ctrnet_submission_disease_site['StructurePermissibleValue'] as $new_value) {
		$ctrnet_submission_disease_site_values[$new_value['value']] = __($new_value['language_alias']);
	}
}

$StructurePermissibleValuesCustomModel = AppModel::getInstance('', 'StructurePermissibleValuesCustom', true);
$qbcf_diagnosis_progression_sites = $StructurePermissibleValuesCustomModel->getCustomDropdown(array('DX : Progressions Sites'));
$qbcf_diagnosis_progression_sites = array_merge($qbcf_diagnosis_progression_sites['defined'], $qbcf_diagnosis_progression_sites['previously_defined']);
$qbcf_other_cancer_progression_sites = $StructurePermissibleValuesCustomModel->getCustomDropdown(array('Other Cancer Progression Sites'));
$qbcf_other_cancer_progression_sites = array_merge($qbcf_other_cancer_progression_sites['defined'], $qbcf_other_cancer_progression_sites['previously_defined']);

foreach($this->request->data as &$tmp_dx_data) {
	switch($tmp_dx_data['DiagnosisControl']['controls_type']) {
		case 'breast':
			break;
		case 'breast progression':
			$tmp_dx_data['Generated']['qbcf_dx_detail_for_tree_view'] = $qbcf_diagnosis_progression_sites[$tmp_dx_data['DiagnosisDetail']['site']];
			break;
		case 'other cancer':
			$tmp_dx_data['Generated']['qbcf_dx_detail_for_tree_view'] = $ctrnet_submission_disease_site_values[$tmp_dx_data['DiagnosisDetail']['disease_site']];
			break;
		case 'other cancer progression':
			$tmp_dx_data['Generated']['qbcf_dx_detail_for_tree_view'] = $qbcf_other_cancer_progression_sites[$tmp_dx_data['DiagnosisDetail']['secondary_disease_site']];
			break;
		default:
			$tmp_dx_data['Generated']['qbcf_dx_detail_for_tree_view'] = '';
	}	
}

$atim_structure['TreatmentMaster'] = $this->Structures->get('form', 'treatmentmasters,chus_tx_for_dx_tree_view');
$this->set('atim_structure', $atim_structure);
