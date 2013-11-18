<?php

class EventMasterCustom extends EventMaster {
	var $name 		= "EventMaster";
	var $tableName	= "event_masters";
	
	function summary( $variables=array() ) {
		$return = false;
		
		if ( isset($variables['EventMaster.id']) ) {
			
			$result = $this->find('first', array('conditions'=>array('EventMaster.id'=>$variables['EventMaster.id'])));
			
			$return = array(
				'menu'    			=> array( NULL, __($result['EventControl']['event_type'], TRUE)),
				'title'	 			=> array( NULL, __($result['EventControl']['event_type'], TRUE)),
				'data'				=> $result,
				'structure alias'	=> 'Eventmasters'
			);
		}
		
		return $return;
	}
	
	function afterSave($created){
		$DiagnosisMaster = AppModel::getInstance("ClinicalAnnotation", "DiagnosisMaster", true);
		if(isset($this->data['EventMaster']['diagnosis_master_id']) && $this->data['EventMaster']['diagnosis_master_id']) $DiagnosisMaster->validateLaterality($this->data['EventMaster']['diagnosis_master_id']);
		parent::afterSave($created);
	}

}

?>