<?php 
	
	if(($event_master_data['EventControl']['event_type'] == 'procure follow-up worksheet') && ($this->request->data['EventMaster']['procure_form_identification'] != $event_master_data['EventMaster']['procure_form_identification'])) {
		$this->request->data['EventMaster']['tmp_launch_linked_event_update'] = 1;
	} else {
		$this->request->data['EventMaster']['tmp_launch_linked_event_update'] = 0;
	}	
	