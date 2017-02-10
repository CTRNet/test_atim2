<?php

	// @author Stephen Fung
	// @since 2015-11-03
	// BB-131
	// Auto-copy participant identifier to neonatal information form
	
	if ($misc_identifier_data['MiscIdentifierControl']['misc_identifier_name'] == 'MRN') {
		
		// Get the BioBank Identifier and the MRN of the Participant
		$participantIdentifier = $misc_identifier_data['Participant']['participant_identifier'];
		$mrn = $misc_identifier_data['MiscIdentifier']['identifier_value'];
		
		$eventControldModel = AppModel::getInstance('ClinicalAnnotation', 'EventControl');
			
		$findEventControl = $eventControldModel->find('first', array(
			'field' => array('EventControl.id'),
			'conditions' => array('EventControl.detail_tablename' => 'ed_bcwh_live_births'),
			'recursive' => -1,
		));
						
		$eventControlId = $findEventControl['EventControl']['id'];
		
		$eventMasterModel = AppModel::getInstance('ClinicalAnnotation', 'EventMaster');
		
		$findEventMasterId = $eventMasterModel->find('first', array(
			'field' => array('EventMaster.id'),
			'conditions' => array('EventMaster.event_control_id' => $eventControlId, 'EventMaster.deleted' => 0, 'EventMaster.mrn' => $mrn),
			'recursive' => -1,
		));
		
		if (!empty($findEventMasterId)) {
			
			$eventMasterId = $findEventMasterId['EventMaster']['id'];
		
			$queryToUpdate = "UPDATE ed_bcwh_live_births SET biobank_id=NULL WHERE event_master_id='".$eventMasterId."';";
			$this->MiscIdentifier->tryCatchQuery($queryToUpdate);
			
			/* BB-197 Issue
			@Date: 2016-06-22
			Fixed @Date: 2016-07-06
			*/
			$queryToUpdate = "INSERT INTO ed_bcwh_live_births_revs (id, time_of_birth, gestational_age_week, gestational_age_day, sex, biobank_id, apgar_score_1min, apgar_score_5min, apgar_score_10min, birth_weight, cord_blood_ph, genetic_syndromes, congenital_birth_defects, neonatal_infection, newborn_screening_results, group_b_strep_expo, hep_b_prophy, tobacco_expo, alcohol_expo, substances_expo, event_master_id, version_created) SELECT id, time_of_birth, gestational_age_week, gestational_age_day, sex, biobank_id, apgar_score_1min, apgar_score_5min, apgar_score_10min, birth_weight, cord_blood_ph, genetic_syndromes, congenital_birth_defects, neonatal_infection, newborn_screening_results, group_b_strep_expo, hep_b_prophy, tobacco_expo, alcohol_expo, substances_expo, event_master_id, NOW() FROM ed_bcwh_live_births WHERE event_master_id = '".$eventMasterId."';";
			$this->MiscIdentifier->tryCatchQuery($queryToUpdate);
			
            
		}

	}
	