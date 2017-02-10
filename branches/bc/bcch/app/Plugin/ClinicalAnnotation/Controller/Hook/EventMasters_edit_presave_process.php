<?php

 	// @author Stephen Fung
	// @since 2015-12-15
	// BB-131
	
	pr($event_master_data);
	pr($this->request->data);
	if($event_master_data['EventControl']['detail_tablename'] == 'ed_bcwh_live_births') {
					
		$diagnosisMasterId = $this->request->data['EventMaster']['diagnosis_master_id'];
		$mrn = $this->request->data['EventMaster']['mrn'];
		
		// User erased the MRN
		if (empty($mrn)) {
			
			$this->request->data['EventDetail']['biobank_id'] = NULL;
		
		// User input the MRN
		} else {
			
			//$this->loadModel('MiscIdentifier');
			$miscIdentifierModel = AppModel::getInstance('ClinicalAnnotation', 'MiscIdentifier');
			
			$findParticipantId = $miscIdentifierModel->find('first', array(
				'field' => array('MiscIdentifier.participant_id'),
				'conditions' => array('MiscIdentifier.identifier_value' => $mrn, 'MiscIdentifier.deleted' => 0),
				'recursive' => -1,
			));	

			// Can't find the MRN in participant profiles
			if(empty($findParticipantId)) {
				//Erase the biobank id
				$this->request->data['EventDetail']['biobank_id'] = NULL;
			// Find the MRN in participant profile, so update it	
			} else {
				
				$participantId = $findParticipantId['MiscIdentifier']['participant_id'];
				
				$findBioBankId = $this->Participant->find('first', array(
					'field' => array('Participant.participant_identifier'),
					'conditions' => array('Participant.id' => $participantId, 'Participant.deleted' => 0),
					'recursive' => -1,
				));
				
				$bioBankId = $findBioBankId['Participant']['participant_identifier'];
				
				$this->request->data['EventDetail']['biobank_id'] = $bioBankId;
				
			}
			
		}
		
	}