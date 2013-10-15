<?php

class EventMasterCustom extends EventMaster {
	var $name = 'EventMaster';
	var $useTable = 'event_masters';
	
	function summary( $variables=array() ) {
		$return = false;
	
		if ( isset($variables['EventMaster.id'])) {
	
			$result = $this->find('first', array('conditions'=>array('EventMaster.id'=>$variables['EventMaster.id'])));
	
			$return = array(
					'menu'			=>	array( NULL, __($result['EventControl']['event_type'], TRUE)),
					'title'			=>	array( NULL, __($result['EventControl']['event_type'], TRUE)),
					'data'				=> $result,
					'structure alias'	=> 'eventmasters'
			);
		}else if(isset($variables['EventControl.id'])){
			$return = array();
		}
	
		return $return;
	}
	
	function validates($options = array()) {
		parent::validates($options);
	
		if(isset($this->data['EventDetail']) && array_key_exists('vital_status', $this->data['EventDetail'])) {
			if(empty($this->data['EventMaster']['event_date'])){ 
				$this->validationErrors['result'][] = 'follow-up date can not be empty';
			}
		}
	
		return empty($this->validationErrors);
	}
	
}
?>