<?php 
	
	//Cannot be added to Collection model because user of PROCESSING bank can delete a collection
	//Note there is no interest to add control for CENTRAL BANK because data will be erased
	if(Configure::read('procure_atim_version') != 'BANK') $this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
	
	if(empty($this->request->data)) {
		if(!$this->Collection->find('count', array('conditions' => array('Collection.participant_id IS NULL', 'Collection.collection_property' => 'participant collection'), 'recursive' => '-1'))) {
			//To skip collection selection step
			$this->request->data['Collection']['id'] = null;
		}		
	}
	