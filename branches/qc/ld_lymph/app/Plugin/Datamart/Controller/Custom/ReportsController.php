<?php

class ReportsControllerCustom extends ReportsController {

	
	function specimenNumbersReport($parameters) {
		
		// Build criteria
		
		$criterias = array("ConsentMaster.consent_status" => array('obtained'));
		foreach(array('Participant' => 'id', 'SampleControl' => 'sample_type', 'DiagnosisDetail' => 'lymphoma_type') as $model => $field) {
			if(isset($parameters[$model][$field])) {
				foreach($parameters[$model][$field] as $new_val) {
					if($new_val) {
						if(!isset($criterias[$model.'.'.$field])) $criterias[$model.'.'.$field] = array();
						$criterias[$model.'.'.$field][] = $new_val;
					}
				}
			}
		}
		
		// Get data
		
		$DX_JOIN = isset($criterias['DiagnosisDetail.lymphoma_type'])? 'INNER' : 'LEFT';	
		$WHERE_CRITERIA = 'true';
		if($criterias) {
			$tmp_criterias = array();
			foreach($criterias as $mode_field => $values) $tmp_criterias[] = "$mode_field IN ('".implode("','", $values)."')";
			$WHERE_CRITERIA = implode(" AND ", $tmp_criterias);
		}
		$report_query = "
			SELECT DISTINCT
				Participant.participant_identifier, 	
				Participant.first_name,	
				Participant.last_name,
				MiscIdentifier.identifier_value,
				DiagnosisDetail.lymphoma_type,
				SampleMaster.ld_lymph_specimen_number,	
				SampleControl.sample_type
			FROM sample_masters AS SampleMaster
			INNER JOIN sample_controls as SampleControl ON SampleMaster.sample_control_id=SampleControl.id
			INNER JOIN collections AS Collection ON Collection.id = SampleMaster.collection_id AND Collection.deleted != 1
			INNER JOIN participants AS Participant ON Collection.participant_id = Participant.id AND Participant.deleted != 1
			INNER JOIN consent_masters AS ConsentMaster ON ConsentMaster.participant_id = Participant.id AND ConsentMaster.deleted != 1
			$DX_JOIN JOIN diagnosis_masters AS DiagnosisMaster ON DiagnosisMaster.participant_id = Participant.id AND DiagnosisMaster.deleted != 1 AND DiagnosisMaster.diagnosis_control_id IN (20,21)
			$DX_JOIN JOIN ld_lymph_dx_lymphomas	AS DiagnosisDetail ON DiagnosisDetail.diagnosis_master_id = DiagnosisMaster.id
			LEFT JOIN misc_identifiers AS MiscIdentifier on MiscIdentifier.misc_identifier_control_id = 2 AND MiscIdentifier.participant_id = Participant.id AND MiscIdentifier.deleted <> 1
			WHERE SampleMaster.deleted != 1 AND $WHERE_CRITERIA
			ORDER BY Participant.participant_identifier ASC, SampleMaster.ld_lymph_specimen_number ASC";
		$Participant = AppModel::getInstance("ClinicalAnnotation", "Participant", true);
		$results = $Participant->tryCatchQuery($report_query);
		
		if(sizeof($results) > 3000) {
			return array(
				'header' => null,
				'data' => null,
				'columns_names' => null,
				'error_msg' => 'more than 3000 records are returned by the query - please redefine search criteria');
		}
		
		$header = array(
				'title' => __('ld_lymph_specimen_nbr_report'),
				'description' => 'n/a');
			
		return array(
			'header' => $header,
			'data' => $results,
			'columns_names' => null,
			'error_msg' => null);
	}
	
	

}