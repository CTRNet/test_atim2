<?php 
	
	$atim_structure['EventMaster'] = $this->Structures->get('form', 'eventmasters_for_dx_tree_view');
	$atim_structure['TreatmentMaster'] = $this->Structures->get('form', 'treatmentmasters_for_dx_tree_view'); 
	$atim_structure['DiagnosisMaster'] = $this->Structures->get('form', 'view_diagnosis_for_dx_tree_view'); 
	$this->set('atim_structure', $atim_structure);
	