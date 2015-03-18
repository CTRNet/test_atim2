<?php 
	
	$Drug = AppModel::getInstance("Drug", "Drug", true);
	$all_drugs = $Drug->getDrugPermissibleValues();
	
	$this->set('add_link_for_procure_forms',$this->Participant->buildAddProcureFormsButton($participant_id));