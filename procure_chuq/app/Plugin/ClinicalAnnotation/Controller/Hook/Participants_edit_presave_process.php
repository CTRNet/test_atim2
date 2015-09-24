<?php 
	
	if($participant_data['Participant']['participant_identifier'] != $this->request->data['Participant']['participant_identifier']) $this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
	