<?php  
	
	if(isset($new_control['TreatmentControl']['tx_method']) && in_array($new_control['TreatmentControl']['tx_method'], array('procure follow-up worksheet - treatment'))) {
		$final_options['settings']['language_heading'] = $final_options['settings']['header'];
		$final_options['settings']['header'] = __('procure follow-up worksheet');
	} else if(isset($new_control['TreatmentControl']['tx_method']) && in_array($new_control['TreatmentControl']['tx_method'], array('procure follow-up worksheet - other tumor tx'))) {
		$final_options['settings']['language_heading'] = $final_options['settings']['header'];
		unset($final_options['settings']['header']);
	} else if(isset($new_control['TreatmentControl']['tx_method']) && in_array($new_control['TreatmentControl']['tx_method'], array('procure medication worksheet - drug'))) {
		$final_options['settings']['language_heading'] = $final_options['settings']['header'];
		unset($final_options['settings']['header']);
	} else {
		unset($final_options['settings']['language_heading']);
	}
	