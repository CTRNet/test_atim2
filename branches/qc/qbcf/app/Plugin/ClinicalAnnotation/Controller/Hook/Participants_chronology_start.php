<?php 
	
	$beast_dx_intervention = $this->StructurePermissibleValuesCustom->getCustomDropdown(array('DX : Type of intervention'));
	$beast_dx_intervention = array_merge($beast_dx_intervention['defined'], $beast_dx_intervention['previously_defined']);

	$beast_dx_progression_site = $this->StructurePermissibleValuesCustom->getCustomDropdown(array('DX : Progressions Sites'));
	$beast_dx_progression_site = array_merge($beast_dx_progression_site['defined'], $beast_dx_progression_site['previously_defined']);
	
	$other_dx_progression_sites = $this->StructurePermissibleValuesCustom->getCustomDropdown(array('Other Cancer Progression Sites'));
	$other_dx_progression_sites = array_merge($other_dx_progression_sites['defined'], $other_dx_progression_sites['previously_defined']);
	
	$ctrnet_submission_disease_site = $this->StructureValueDomain->find('first', array('conditions' => array('StructureValueDomain.domain_name' => 'ctrnet_submission_disease_site'), 'recursive' => 2));
	$ctrnet_submission_disease_site_values = array();
	if($ctrnet_submission_disease_site) {
		foreach($ctrnet_submission_disease_site['StructurePermissibleValue'] as $new_value) {
			$ctrnet_submission_disease_site_values[$new_value['value']] = __($new_value['language_alias']);
		}
	}
	
	$other_cancer_tx = $this->StructurePermissibleValuesCustom->getCustomDropdown(array('Tx : Other Cancer Treatment'));
	$other_cancer_tx = array_merge($other_cancer_tx['defined'], $other_cancer_tx['previously_defined']);	
	
	$treatment_extend_model = AppModel::getInstance('ClinicalAnnotation', 'TreatmentExtendMaster', true);
	