<?php 
	
	//Cannot be added to Participant model because participant record will be updated by system for any MiscIdentifier creation/modification
	//And there are no interest to ad control for CENTRAL BANK because data will be erased
	if(Configure::read('procure_atim_version') != 'BANK') $this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
	
	// Clinical file update process
	if (empty($this->request->data)) {			
		$this->Participant->setNextUrlOfTheClinicalFileUpdateProcess($participant_id, $this->passedArgs);
		if(strpos(implode('', $this->passedArgs), 'clinical_file_update_process_step') !== false && isset($_SESSION['procure_clinical_file_update_process'])) {
			//Set default data
			$now_query = "SELECT DATE_FORMAT(NOW(),'%Y-%m-%d') as 'created_date' FROM users LIMIT 0,1";
			$now_data = $this->Participant->query($now_query);
			$now_date = $now_data[0][0]['created_date'];
			
			//Check a visit/contact form has just been completed by user
			$visit_contact_form_conditions = array(
					'EventMaster.participant_id' => $participant_id,
					'EventControl.event_type' => 'visit/contact',
					"EventMaster.created LIKE '$now_date%'",
					'EventMaster.created_by' => $_SESSION['Auth']['User']['id']);
			$last_visite_contact = $this->EventMaster->find('first', array('conditions' => $visit_contact_form_conditions, 'order' => array('EventMaster.event_date DESC')));
			
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
			
			if($last_visite_contact) {
				if($last_visite_contact['EventMaster']['event_date'] > $participant_data['Participant']['last_chart_checked_date']) {
					AppController::addWarningMsg(__('set last chart checked date to the date of the visit of the form you compelted today').' '.$last_chart_checked_date_in_database);
					$participant_data['Participant']['last_chart_checked_date'] = $last_visite_contact['EventMaster']['event_date'];
					$participant_data['Participant']['last_chart_checked_date_accuracy'] = $last_visite_contact['EventMaster']['event_date_accuracy'];
				}
			} else {
				if($now_date > $participant_data['Participant']['last_chart_checked_date']) {
					AppController::addWarningMsg(__('set last chart checked date to the current date').' '.$last_chart_checked_date_in_database);
					$participant_data['Participant']['last_chart_checked_date'] = $now_date;
					$participant_data['Participant']['last_chart_checked_date_accuracy'] = 'c';
				}
			}
		}
	}
	$this->Participant->addClinicalFileUpdateProcessInfo();
	