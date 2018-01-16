<?php

class EventMasterCustom extends EventMaster {
	var $useTable = 'event_masters';
	var $name = 'EventMaster';
	
	private $event_type_for_data_entry_validation = null;
	
	function setEventTypeForDataEntryValidation($event_type_for_data_entry_validation) {
		$this->event_type_for_data_entry_validation = $event_type_for_data_entry_validation;
	}
		
	function validates($options = Array()) {
		$result = parent::validates($options);
		
		if($this->event_type_for_data_entry_validation) {
			switch($this->event_type_for_data_entry_validation) {
				case 'clinical exam':
					//Rules:
					// - If progression/comorbidity set, result should be 'suspicious' or 'positive'.
					// - If exam is a exam of the prostate no comorbidity or progression should be set
					if(strlen($this->data['EventDetail']['progression_comorbidity'])) {
						if(!in_array($this->data['EventDetail']['results'], array('suspicious', 'positive'))) {
							$this->validationErrors['results'][] = __('result should be set to positive or suspicious for any progression or comorbidity diagnosis');
							$result = false;
						}
						if($this->data['EventDetail']['site_precision'] == 'prostate') {
							$this->validationErrors['results'][] = __('no progression/comorbidity should be set for a prostate clinical exam');
							$result = false;
						}
					}
					break;
				case 'clinical note':
					//Rules:
					// - Notes should be set
					if(!strlen($this->data['EventMaster']['event_summary'])) {
						$this->validationErrors['event_summary'][] = __('value is required');
						$result = false;
					}
					break;
				case 'laboratory':
					//Rules:
					// - A value should be set
					if(!strlen($this->data['EventDetail']['psa_total_ngml'].$this->data['EventDetail']['testosterone_nmoll']) 
					&& $this->data['EventDetail']['biochemical_relapse'] != 'y') {
						$this->validationErrors[][] = __('at least a psa or testosterone value should be set');
						$result = false;
					}
					break;
				case 'visit/contact':
					if(empty($this->data['EventMaster']['event_date'])) {
						$this->validationErrors['event_date'][] = __('the visite date has to be completed');
						$result = false;
					}
					break;
			}
		}
		
		return $result;	
	}
}

?>