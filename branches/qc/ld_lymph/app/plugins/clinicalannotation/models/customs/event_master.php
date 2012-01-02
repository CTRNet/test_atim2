<?php

class EventMasterCustom extends EventMaster {
	
	var $useTable = 'event_masters';	
	var $name = 'EventMaster';	
	
	function beforeSave($options) {
		if(array_key_exists('pe_imag_lymph_node_waldeyers_ring', $this->data['EventDetail'])) {
			$score = 0;
			
			foreach($this->data['EventDetail'] as $key => $value) { 
				if((!in_array($key, array('pe_imag_lymph_node_other_desc','pe_imag_lymph_node_score'))) && (strpos($key, 'pe_imag_lymph_node_') === 0) && ($value == 'y')) $score++; 
			}
			$this->data['EventDetail']['pe_imag_lymph_node_score'] = $score;
		}
		
		return true;
	}
	
	function summary( $variables=array() ) {
		$return = false;
	
		if ( isset($variables['EventMaster.id'])) {
				
			$result = $this->find('first', array('conditions'=>array('EventMaster.id'=>$variables['EventMaster.id'])));
				
			$return = array(
					'menu'			=>	array( NULL, __($result['EventControl']['disease_site'], TRUE).' - '.__($result['EventControl']['event_type'], TRUE) ),
					'title'			=>	array( NULL, __('annotation', TRUE) ),
					'data'				=> $result,
					'structure alias'	=> 'eventmasters'
			);
		} else if ( isset($variables['EventControl.id'])) {
				
			
			$event_control_model = AppModel::getInstance("Clinicalannotation", "EventControl", true);
			$result = $event_control_model->find('first', array('conditions'=>array('EventControl.id'=>$variables['EventControl.id'])));
				
			$return = array(
					'menu'			=>	array( NULL, __($result['EventControl']['disease_site'], TRUE).' - '.__($result['EventControl']['event_type'], TRUE) ),
					'title'			=>	null,
					'data'				=> null,
					'structure alias'	=> null
			);
		}
	
		return $return;
	}
	
}

?>