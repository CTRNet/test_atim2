<?php 
	
	$this->set('add_link_for_procure_forms',$this->Participant->buildAddProcureFormsButton($participant_id));
	
	$Drug = AppModel::getInstance("Drug", "Drug", true);
	$all_drugs = $Drug->getDrugPermissibleValues();
	
	// *** Treatment ***
	
	$procure_followup_treatment_types = $this->StructureValueDomain->find('first', array('conditions' => array('StructureValueDomain.domain_name' => 'procure_followup_treatment_types'), 'recursive' => 2));
	$procure_followup_treatment_types_values = array();
	if($procure_followup_treatment_types) {
		foreach($procure_followup_treatment_types['StructurePermissibleValue'] as $new_value) {
			$procure_followup_treatment_types_values[$new_value['value']] = __($new_value['language_alias']);
		}
	}	
	
	$procure_treatment_site = $this->StructureValueDomain->find('first', array('conditions' => array('StructureValueDomain.domain_name' => 'procure_treatment_site'), 'recursive' => 2));
	$procure_treatment_site_values = array();
	if($procure_treatment_site) {
		foreach($procure_treatment_site['StructurePermissibleValue'] as $new_value) {
			$procure_treatment_site_values[$new_value['value']] = __($new_value['language_alias']);
		}
	}
	
	$procure_treatment_precision = $this->StructureValueDomain->find('first', array('conditions' => array('StructureValueDomain.domain_name' => 'procure_treatment_precision'), 'recursive' => 2));
	$procure_treatment_precision_values = array();
	if($procure_treatment_precision) {
		foreach($procure_treatment_precision['StructurePermissibleValue'] as $new_value) {
			$procure_treatment_precision_values[$new_value['value']] = __($new_value['language_alias']);
		}
	}
	
	// *** Clinical Exam ***	
	
	$procure_followup_exam_types = $this->StructureValueDomain->find('first', array('conditions' => array('StructureValueDomain.domain_name' => 'procure_followup_exam_types'), 'recursive' => 2));
	$procure_followup_exam_types_values = array();
	if($procure_followup_exam_types) {
		foreach($procure_followup_exam_types['StructurePermissibleValue'] as $new_value) {
			$procure_followup_exam_types_values[$new_value['value']] = __($new_value['language_alias']);
		}
	}
	
	$procure_followup_exam_results = $this->StructureValueDomain->find('first', array('conditions' => array('StructureValueDomain.domain_name' => 'procure_followup_exam_results'), 'recursive' => 2));
	$procure_followup_exam_results_values = array();
	if($procure_followup_exam_results) {
		foreach($procure_followup_exam_results['StructurePermissibleValue'] as $new_value) {
			$procure_followup_exam_results_values[$new_value['value']] = __($new_value['language_alias']);
		}
	}
	
	// *** Other Tumor ***	
	
	$procure_other_tumor_sites = $this->StructureValueDomain->find('first', array('conditions' => array('StructureValueDomain.domain_name' => 'procure_other_tumor_sites'), 'recursive' => 2));
	$procure_other_tumor_sites_values = array();
	if($procure_other_tumor_sites) {
		foreach($procure_other_tumor_sites['StructurePermissibleValue'] as $new_value) {
			$procure_other_tumor_sites_values[$new_value['value']] = __($new_value['language_alias']);
		}
	}
	
	$procure_other_tumor_treatment_types = $this->StructureValueDomain->find('first', array('conditions' => array('StructureValueDomain.domain_name' => 'procure_other_tumor_treatment_types'), 'recursive' => 2));
	$procure_other_tumor_treatment_types_values = array();
	if($procure_other_tumor_treatment_types) {
		foreach($procure_other_tumor_treatment_types['StructurePermissibleValue'] as $new_value) {
			$procure_other_tumor_treatment_types_values[$new_value['value']] = __($new_value['language_alias']);
		}
	}
	
	
	
	