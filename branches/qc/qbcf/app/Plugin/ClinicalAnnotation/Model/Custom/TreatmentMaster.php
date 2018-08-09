<?php

class TreatmentMasterCustom extends TreatmentMaster {
	var $useTable = 'treatment_masters';
	var $name = 'TreatmentMaster';
	
	public function validatesTreatmentToDiagnosisLink($treatmentMasterData, $treatmentControlData){
		
		$submittedDataValidates = true;
		if(!isset($treatmentMasterData['diagnosis_master_id']) || !$treatmentMasterData['diagnosis_master_id']) {
			$this->validationErrors['diagnosis_master_id'][] = __('a diagnosis should be selected');
			$submittedDataValidates = false;
		} else {
			$DiagnosisMaster = AppModel::getInstance("ClinicalAnnotation", "DiagnosisMaster", true);
			$selectedDx = $DiagnosisMaster->find('first', array('conditions'=> array('DiagnosisMaster.id' => $treatmentMasterData['diagnosis_master_id']), 'recursive' => 0));
			switch($treatmentControlData['tx_method']) {
				case 'chemotherapy':
				case 'hormonotherapy':
				case 'immunotherapy':
				case 'bone specific therapy':
				case 'radiotherapy':
				case 'breast diagnostic event':
				case 'other (breast cancer systemic treatment)':
					if($selectedDx['DiagnosisControl']['controls_type'] != 'breast') {
						$this->validationErrors['diagnosis_master_id'][] = __('this treatment can not be linked to this type of diagnosis');
						$submittedDataValidates = false;
					}
					break;
				case 'other cancer':
					if($selectedDx['DiagnosisControl']['controls_type'] != 'other cancer') {
						$this->validationErrors['diagnosis_master_id'][] = __('this treatment can not be linked to this type of diagnosis');
						$submittedDataValidates = false;
					}
					break;
				default:
					AppController::getInstance()->redirect( '/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true );
			}
		}
		return $submittedDataValidates;
	}
	
	public function beforeSave($options = array()){
		if(array_key_exists('TreatmentDetail', $this->data) && array_key_exists('her2_fish', $this->data['TreatmentDetail'])) {
			
			$her2Fish = $this->data['TreatmentDetail']['her2_fish'];
			$her2Ihc = $this->data['TreatmentDetail']['her2_ihc'];
			$erOverall = $this->data['TreatmentDetail']['er_overall'];
			$prOverall = $this->data['TreatmentDetail']['pr_overall'];
			
			// TNBC
			$her2Status = '';
			switch($her2Fish) {
				case 'positive':
					$her2Status = 'positive';
					break;
				case 'negative':
					$her2Status = 'negative';
					break;
				case 'equivocal':
					if($her2Ihc == 'positive') $her2Status = 'positive';
					if($her2Ihc == 'negative') $her2Status = 'equivocal';
					break;
				case 'unknown':
				case '':
					if($her2Ihc == 'positive') $her2Status = 'positive';
					if($her2Ihc == 'negative') $her2Status = 'negative';
			}
			
			// HER2 Status
			$tnbc = '';
			if($her2Status == 'negative' && $erOverall == 'negative' && $prOverall == 'negative' ) {
				$tnbc = 'yes';
			} elseif($her2Status == 'positive' || $erOverall == 'positive' || $prOverall == 'positive' ) {
				$tnbc = 'no';
			} elseif($her2Status == 'unknown' || $erOverall == 'unknown' || $prOverall == 'unknown' ) {
				$tnbc = 'unknown';
			} elseif($her2Status == 'equivocal' && $erOverall == 'negative' && $prOverall == 'negative' ) {
				$tnbc = 'equivocal';
			}

			$this->data['TreatmentDetail']['tnbc'] = $tnbc;
			$this->data['TreatmentDetail']['her_2_status'] = $her2Status;
			$this->addWritableField(array('tnbc', 'her_2_status'));
		}
		$retVal = parent::beforeSave($options);
		
		return $retVal; 
	}
	
	/**
	 * For each 'breast diagnostic event' treatment (breast biopsy or surgery), this function will calculate:
	 *   - The time from the treatment to the last participant contact.
	 *   - The time to the next 'breast progression' diagnosis based on date.
	 *    
	 * @param integer $participantId Id fo the participant.
	 */
	public function calculateTimesTo($participantId) {	
		//================================================================================================================================================================
		// Diagnosis & treatment reminder :
		//  - Only one breast primary diagnosis can be created per participant.
		//  - A 'breast diagnostic event' treatment can only be created for a breast primary diagnosis.
		//  - A 'breast progression' can only be created for a breast primary diagnosis.
		//  - So all 'breast diagnostic event' and 'breast progression' of one participant will be linked to the same breast primary diagnosis.
		//================================================================================================================================================================
		
		$conditions = array(
			'TreatmentMaster.deleted != 1',
			'TreatmentControl.tx_method' => 'breast diagnostic event',
			'TreatmentMaster.participant_id' => $participantId
		);
		$allBreastTxDiagnosisEvent = $this->find('all', array('conditions'=>$conditions, 'recursive' => 0));
		
		if(!$allBreastTxDiagnosisEvent) return;
		
		$allWarnings = array();
		
		// Get participant last contact or death
		$participantModel = AppModel::getInstance('ClinicalAnnotation', 'Participant', true);
		$participant = $participantModel->getOrRedirect($participantId);
		$lastContactOrDeathDate = '';
		$lastContactOrDeathDateAccuracy = '';
		if(!empty($participant['Participant']['date_of_death'])) {
			$lastContactOrDeathDate = $participant['Participant']['date_of_death'];
			$lastContactOrDeathDateAccuracy = $participant['Participant']['date_of_death_accuracy'];
		} elseif(!empty($participant['Participant']['qbcf_suspected_date_of_death'])) {
			$lastContactOrDeathDate = $participant['Participant']['qbcf_suspected_date_of_death'];
			$lastContactOrDeathDateAccuracy = $participant['Participant']['qbcf_suspected_date_of_death_accuracy'];
		}elseif(!empty($participant['Participant']['qbcf_last_contact'])) {
			$lastContactOrDeathDate = $participant['Participant']['qbcf_last_contact'];
			$lastContactOrDeathDateAccuracy = $participant['Participant']['qbcf_last_contact_accuracy'];
		} 
		if(empty($lastContactOrDeathDate)) $allWarnings["the last contact or death date is unknown - the 'time to last contact' values cannot be calculated"] = array();
		
		// Check all progression dates are set
		$conditions = array(
			'DiagnosisMaster.deleted != 1',
			'DiagnosisControl.category' => 'secondary - distant',
			'DiagnosisControl.controls_type' => 'breast progression',
			'DiagnosisMaster.participant_id' => $participantId,
			"DiagnosisMaster.dx_date IS NULL"
		);
		$DiagnosisMaster = AppModel::getInstance("ClinicalAnnotation", "DiagnosisMaster", true);
		$progressionWithNoDate = $DiagnosisMaster->find('count', array('conditions'=>$conditions, 'recursive' => 0));
		if($progressionWithNoDate) $allWarnings["at least one breast progression diagnosis date is unknown"] = array(); 
		
		// Check all breast diagnosis event dates are set
		$conditions = array(
			'TreatmentMaster.deleted != 1',
			'TreatmentControl.tx_method' => 'breast diagnostic event',
			'TreatmentMaster.participant_id' => $participantId,
			"TreatmentMaster.start_date IS NULL"
		);
		$breastDxEventWithNoDate = $this->find('count', array('conditions'=>$conditions, 'recursive' => 0));
		if($breastDxEventWithNoDate) $allWarnings["at least one breast diagnosis event date is unknown"] = array();
		
		$allBreastTxDiagnosisEventToUpdate = array();
		foreach($allBreastTxDiagnosisEvent as $newBreastTx) {
			$newTimeToLastContactMonths = '';
			$newTimeToFirstProgressionMonths = '';
			$newTimeToNextBreastDxEventMonths = '';
			if($newBreastTx['TreatmentMaster']['start_date']) {
				$startDate = $newBreastTx['TreatmentMaster']['start_date'];
				$startDateAccuracy = $newBreastTx['TreatmentMaster']['start_date_accuracy'];
				$startDateOb = new DateTime($startDate);
				// Time To Last Contcat
				if(!empty($lastContactOrDeathDate)) {
					if(in_array($startDateAccuracy.$lastContactOrDeathDateAccuracy, array('cc', 'cd', 'dc'))) {
						if($startDateAccuracy.$lastContactOrDeathDateAccuracy != 'cc') $allWarnings["'time to last contact' has been calculated with at least one unaccuracy date"][$startDate] = $startDate;
						$endDateOb = new DateTime($lastContactOrDeathDate);
						$interval = $startDateOb->diff($endDateOb);
						if($interval->invert) {
							$allWarnings["'time to last contact' cannot be calculated because dates are not chronological"][$startDate] = $startDate;
						} else {
							$newTimeToLastContactMonths = $interval->y*12 + $interval->m;
						}
					} else {
						$allWarnings["'time to last contact' cannot be calculated on inaccurate dates"][$startDate] = $startDate;
					}
				}
				// Time to first progression
				$conditions = array(
					'DiagnosisMaster.deleted != 1',
					'DiagnosisControl.category' => 'secondary - distant',
					'DiagnosisControl.controls_type' => 'breast progression',
					'DiagnosisMaster.participant_id' => $participantId,
					'DiagnosisMaster.parent_id' => $newBreastTx['TreatmentMaster']['diagnosis_master_id'],
					"DiagnosisMaster.dx_date IS NOT NULL",
					"DiagnosisMaster.dx_date >= '".$startDate."'"
				);
				$firstProgression = $DiagnosisMaster->find('first', array('conditions'=>$conditions, 'recursive' => 0, 'order' => array('DiagnosisMaster.dx_date ASC')));
				if($firstProgression) {
					$firstProgressionDate = $firstProgression['DiagnosisMaster']['dx_date'];
					$firstProgressionDateAccuracy = $firstProgression['DiagnosisMaster']['dx_date_accuracy'];
					if(in_array($startDateAccuracy.$firstProgressionDateAccuracy, array('cc', 'cd', 'dc'))) {
						if($startDateAccuracy.$firstProgressionDateAccuracy != 'cc') $allWarnings["'time to first progression' has been calculated with at least one unaccuracy date"][$startDate] = $startDate;
						$endDateOb = new DateTime($firstProgressionDate);
						$interval = $startDateOb->diff($endDateOb);
						if($interval->invert) {
							$allWarnings["'time to first progression' cannot be calculated because dates are not chronological"][$startDate] = $startDate;
						} else {
							$newTimeToFirstProgressionMonths = $interval->y*12 + $interval->m;
						}
					} else {
						$allWarnings["'time to first progression' cannot be calculated on inaccurate dates"][$startDate] = $startDate;
					}
				}
				// Time to next diagnosis event
				$conditions = array(
					'TreatmentMaster.id != '.$newBreastTx['TreatmentMaster']['id'],
					'TreatmentMaster.deleted != 1',
					'TreatmentControl.tx_method' => 'breast diagnostic event',
					'TreatmentMaster.participant_id' => $participantId,
					'TreatmentMaster.diagnosis_master_id' => $newBreastTx['TreatmentMaster']['diagnosis_master_id'],
					"TreatmentMaster.start_date IS NOT NULL",
					"TreatmentMaster.start_date > '".$startDate."'"
				);
				$nextBreastDiagnosisEvent = $this->find('first', array('conditions'=>$conditions, 'recursive' => 0, 'order' => array('TreatmentMaster.start_date ASC')));			
				if($nextBreastDiagnosisEvent) {
					$nextBreastDiagnosisEventDate = $nextBreastDiagnosisEvent['TreatmentMaster']['start_date'];
					$nextBreastDiagnosisEventDateAccuracy = $nextBreastDiagnosisEvent['TreatmentMaster']['start_date_accuracy'];
					if(in_array($startDateAccuracy.$nextBreastDiagnosisEventDateAccuracy, array('cc', 'cd', 'dc'))) {
						if($startDateAccuracy.$nextBreastDiagnosisEventDateAccuracy != 'cc') $allWarnings["'time to next breast diagnosis event' has been calculated with at least one unaccuracy date"][$startDate] = $startDate;
						$endDateOb = new DateTime($nextBreastDiagnosisEventDate);
						$interval = $startDateOb->diff($endDateOb);
						if($interval->invert) {
							$allWarnings["'time to next breast diagnosis event' cannot be calculated because dates are not chronological"][$startDate] = $startDate;
						} else {
							$newTimeToNextBreastDxEventMonths = $interval->y*12 + $interval->m;							
						}
					} else {
						$allWarnings["'time to next breast diagnosis event' cannot be calculated on inaccurate dates"][$startDate] = $startDate;
					}
				}
			} else {
				$allWarnings["at least one breast diagnostic event date is unknown - the 'time to' values cannot be calculated for 'un-dated' event"] = array();
			}
			//Update data
			$treatmentDetailToUpdate = array();
			if($newTimeToLastContactMonths !== $newBreastTx['TreatmentDetail']['time_to_last_contact_months']) $treatmentDetailToUpdate['time_to_last_contact_months'] = $newTimeToLastContactMonths;
			if($newTimeToFirstProgressionMonths !== $newBreastTx['TreatmentDetail']['time_to_first_progression_months']) $treatmentDetailToUpdate['time_to_first_progression_months'] = $newTimeToFirstProgressionMonths;
			if($newTimeToNextBreastDxEventMonths !== $newBreastTx['TreatmentDetail']['time_to_next_breast_dx_event_months']) $treatmentDetailToUpdate['time_to_next_breast_dx_event_months'] = $newTimeToNextBreastDxEventMonths;
			if($treatmentDetailToUpdate) {
				$allBreastTxDiagnosisEventToUpdate[] = array(
					'TreatmentMaster' => array('id' => $newBreastTx['TreatmentMaster']['id']),
					'TreatmentDetail' => $treatmentDetailToUpdate);
			}
		}
		foreach($allBreastTxDiagnosisEventToUpdate as $newBreastTxDiagnosisEventToUpdate) {
			$this->data = array(); // *** To guaranty no merge will be done with previous data ***
			$this->id = $newBreastTxDiagnosisEventToUpdate['TreatmentMaster']['id'];			
			if(!$this->save($newBreastTxDiagnosisEventToUpdate, false)) {
				$this->redirect('/Pages/err_plugin_record_err?method='.__METHOD__.',line='.__LINE__, null, true);
			}
		}
		foreach($allWarnings as $newWarning => $allStartDates) AppController::getInstance()->addWarningMsg(__($newWarning).($allStartDates? ' - '.str_replace('%s', implode(', ', $allStartDates), __('see treatment done on %s')) : ''));
	}
}