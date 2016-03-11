<?php
	
	if($event_master_data['EventControl']['event_type'] == 'study inclusion based on filemaker')
		$this->flash(__('no new data supposed to be created'), 'javascript:history.back()');
	
?>