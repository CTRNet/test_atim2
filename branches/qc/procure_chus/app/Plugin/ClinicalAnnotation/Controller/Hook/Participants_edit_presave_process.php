<?php 
	
	if($participant_data['Participant']['participant_identifier'] != $this->request->data['Participant']['participant_identifier']) $this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
	
	// Add warning on participant of another bank that is not transferred...
	if(strpos($participant_data['Participant']['participant_identifier'], 'PS'.Configure::read('procure_bank_id')) === false 
    && $this->request->data['Participant']['procure_transferred_participant'] == 'n' 
    && $participant_data['Participant']['procure_transferred_participant'] != $this->request->data['Participant']['procure_transferred_participant']) { 
	    AppController::addWarningMsg(__('system does not allow you to define a participant of another bank from transferred to not transferred'));
	}