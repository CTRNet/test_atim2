<?php 
	
	if(in_array($event_master_data['EventControl']['event_type'], array( 'procure follow-up worksheet - clinical event','procure follow-up worksheet - aps'))) {
		$this->set('followup_identification_list', $this->EventMaster->getFollowupIdentificationFromId($participant_id));
	}
		
		
	
