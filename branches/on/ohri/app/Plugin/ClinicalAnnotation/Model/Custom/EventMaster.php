<?php

class EventMasterCustom extends EventMaster {
	
	var $useTable = 'event_masters';
	var $name = 'EventMaster';
	
	function summary( $variables=array() ) {
		$return = false;
	
		if ( isset($variables['EventMaster.id'])) {
				
			$result = $this->find('first', array('conditions'=>array('EventMaster.id'=>$variables['EventMaster.id'])));
				
			$return = array(
				'menu'			=>	array( NULL, __($result['EventControl']['event_type'], TRUE)),
				'title'			=>	array( NULL, __('annotation', TRUE) ),
				'data'				=> $result,
				'structure alias'	=> 'eventmasters'
			);
		}else if(isset($variables['EventControl.id'])){
			$return = array();
		}
	
		return $return;
	}
}
