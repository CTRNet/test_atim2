<?php

class ReportsControllerCustom extends ReportsController {

	function specimenNumbersReport($parameters) {
		
		// Build criteria
		
		$criterias = array("ConsentMaster.consent_status" => array('obtained'));
		foreach(array('Participant' => 'id', 'Participant' => 'participant_identifier', 'SampleControl' => 'sample_type', 'DiagnosisMaster' => 'ld_lymph_lymphoma_type') as $model => $field) {
			if(isset($parameters[$model][$field])) {
				foreach($parameters[$model][$field] as $new_val) {
					if($new_val) {
						if(!isset($criterias[$model.'.'.$field])) $criterias[$model.'.'.$field] = array();
						$criterias[$model.'.'.$field][] = $new_val;
					}
				}
			}
		}
		$WHERE_CRITERIA = 'true';
		if($criterias) {
			$tmp_criterias = array();
			foreach($criterias as $mode_field => $values) $tmp_criterias[] = "$mode_field IN ('".implode("','", str_replace("'","''",$values))."')";
			$WHERE_CRITERIA = implode(" AND ", $tmp_criterias);
		}
		if(isset($parameters['Participant']['participant_identifier_start'])) {
			if(strlen($parameters['Participant']['participant_identifier_start'])) $WHERE_CRITERIA .= ' AND Participant.participant_identifier >= '.$parameters['Participant']['participant_identifier_start'];
			if(strlen($parameters['Participant']['participant_identifier_end'])) $WHERE_CRITERIA .= ' AND Participant.participant_identifier <= '.$parameters['Participant']['participant_identifier_end'];
		}
		
		// Get data
		
		$AVAILABLE_ALIQUOT_JOIN = ($parameters['FunctionManagement']['ld_lymph_limit_to_available_sample'][0])? "INNER JOIN aliquot_masters AliquotMaster ON AliquotMaster.sample_master_id = SampleMaster.id AND AliquotMaster.deleted <> 1 AND AliquotMaster.in_stock != 'no'" : '';
		$DX_JOIN = isset($criterias['DiagnosisMaster.ld_lymph_lymphoma_type'])? 'INNER' : 'LEFT';	
		$report_query = "
			SELECT DISTINCT
				Participant.id,
				Participant.participant_identifier, 	
				Participant.first_name,	
				Participant.last_name,
				MiscIdentifier.identifier_value,
				DiagnosisMaster.ld_lymph_lymphoma_type,
				SampleMaster.ld_lymph_specimen_number,	
				SampleControl.sample_type,
				SampleControl.id
			FROM sample_masters AS SampleMaster
			INNER JOIN sample_controls as SampleControl ON SampleMaster.sample_control_id=SampleControl.id
			INNER JOIN collections AS Collection ON Collection.id = SampleMaster.collection_id AND Collection.deleted != 1
			INNER JOIN participants AS Participant ON Collection.participant_id = Participant.id AND Participant.deleted != 1
			INNER JOIN consent_masters AS ConsentMaster ON ConsentMaster.participant_id = Participant.id AND ConsentMaster.deleted != 1
			$AVAILABLE_ALIQUOT_JOIN
			$DX_JOIN JOIN diagnosis_masters AS DiagnosisMaster ON DiagnosisMaster.participant_id = Participant.id AND DiagnosisMaster.deleted != 1 AND DiagnosisMaster.diagnosis_control_id IN (20,21,24)
			LEFT JOIN misc_identifiers AS MiscIdentifier on MiscIdentifier.misc_identifier_control_id = 2 AND MiscIdentifier.participant_id = Participant.id AND MiscIdentifier.deleted <> 1
			WHERE SampleMaster.deleted != 1 AND $WHERE_CRITERIA
			ORDER BY Participant.participant_identifier ASC, SampleMaster.ld_lymph_specimen_number ASC";
		$Participant = AppModel::getInstance("ClinicalAnnotation", "Participant", true);	
		$results = $Participant->tryCatchQuery($report_query);
		if(sizeof($results) > 1000) {
			return array(
				'header' => null,
				'data' => null,
				'columns_names' => null,
				'error_msg' => 'more than 1000 records are returned by the query - please redefine search criteria');
		}
		foreach($results as &$new_row) {
			$aliquot_query = "SELECT count(*) AS nbr_aliquots
				FROM collections Collection
				INNER JOIN sample_masters SampleMaster ON SampleMaster.collection_id = Collection.id AND SampleMaster.deleted <> 1
				INNER JOIN aliquot_masters AliquotMaster ON SampleMaster.id = AliquotMaster.sample_master_id AND AliquotMaster.deleted <> 1
				WHERE Collection.deleted <> 1 
				AND Collection.participant_id = ".$new_row['Participant']['id']." 
				AND SampleMaster.sample_control_id = ".$new_row['SampleControl']['id']."
				AND SampleMaster.ld_lymph_specimen_number = '".$new_row['SampleMaster']['ld_lymph_specimen_number']."'
				AND AliquotMaster.in_stock != 'no'";
			$aliquot_results = $Participant->tryCatchQuery($aliquot_query);
			$new_row['0']['ld_lymph_in_stock_aliquot_nbr'] = $aliquot_results[0][0]['nbr_aliquots'];
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