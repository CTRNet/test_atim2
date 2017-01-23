<?php 
	
	//Cannot be added to Participant model because participant record will be updated by system for any MiscIdentifier creation/modification
	//And there are no interest to ad control for CENTRAL BANK because data will be erased
	if(Configure::read('procure_atim_version') != 'BANK') $this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
	
	// Clinical file update process
	if (empty($this->request->data)) {
		$this->Participant->setNextUrlOfTheClinicalFileUpdateProcess($participant_id, $this->passedArgs);
	
		//Set default data
		$now_query = "SELECT DATE_FORMAT(NOW(),'%Y-%m-%d') as 'created_date' FROM users LIMIT 0,1";
		$now_data = $this->Participant->query($now_query);
		$now_date = $now_data[0][0]['created_date'];
		
		//Check a visit/contact form has just been completed by user
		$visit_contact_form_conditions = array(
				'EventMaster.participant_id' => $participant_id,
				'EventControl.event_type' => 'visit/contact',
				"EventMaster.created LIKE '$now_date%'",
				'EVentMaster.created_by' => $_SESSION['Auth']['User']['id']);
		$last_visite_contact = $this->EventMaster->find('first', array('conditions' => $visit_contact_form_conditions, 'orders' => array('EventMaster.created DESC')));
		if($last_visite_contact) {
			$participant_data['Participant']['last_chart_checked_date'] = $last_visite_contact['EventMaster']['event_date'];
			$participant_data['Participant']['last_chart_checked_date_accuracy'] = $last_visite_contact['EventMaster']['event_date_accuracy'];
		} else {
			$participant_data['Participant']['last_chart_checked_date'] = $now_date;
			$participant_data['Participant']['last_chart_checked_date_accuracy'] = 'c';
		}
	}
	$this->Participant->addClinicalFileUpdateProcessInfo();
	