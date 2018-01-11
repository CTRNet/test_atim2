<?php 
	
	// Clinical file update process
	if (empty($this->request->data)) {			
		$this->Participant->setNextUrlOfTheClinicalFileUpdateProcess($participant_id, $this->passedArgs);
		if(strpos(implode('', $this->passedArgs), 'clinical_file_update_process_step') !== false && isset($_SESSION['procure_clinical_file_update_process'])) {
			//Set default data
			$now_query = "SELECT DATE_FORMAT(NOW(),'%Y-%m-%d') as 'created_date' FROM users LIMIT 0,1";
			$now_data = $this->Participant->query($now_query);
			$now_date = $now_data[0][0]['created_date'];
			
			
			// *** 1 *** Set the date of the last chart checked date
			//    - If date of the visit completed today during this clinical file update process 
			//          then set by default the last chart checked date to this visite date 
			//          if this one is bigger than the existing last chart checked date
			//    - Else if the current date is bigger than the last chart checked date
			//          then set by default the last chart checked date to the current date
			
			//Check a visit/contact form has just been completed by user
			$visit_contact_form_conditions = array(
					'EventMaster.participant_id' => $participant_id,
					'EventControl.event_type' => 'visit/contact',
					"EventMaster.created LIKE '$now_date%'",
					'EventMaster.created_by' => $_SESSION['Auth']['User']['id']);
			$last_visit_date_completed_today = $this->EventMaster->find('first', array('conditions' => $visit_contact_form_conditions, 'order' => array('EventMaster.event_date DESC')));
			
			$last_chart_checked_date_in_database = '';
			if(preg_match('/^([0-9]{4})\-([0-9]{2})\-([0-9]{2})$/', $participant_data['Participant']['last_chart_checked_date'], $matches)) {
				switch($participant_data['Participant']['last_chart_checked_date_accuracy']) {
					case 'd':
						$last_chart_checked_date_in_database = $matches[1].'-'.$matches[2];
						break;
					case 'm':
					case 'y':
						$last_chart_checked_date_in_database = $matches[1];
						break;
					default:
						$last_chart_checked_date_in_database = $participant_data['Participant']['last_chart_checked_date'];
				}
				$last_chart_checked_date_in_database = __("the 'last chart checked date' is currently set to '%s'", $last_chart_checked_date_in_database);
			}
			
			if($last_visit_date_completed_today) {
				if($last_visit_date_completed_today['EventMaster']['event_date'] > $participant_data['Participant']['last_chart_checked_date']) {
					AppController::addWarningMsg(__('set last chart checked date to the date of the visit of the form you compelted today').' '.$last_chart_checked_date_in_database);
					$participant_data['Participant']['last_chart_checked_date'] = $last_visit_date_completed_today['EventMaster']['event_date'];
					$participant_data['Participant']['last_chart_checked_date_accuracy'] = $last_visit_date_completed_today['EventMaster']['event_date_accuracy'];
				}
			} else {
				if($now_date > $participant_data['Participant']['last_chart_checked_date']) {
					AppController::addWarningMsg(__('set last chart checked date to the current date').' '.$last_chart_checked_date_in_database);
					$participant_data['Participant']['last_chart_checked_date'] = $now_date;
					$participant_data['Participant']['last_chart_checked_date_accuracy'] = 'c';
				}
			}
			
			// *** 2 *** Last contact date
			
			$procure_last_contact_in_database = '';
			if(preg_match('/^([0-9]{4})\-([0-9]{2})\-([0-9]{2})$/', $participant_data['Participant']['procure_last_contact'], $matches)) {
			    switch($participant_data['Participant']['procure_last_contact_accuracy']) {
			        case 'd':
			            $procure_last_contact_in_database = $matches[1].'-'.$matches[2];
			            break;
			        case 'm':
			        case 'y':
			            $procure_last_contact_in_database = $matches[1];
			            break;
			        default:
			            $procure_last_contact_in_database = $participant_data['Participant']['procure_last_contact'];
			    }
			    $procure_last_contact_in_database = __("the 'last contact date' is currently set to '%s'", $procure_last_contact_in_database);
			}
			
			if($last_visit_date_completed_today) {
			    if($last_visit_date_completed_today['EventMaster']['event_date'] > $participant_data['Participant']['procure_last_contact']) {
			        AppController::addWarningMsg(__('set last contact date to the date of the visit of the form you compelted today').' '.$procure_last_contact_in_database);
			        $participant_data['Participant']['procure_last_contact'] = $last_visit_date_completed_today['EventMaster']['event_date'];
			        $participant_data['Participant']['procure_last_contact_accuracy'] = $last_visit_date_completed_today['EventMaster']['event_date_accuracy'];
			    }
			}
		}
	}
	$this->Participant->addClinicalFileUpdateProcessInfo();
	