<?php

class MiscIdentifierCustom extends MiscIdentifier {
	var $name = 'MiscIdentifier';
	var $useTable = 'misc_identifiers';
	
	function updateParticipantPathoNumberList($participant_id, $deleted_treatment_master_id = null) {	
		//Get control id
		$controls_data = $this->tryCatchQuery("SELECT id FROM misc_identifier_controls WHERE misc_identifier_name = 'pathology number'");
		if(empty($controls_data) || !isset($controls_data[0]['misc_identifier_controls']['id']))AppController::getInstance()->redirect( '/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true ); 
		$misc_identifier_control_id = $controls_data[0]['misc_identifier_controls']['id'];
		//Update List
		$queries = array(
			"DELETE FROM misc_identifiers WHERE participant_id = $participant_id AND misc_identifier_control_id = $misc_identifier_control_id;",
			"DELETE FROM misc_identifiers_revs WHERE participant_id = $participant_id AND misc_identifier_control_id = $misc_identifier_control_id;",
			"INSERT INTO misc_identifiers (identifier_value, participant_id, misc_identifier_control_id, modified, created, created_by, modified_by)
			(SELECT DISTINCT TreatmentDetail.path_num, TreatmentMaster.participant_id, $misc_identifier_control_id, now(), now(), '0', '0'
			FROM treatment_masters TreatmentMaster INNER JOIN treatment_controls TreatmentControl ON TreatmentControl.id = TreatmentMaster.treatment_control_id INNER JOIN txd_surgeries TreatmentDetail ON TreatmentDetail.treatment_master_id = TreatmentMaster.id
			WHERE TreatmentMaster.participant_id = $participant_id ".($deleted_treatment_master_id? "AND TreatmentMaster.id != $deleted_treatment_master_id" : "")."
			AND TreatmentControl.tx_method = 'procedure - surgery and biopsy' 
			AND TreatmentMaster.deleted <> 1
			AND TreatmentDetail.path_num NOT LIKE '' AND TreatmentDetail.path_num IS NOT NULL);",
			"INSERT INTO misc_identifiers_revs (id, identifier_value, participant_id, misc_identifier_control_id, version_created, modified_by)
			(SELECT id, identifier_value, participant_id, misc_identifier_control_id, modified, modified_by FROM misc_identifiers WHERE misc_identifier_control_id = $misc_identifier_control_id AND participant_id = $participant_id);");
		foreach($queries as $new_query) $this->tryCatchQuery($new_query);
	}
	
	function updateParticipantVoaList($participant_id) {	
		//Get control id
		$controls_data = $this->tryCatchQuery("SELECT id FROM misc_identifier_controls WHERE misc_identifier_name = 'VOA#'");
		if(empty($controls_data) || !isset($controls_data[0]['misc_identifier_controls']['id']))AppController::getInstance()->redirect( '/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true );
		$misc_identifier_control_id = $controls_data[0]['misc_identifier_controls']['id'];
		//Update List
		$queries = array(
				"DELETE FROM misc_identifiers WHERE participant_id = $participant_id AND misc_identifier_control_id = $misc_identifier_control_id;",
				"DELETE FROM misc_identifiers_revs WHERE participant_id = $participant_id AND misc_identifier_control_id = $misc_identifier_control_id;",
				"INSERT INTO misc_identifiers (identifier_value, participant_id, misc_identifier_control_id, modified, created, created_by, modified_by)
				(SELECT DISTINCT ovcare_collection_voa_nbr, participant_id, $misc_identifier_control_id, now(), now(), '0', '0' FROM collections WHERE deleted <> 1 AND participant_id = $participant_id);",
				"INSERT INTO misc_identifiers_revs (id, identifier_value, participant_id, misc_identifier_control_id, version_created, modified_by)
				(SELECT id, identifier_value, participant_id, misc_identifier_control_id, modified, modified_by FROM misc_identifiers WHERE misc_identifier_control_id = $misc_identifier_control_id AND participant_id = $participant_id);");
		foreach($queries as $new_query) $this->tryCatchQuery($new_query);
	}
}
?>