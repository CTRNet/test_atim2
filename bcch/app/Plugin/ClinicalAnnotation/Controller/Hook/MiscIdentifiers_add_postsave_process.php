<?php

	// @author Stephen Fung
	// @since 2015-11-03
	// BB-131
	// Auto-copy participant identifier to neonatal information form
	
	// Need to check for null value
	
	if ($this->request->data['MiscIdentifierControl']['misc_identifier_name'] == 'MRN') {
		
		$participantId = $this->request->data['MiscIdentifier']['participant_id'];
		$mrn = $this->request->data['MiscIdentifier']['identifier_value'];
		
		if(!empty($mrn)) {
			
			// Find the BioBank Id of the Participant	
			//$this->loadModel('Participant');
		
			$findBioBankId = $this->Participant->find('first', array(
				'field' => array('Participant.participant_identifier'),
				'conditions' => array('Participant.id' => $participantId, 'Participant.deleted' => 0),
				'recursive' => -1,
			));
			
			$bioBankId = $findBioBankId['Participant']['participant_identifier'];
			
			// Find the EventMaster with the identical MRN		
			$eventControldModel = AppModel::getInstance('ClinicalAnnotation', 'EventControl');
		
			$findEventControl = $eventControldModel->find('first', array(
				'field' => array('EventControl.id'),
				'conditions' => array('EventControl.detail_tablename' => 'ed_bcwh_live_births'),
				'recursive' => -1,
			));
			
			
			$eventControlId = $findEventControl['EventControl']['id'];		
			
			$eventMasterModel = AppModel::getInstance('ClinicalAnnotation', 'EventMaster');
			
			$findEventMaster = $eventMasterModel->find('first', array(
				'field' => array('EventMaster.id'),
				'conditions' => array('EventMaster.mrn' => $mrn, 'EventMaster.event_control_id' => $eventControlId, 'EventMaster.deleted' => 0),
				'recursive' => -1,
			));
			
			
			if(!empty($findEventMaster)) {
								
				$eventMasterId = $findEventMaster['EventMaster']['id'];
			
				$queryToUpdate = "UPDATE ed_bcwh_live_births SET biobank_id='".$bioBankId."' WHERE event_master_id = '".$eventMasterId."';";
				$this->MiscIdentifier->tryCatchQuery($queryToUpdate);
			
				$queryToUpdate = "UPDATE ed_bcwh_live_births_revs SET biobank_id='".$bioBankId."' WHERE event_master_id = '".$eventMasterId."' ORDER BY version_id DESC LIMIT 1;";
				$this->MiscIdentifier->tryCatchQuery($queryToUpdate);
				
			}
		
		}
		
	}
