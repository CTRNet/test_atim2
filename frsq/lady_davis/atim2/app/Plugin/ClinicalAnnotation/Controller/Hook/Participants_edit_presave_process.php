<?php
	
	if(isset($this->request->data['Participant']['qc_lady_has_family_history']) && $this->request->data['Participant']['qc_lady_has_family_history'] != 'y'){
		$fam_hist = $this->FamilyHistory->find('first', array('conditions' => array('FamilyHistory.participant_id' => $this->id)));
		if($fam_hist){
			$this->request->data['Participant']['qc_lady_has_family_history'] = 'y';
			AppController::addWarningMsg('family history exists - field has family history updated');
		}
	}	
	