<?php

if($initial_display) {
	$submitted_data_validates = false;
} else if($multi_add) {
	$submitted_data_validates = false;
	
	$event_master_data_to_merge = array(
		'participant_id' => $this->request->data['EventMaster']['participant_id'],
		'diagnosis_master_id' => $this->request->data['EventMaster']['diagnosis_master_id'],
		'event_control_id' => $this->request->data['EventMaster']['event_control_id']);
	unset($this->request->data['EventMaster']);	
	$submitted_data = $this->request->data;
	unset($this->request->data);
	
	$errors = array();
	$line_counter = 0;
	$events_data_to_save = array();
	foreach($submitted_data as $new_event) {
		if(isset($new_event['EventDetail']['result']) && !strlen($new_event['EventDetail']['result'])) continue;	//To remove empty line in case data have to been re-displayed
		$line_counter++;
		$new_event['EventMaster'] = array_merge($new_event['EventMaster'], $event_master_data_to_merge);
		$this->EventMaster->data = array(); // *** To guaranty no merge will be done with previous data ***
		$this->EventMaster->set($new_event);
		if(!$this->EventMaster->validates()){
			foreach($this->EventMaster->validationErrors as $field => $msgs) {
				foreach($msgs as $new_message) $errors[$field][$new_message][] = $line_counter;
			}
		}
		$events_data_to_save[] = $this->EventMaster->data;
	}
	if(empty($errors) && $events_data_to_save) {
		$this->EventMaster->addWritableField(array('participant_id', 'event_control_id', 'diagnosis_master_id'));
		$this->EventMaster->writable_fields_mode = 'addgrid';
		foreach($events_data_to_save as $new_event) {
			$this->EventMaster->id = null;
			$this->EventMaster->data = array(); // *** To guaranty no merge will be done with previous data ***
			$new_event['EventMaster']['id'] = null;
			if(!$this->EventMaster->save($new_event, false)) $this->redirect('/Pages/err_plugin_record_err?method='.__METHOD__.',line='.__LINE__, null, true);
		}
		$this->atimFlash( 'your data has been updated','/ClinicalAnnotation/EventMasters/listall/'.$event_group.'/'.$participant_id);
			
	} else {
		if(empty($events_data_to_save)) {
			$errors['result'][__('at least one record has to be completed', true)][] = '';
			$this->request->data = $submitted_data;
		} else {
			$this->request->data = $events_data_to_save;
		}
		//Display messages
		$this->EventMaster->validationErrors = array();
		foreach($errors as $field => $msg_and_lines) {
			foreach($msg_and_lines as $msg => $lines) {
				$msg = __($msg, true);
				if(!empty($lines)) {
					$lines_strg = implode(",", array_unique($lines));
					if(!empty($lines_strg)) $msg .= ' - ' . str_replace('%s', $lines_strg, __('see line %s'));
				}
				$this->EventMaster->validationErrors[$field][] = $msg;
			}
		}
	}
}
	

 

?>