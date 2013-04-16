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
		
		if(isset($this->data['EventDetail']) && array_key_exists('result', $this->data['EventDetail'])) {
			if(!strlen(str_replace(' ','',$this->data['EventDetail']['result']))) {
				$this->validationErrors['result'][] = 'experimental test result can not be empty';
			}
		}
		
		if(isset($this->data['EventDetail']) && array_key_exists('apparent_pathological_stage', $this->data['EventDetail'])) {	
			if($this->data['EventDetail']['apparent_pathological_stage_precision'] && !in_array($this->data['EventDetail']['apparent_pathological_stage'], array('pIc', 'pIIc'))) {
				$this->validationErrors['apparent_pathological_stage_precision'][] = 'precision has to be set for pIc and pIIc';
			}
		}
		
		return empty($this->validationErrors);
	}
	
	
	
	
}
?>