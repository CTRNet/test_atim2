<?php 
	
	/* 
	@author Stephen Fung
	@since 2015-09-04
	Reports the proper number of consent forms
	BB-110
	Eventum ID: XXXX
	*/
	
	class ReportsControllerCustom extends ReportsController {
		
		function bankActiviySummary($parameters) {
			
			if(!AppController::checkLinkPermission('/ClinicalAnnotation/Participants/profile')){
				$this->flash(__('you need privileges to access this page'), 'javascript:history.back()');
			}
			if(!AppController::checkLinkPermission('/InventoryManagement/Collections/detail')){
				$this->flash(__('you need privileges to access this page'), 'javascript:history.back()');
			}
			
			// 1- Build Header
			$start_date_for_display = AppController::getFormatedDateString($parameters[0]['report_date_range_start']['year'], $parameters[0]['report_date_range_start']['month'], $parameters[0]['report_date_range_start']['day']);
			$end_date_for_display = AppController::getFormatedDateString($parameters[0]['report_date_range_end']['year'], $parameters[0]['report_date_range_end']['month'], $parameters[0]['report_date_range_end']['day']);
			$header = array(
				'title' => __('from').' '.(empty($parameters[0]['report_date_range_start']['year'])?'?':$start_date_for_display).' '.__('to').' '.(empty($parameters[0]['report_date_range_end']['year'])?'?':$end_date_for_display), 
				'description' => 'n/a');
	
			// 2- Search data
			$start_date_for_sql = AppController::getFormatedDatetimeSQL($parameters[0]['report_date_range_start'], 'start');
			$end_date_for_sql = AppController::getFormatedDatetimeSQL($parameters[0]['report_date_range_end'], 'end');
	
			$search_on_date_range = true;
			if((strpos($start_date_for_sql, '-9999') === 0) && (strpos($end_date_for_sql, '9999') === 0)) $search_on_date_range = false;
			
			// Get new participant
			if(!isset($this->Participant)) {
				$this->Participant = AppModel::getInstance("ClinicalAnnotation", "Participant", true);
			}
			$conditions = $search_on_date_range? array("Participant.created >= '$start_date_for_sql'", "Participant.created <= '$end_date_for_sql'") : array();
			$data['0']['new_participants_nbr'] = $this->Participant->find('count', (array('conditions' => $conditions)));		
			
			// Get new consents obtained
			/*
			if(!isset($this->ConsentMaster)) {
				$this->ConsentMaster = AppModel::getInstance("ClinicalAnnotation", "ConsentMaster", true);
			}
			$conditions = $search_on_date_range? array("ConsentMaster.consent_signed_date >= '$start_date_for_sql'", "ConsentMaster.consent_signed_date <= '$end_date_for_sql'") : array();
			$all_consent = $this->ConsentMaster->find('count', (array('conditions' => $conditions)));
			$conditions['ConsentMaster.consent_status'] = 'obtained';
			$all_obtained_consent = $this->ConsentMaster->find('count', (array('conditions' => $conditions)));
			$data['0']['obtained_consents_nbr'] = "$all_obtained_consent/$all_consent";
			*/
			
			// Get CCBR consents	
			if($search_on_date_range) {
				
				//User input a date
				
				// Get CCBR Consent that has formally consented
				$num_of_ccbr_consents_struct = $this->Report->tryCatchQuery(
					"SELECT COUNT(*) FROM cd_ccbr_consents  
					WHERE ccbr_formal_consent='consented' 
					AND deleted != 1
					AND ccbr_date_formal_consent >= '".$start_date_for_sql."' AND ccbr_date_formal_consent <= '".$end_date_for_sql."';"
				);
			
				// Get all the CCBR Consent
				$num_of_total_ccbr_consents_struct = $this->Report->tryCatchQuery(
					"SELECT COUNT(*) FROM cd_ccbr_consents  
					WHERE deleted != 1
					AND ccbr_date_formal_consent >= '".$start_date_for_sql."' AND ccbr_date_formal_consent <= '".$end_date_for_sql."';"
				);
			
				$num_of_ccbr_consents = $num_of_ccbr_consents_struct[0][0]['COUNT(*)'];
				$num_of_total_ccbr_consents = $num_of_total_ccbr_consents_struct[0][0]['COUNT(*)'];
			
				$data['0']['obtained_ccbr_consents_nbr'] = $num_of_ccbr_consents."/".$num_of_total_ccbr_consents;
				
			} else {
				
				//User didn't input a date
				
				// Get CCBR Consent that has formally consented			
				$num_of_ccbr_consents_struct = $this->Report->tryCatchQuery(
					"SELECT COUNT(*) FROM cd_ccbr_consents  
					WHERE ccbr_formal_consent='consented' 
					AND deleted != 1;"
				);
			
				// Get all the CCBR Consent
				$num_of_total_ccbr_consents_struct = $this->Report->tryCatchQuery(
					"SELECT COUNT(*) FROM cd_ccbr_consents  
					WHERE deleted != 1;"
				);
			
				$num_of_ccbr_consents = $num_of_ccbr_consents_struct[0][0]['COUNT(*)'];
				$num_of_total_ccbr_consents = $num_of_total_ccbr_consents_struct[0][0]['COUNT(*)'];
			
				$data['0']['obtained_ccbr_consents_nbr'] = $num_of_ccbr_consents."/".$num_of_total_ccbr_consents;
			}
			
			// Get new BCCH consents		
			if($search_on_date_range) {
				
				//User input a date
				
				// Get BCCH Consent that has formally consented
				$num_of_bcch_consents_struct = $this->Report->tryCatchQuery(
					"SELECT COUNT(*) FROM cd_bcch_consents  
					WHERE bcch_formal_consent='consented' 
					AND deleted != 1
					AND bcch_date_formal_consent >= '".$start_date_for_sql."' AND bcch_date_formal_consent <= '".$end_date_for_sql."';"
				);
			
				// Get all the BCCH Consent
				$num_of_total_bcch_consents_struct = $this->Report->tryCatchQuery(
					"SELECT COUNT(*) FROM cd_bcch_consents  
					WHERE deleted != 1
					AND bcch_date_formal_consent >= '".$start_date_for_sql."' AND bcch_date_formal_consent <= '".$end_date_for_sql."';"
				);
			
				$num_of_bcch_consents = $num_of_bcch_consents_struct[0][0]['COUNT(*)'];
				$num_of_total_bcch_consents = $num_of_total_bcch_consents_struct[0][0]['COUNT(*)'];
			
				$data['0']['obtained_bcch_consents_nbr'] = $num_of_bcch_consents."/".$num_of_total_bcch_consents;
				
			} else {
				
				//User didn't input a date
				
				// Get BCCH Consent that has formally consented			
				$num_of_bcch_consents_struct = $this->Report->tryCatchQuery(
					"SELECT COUNT(*) FROM cd_bcch_consents  
					WHERE bcch_formal_consent='consented' 
					AND deleted != 1;"
				);
			
				// Get all the BCCH Consent
				$num_of_total_bcch_consents_struct = $this->Report->tryCatchQuery(
					"SELECT COUNT(*) FROM cd_bcch_consents  
					WHERE deleted != 1;"
				);
			
				$num_of_bcch_consents = $num_of_bcch_consents_struct[0][0]['COUNT(*)'];
				$num_of_total_bcch_consents = $num_of_total_bcch_consents_struct[0][0]['COUNT(*)'];
			
				$data['0']['obtained_bcch_consents_nbr'] = $num_of_bcch_consents."/".$num_of_total_bcch_consents;
			}
			
			// Get new BCWH consents		
			if($search_on_date_range) {
				
				//User input a date
				
				// Get BCWH Consent that has formally consented
				$num_of_bcwh_consents_struct = $this->Report->tryCatchQuery(
					"SELECT COUNT(*) FROM cd_bcwh_consents  
					WHERE bcwh_formal_consent='consented' 
					AND deleted != 1
					AND bcwh_date_formal_consent >= '".$start_date_for_sql."' AND bcwh_date_formal_consent <= '".$end_date_for_sql."';"
				);
			
				// Get all the BCWH Consent
				$num_of_total_bcwh_consents_struct = $this->Report->tryCatchQuery(
					"SELECT COUNT(*) FROM cd_bcwh_consents  
					WHERE deleted != 1
					AND bcwh_date_formal_consent >= '".$start_date_for_sql."' AND bcwh_date_formal_consent <= '".$end_date_for_sql."';"
				);
			
				$num_of_bcwh_consents = $num_of_bcwh_consents_struct[0][0]['COUNT(*)'];
				$num_of_total_bcwh_consents = $num_of_total_bcwh_consents_struct[0][0]['COUNT(*)'];
			
				$data['0']['obtained_bcwh_consents_nbr'] = $num_of_bcwh_consents."/".$num_of_total_bcwh_consents;
				
			} else {
				
				//User didn't input a date
				
				// Get BCWH Consent that has formally consented			
				$num_of_bcwh_consents_struct = $this->Report->tryCatchQuery(
					"SELECT COUNT(*) FROM cd_bcwh_consents  
					WHERE bcwh_formal_consent='consented' 
					AND deleted != 1;"
				);
			
				// Get all the BCWH Consent
				$num_of_total_bcwh_consents_struct = $this->Report->tryCatchQuery(
					"SELECT COUNT(*) FROM cd_bcwh_consents  
					WHERE deleted != 1;"
				);
			
				$num_of_bcwh_consents = $num_of_bcwh_consents_struct[0][0]['COUNT(*)'];
				$num_of_total_bcwh_consents = $num_of_total_bcwh_consents_struct[0][0]['COUNT(*)'];
			
				$data['0']['obtained_bcwh_consents_nbr'] = $num_of_bcwh_consents."/".$num_of_total_bcwh_consents;
			}
			
			// Get new BCWH Maternal consents		
			if($search_on_date_range) {
				
				//User input a date
				
				// Get BCWH Maternal Consent that has formally consented
				$num_of_bcwh_maternal_consents_struct = $this->Report->tryCatchQuery(
					"SELECT COUNT(*) FROM cd_bcwh_maternal_consents  
					WHERE bcwh_maternal_formal_consent='consented' 
					AND deleted != 1
					AND bcwh_maternal_date_formal_consent >= '".$start_date_for_sql."' AND bcwh_maternal_date_formal_consent <= '".$end_date_for_sql."';"
				);
			
				// Get all the BCWH Maternal Consent
				$num_of_total_bcwh_maternal_consents_struct = $this->Report->tryCatchQuery(
					"SELECT COUNT(*) FROM cd_bcwh_maternal_consents  
					WHERE deleted != 1
					AND bcwh_maternal_date_formal_consent >= '".$start_date_for_sql."' AND bcwh_maternal_date_formal_consent <= '".$end_date_for_sql."';"
				);
			
				$num_of_bcwh_maternal_consents = $num_of_bcwh_maternal_consents_struct[0][0]['COUNT(*)'];
				$num_of_total_bcwh_maternal_consents = $num_of_total_bcwh_maternal_consents_struct[0][0]['COUNT(*)'];
			
				$data['0']['obtained_bcwh_maternal_consents_nbr'] = $num_of_bcwh_maternal_consents."/".$num_of_total_bcwh_maternal_consents;
				
			} else {
				
				//User didn't input a date
				
				// Get BCWH Maternal Consent that has formally consented			
				$num_of_bcwh_maternal_consents_struct = $this->Report->tryCatchQuery(
					"SELECT COUNT(*) FROM cd_bcwh_maternal_consents  
					WHERE bcwh_maternal_formal_consent='consented' 
					AND deleted != 1;"
				);
			
				// Get all the BCWH Maternal Consent
				$num_of_total_bcwh_maternal_consents_struct = $this->Report->tryCatchQuery(
					"SELECT COUNT(*) FROM cd_bcwh_maternal_consents  
					WHERE deleted != 1;"
				);
			
				$num_of_bcwh_maternal_consents = $num_of_bcwh_maternal_consents_struct[0][0]['COUNT(*)'];
				$num_of_total_bcwh_maternal_consents = $num_of_total_bcwh_maternal_consents_struct[0][0]['COUNT(*)'];
			
				$data['0']['obtained_bcwh_maternal_consents_nbr'] = $num_of_bcwh_maternal_consents."/".$num_of_total_bcwh_maternal_consents;
			}
			
					
			// Get new collections
			$conditions = $search_on_date_range? "col.collection_datetime >= '$start_date_for_sql' AND col.collection_datetime <= '$end_date_for_sql'" : 'TRUE';
			$new_collections_nbr = $this->Report->tryCatchQuery(
				"SELECT COUNT(*) FROM (
					SELECT DISTINCT col.participant_id 
					FROM sample_masters AS sm 
					INNER JOIN collections AS col ON col.id = sm.collection_id 
					WHERE col.participant_id IS NOT NULL 
					AND col.participant_id != '0'
					AND ($conditions)
					AND col.deleted != '1'
					AND sm.deleted != '1'
				) AS res;");
			$data['0']['new_collections_nbr'] = $new_collections_nbr[0][0]['COUNT(*)'];
			
			$array_to_return = array(
				'header' => $header, 
				'data' => $data, 
				'columns_names' => null,
				'error_msg' => null);
			
			return $array_to_return;
			
			}
			
	}