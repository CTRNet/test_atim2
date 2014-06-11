<?php

class EventMasterCustom extends EventMaster {
	var $useTable = 'event_masters';
	var $name = "EventMaster";
	
	function beforeSave($options = array()) {
		if(isset($this->data['EventMaster']['event_control_id'])) {
			$event_control = AppModel::getInstance('ClinicalAnnotation', 'EventControl', true);
			$event_control_data = $event_control->find('first', array('conditions' => array('id' => $this->data['EventMaster']['event_control_id'])));
			if(!in_array($event_control_data['EventControl']['event_type'], $event_control->modifiable_event_types)) {
				AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
			}
		} else if($this->id) {
			$event_data = $this->find('first', array('conditions' => array('EventMaster.id' => $this->id)));
			$event_control = AppModel::getInstance('ClinicalAnnotation', 'EventControl', true);
			if(!in_array($event_data['EventControl']['event_type'], $event_control->modifiable_event_types)) {
				AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
			}
		} else {
			AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		}
		return parent::beforeSave($options);
	}
}
