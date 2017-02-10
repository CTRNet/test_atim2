<?php

	// @author Stephen Fung
	// @since 2015-11-03
	// BB-131
	// Auto-copy participant identifier to neonatal information form
	// For the edit hook:
	// 1) Check if the old and new MRN is the same, if they are the same, do nothing
	// 1) Check if record exist using the old MRN
	// 2) Delete biobank ID from old record if necessary
	// 3) Then search record with the new MRN
	// 4) Update BioBank ID from new record if necessary
	
	// Need work!
	if ($this->request->data['MiscIdentifierControl']['misc_identifier_name'] == 'MRN') {

		$participantId = $misc_identifier_data['Participant']['id'];
		$bioBankId = $misc_identifier_data['Participant']['participant_identifier'];
		$oldMRN = $misc_identifier_data['MiscIdentifier']['identifier_value'];
		$newMRN = $this->request->data['MiscIdentifier']['identifier_value'];
		
		// Do nothing if the old MRN is the same as old MRN
		if($oldMRN != $newMRN) {
					
			// Find EventMaster Record with old MRN
			
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
				'conditions' => array('EventMaster.mrn' => $oldMRN, 'EventMaster.event_control_id' => $eventControlId, 'EventMaster.deleted' => 0),
				'recursive' => -1,
			));
			
			if(!empty($findEventMaster)) {
				// Found the EventMaster Record with the old MRN
				$eventMasterId = $findEventMaster['EventMaster']['id'];
				
				// Set the old birth record's biobank id to NULL
				$queryToUpdate = "UPDATE ed_bcwh_live_births SET biobank_id=NULL WHERE event_master_id = '".$eventMasterId."';";
				$this->MiscIdentifier->tryCatchQuery($queryToUpdate);
			
				$queryToUpdate = "UPDATE ed_bcwh_live_births_revs SET biobank_id=NULL WHERE event_master_id = '".$eventMasterId."' ORDER BY version_id DESC LIMIT 1;";
				$this->MiscIdentifier->tryCatchQuery($queryToUpdate);
				
				//Find EventMaster with new MRN
				$findEventMaster = $eventMasterModel->find('first', array(
					'field' => array('EventMaster.id'),
					'conditions' => array('EventMaster.mrn' => $newMRN, 'EventMaster.event_control_id' => $eventControlId, 'EventMaster.deleted' => 0),
					'recursive' => -1,
				));
								
				if(!empty($findEventMaster)) {
					// Found record with new MRN
					$eventMasterId = $findEventMaster['EventMaster']['id'];
					
					$queryToUpdate = "UPDATE ed_bcwh_live_births SET biobank_id='".$bioBankId."' WHERE event_master_id = '".$eventMasterId."';";
					$this->MiscIdentifier->tryCatchQuery($queryToUpdate);
			
					$queryToUpdate = "UPDATE ed_bcwh_live_births_revs SET biobank_id='".$bioBankId."' WHERE event_master_id = '".$eventMasterId."' ORDER BY version_id DESC LIMIT 1;";
					$this->MiscIdentifier->tryCatchQuery($queryToUpdate);
					
				}
							
			} else {
				
				// Didn't find an EventMaster Record with the old MRN
				// Find an EventMaster with the new MRN
				
				$findEventMaster = $eventMasterModel->find('first', array(
					'field' => array('EventMaster.id'),
					'conditions' => array('EventMaster.mrn' => $newMRN, 'EventMaster.event_control_id' => $eventControlId, 'EventMaster.deleted' => 0),
					'recursive' => -1,
				));
							
				if(!empty($findEventMaster)) {
					// Found record with new MRN
					$eventMasterId = $findEventMaster['EventMaster']['id'];
					
					$queryToUpdate = "UPDATE ed_bcwh_live_births SET biobank_id='".$bioBankId."' WHERE event_master_id = '".$eventMasterId."';";
					$this->MiscIdentifier->tryCatchQuery($queryToUpdate);
			
					$queryToUpdate = "UPDATE ed_bcwh_live_births_revs SET biobank_id='".$bioBankId."' WHERE event_master_id = '".$eventMasterId."' ORDER BY version_id DESC LIMIT 1;";
					$this->MiscIdentifier->tryCatchQuery($queryToUpdate);
					
				}
								
			}
						
		}
		
	}
