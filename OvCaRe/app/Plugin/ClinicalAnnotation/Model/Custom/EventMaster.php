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
	
	function beforeValidate($options) {
		$res = parent::beforeValidate($options);
		if(isset($this->data['EventDetail']) && array_key_exists('result', $this->data['EventDetail'])) {
			if(!strlen(str_replace(' ','',$this->data['EventDetail']['result']))) {
				$this->validationErrors['result'][] = 'experimental test result can not be empty';
			}			
		}
		return $res;
	}
	
}
?>