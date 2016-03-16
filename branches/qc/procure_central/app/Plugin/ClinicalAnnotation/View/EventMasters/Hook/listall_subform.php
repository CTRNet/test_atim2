<?php  

	if(isset($new_control['EventControl']['event_type']) && in_array($new_control['EventControl']['event_type'], array('procure follow-up worksheet - aps','procure follow-up worksheet - clinical event','procure follow-up worksheet - clinical note','procure follow-up worksheet - other tumor dx'))) {
		$final_options['settings']['language_heading'] = $final_options['settings']['header'];
		unset($final_options['settings']['header']);
	}
