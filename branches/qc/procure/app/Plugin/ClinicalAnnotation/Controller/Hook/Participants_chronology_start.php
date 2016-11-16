<?php 
	
	$this->set('add_link_for_procure_forms',$this->Participant->buildAddProcureFormsButton($participant_id));
	
	// *** Treatment ***
	
	$procure_treatment_types = $this->StructureValueDomain->find('first', array('conditions' => array('StructureValueDomain.domain_name' => 'procure_treatment_types'), 'recursive' => 2));
	$procure_treatment_type_values = array();
	if($procure_treatment_types) {
		foreach($procure_treatment_types['StructurePermissibleValue'] as $new_value) {
			$procure_treatment_types_values[$new_value['value']] = __($new_value['language_alias']);
		}
	}	
	$procure_treatment_types_values[''] = '';
	
	$procure_treatment_precision = $this->StructureValueDomain->find('first', array('conditions' => array('StructureValueDomain.domain_name' => 'procure_treatment_precision'), 'recursive' => 2));
	$procure_treatment_precision_values = array();
	if($procure_treatment_precision) {
		foreach($procure_treatment_precision['StructurePermissibleValue'] as $new_value) {
			$procure_treatment_precision_values[$new_value['value']] = __($new_value['language_alias']);
		}
	}
	$procure_treatment_precision_values[''] = '';
	
	$procure_treatment_site_values = $this->StructurePermissibleValuesCustom->getCustomDropdown(array('Treatment Sites'));
	$procure_treatment_site_values = array_merge($procure_treatment_site_values['defined'], $procure_treatment_site_values['previously_defined']);
	$procure_treatment_site_values[''] = '';
	
	$procure_surgery_type_values = $this->StructurePermissibleValuesCustom->getCustomDropdown(array('Surgery Types'));
	$procure_surgery_type_values = array_merge($procure_surgery_type_values['defined'], $procure_surgery_type_values['previously_defined']);
	$procure_surgery_type_values[''] = '';
	
	// *** Clinical Exam ***	
	
	$procure_exam_types = $this->StructureValueDomain->find('first', array('conditions' => array('StructureValueDomain.domain_name' => 'procure_clinical_exam_types'), 'recursive' => 2));
	$procure_exam_types_values = array();
	if($procure_exam_types) {
		foreach($procure_exam_types['StructurePermissibleValue'] as $new_value) {
			$procure_exam_types_values[$new_value['value']] = __($new_value['language_alias']);
		}
	}
	$procure_exam_types_values[''] = '';
	
	$procure_exam_results = $this->StructureValueDomain->find('first', array('conditions' => array('StructureValueDomain.domain_name' => 'procure_clinical_exam_results'), 'recursive' => 2));
	$procure_exam_results_values = array();
	if($procure_exam_results) {
		foreach($procure_exam_results['StructurePermissibleValue'] as $new_value) {
			$procure_exam_results_values[$new_value['value']] = __($new_value['language_alias']);
		}
	}
	$procure_exam_results_values[''] = '';
	
	$clinical_exam_precision = $this->StructurePermissibleValuesCustom->getCustomDropdown(array('Clinical Exam Precisions'));
	$clinical_exam_precision = array_merge($clinical_exam_precision['defined'], $clinical_exam_precision['previously_defined']);
	$clinical_exam_precision[''] = '';
	
	$procure_progressions_comorbidities = $this->StructurePermissibleValuesCustom->getCustomDropdown(array('Progressions & Comorbidities'));
	$procure_progressions_comorbidities = array_merge($procure_progressions_comorbidities['defined'], $procure_progressions_comorbidities['previously_defined']);
	$procure_progressions_comorbidities[''] = '';

	// *** Other Tumor ***	
		
	$procure_other_tumor_sites = $this->StructureValueDomain->find('first', array('conditions' => array('StructureValueDomain.domain_name' => 'procure_other_tumor_sites'), 'recursive' => 2));
	$procure_other_tumor_sites_values = array();
	if($procure_other_tumor_sites) {
		foreach($procure_other_tumor_sites['StructurePermissibleValue'] as $new_value) {
			$procure_other_tumor_sites_values[$new_value['value']] = __($new_value['language_alias']);
		}
	}
	$procure_other_tumor_sites_values[''] = '';
	
	// *** Clinical Note ***
	
	$procure_event_note_types = $this->StructurePermissibleValuesCustom->getCustomDropdown(array('Clinical Note Types'));
	$procure_event_note_types = array_merge($procure_event_note_types['defined'], $procure_event_note_types['previously_defined']);
	$procure_event_note_types[''] = '';
	