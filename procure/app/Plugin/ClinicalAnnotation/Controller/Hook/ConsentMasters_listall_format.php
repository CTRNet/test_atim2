<?php 

	$this->Structures->set('consent_masters,procure_consent_form_siganture');
	$this->set('add_link_for_procure_forms',$this->Participant->buildAddProcureFormsButton($participant_id));