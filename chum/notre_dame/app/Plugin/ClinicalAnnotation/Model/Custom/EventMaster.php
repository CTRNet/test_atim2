<?php

class EventMasterCustom extends EventMaster {
	var $useTable = 'event_masters';
	var $name = "EventMaster";
	
	function beforeSave($options = array()) {
		
		if(isset($this->data['EventMaster']['diagnosis_master_id']) && $this->data['EventMaster']['diagnosis_master_id']) {
			unset($this->data['EventMaster']['diagnosis_master_id']);
			AppController::addWarningMsg('no event can be linked to a diagnosis because diagnosis data comes from SARDO');
		}
		if(isset($this->data['EventMaster']['event_control_id'])) {
			$event_control = AppModel::getInstance('ClinicalAnnotation', 'EventControl', true);
			$event_control_data = $event_control->find('first', array('conditions' => array('id' => $this->data['EventMaster']['event_control_id'])));
			if(!in_array($event_control_data['EventControl']['event_type'], $event_control->modifiable_event_types)) {
//Generate an error in merge process				
//				AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
			}
		} else if($this->id) {
			$event_data = $this->find('first', array('conditions' => array('EventMaster.id' => $this->id)));
			$event_control = AppModel::getInstance('ClinicalAnnotation', 'EventControl', true);
			if(!in_array($event_data['EventControl']['event_type'], $event_control->modifiable_event_types)) {
//Generate an error in merge process				
//				AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
			}
		} else {
//Generate an error in merge process				
//			AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		}
		return parent::beforeSave($options);
	}
}
