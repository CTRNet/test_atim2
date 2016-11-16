<?php 
	
	if(!$treatment_control_id) {
	 	//Set procure add button
		$this->set('add_link_for_procure_forms',$this->Participant->buildAddProcureFormsButton($participant_id));
	}
	