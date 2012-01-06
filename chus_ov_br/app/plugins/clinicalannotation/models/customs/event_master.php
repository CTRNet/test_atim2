<?php
class EventMasterCustom extends EventMaster{
	var $useTable = 'event_masters';
	var $name = 'EventMaster';
	
	function beforeValidate($options) {
		// Convert
	pr('calculate imc')	
//		if(isset($this->data['FunctionManagement']['chus_weight']) && !empty($this->data['FunctionManagement']['chus_weight']) && is_numeric($this->data['FunctionManagement']['chus_weight'])) {
//			if(!in_array($this->data['FunctionManagement']['chus_weight_unit'], array('kg','lbs'))) {
//				$this->validationErrors['chus_weight_unit'] = 'please select a unit';
//			} else {
//				switch() {
//					
//					
//				}
//				
//				
//				
//				
//				
//				
//				
//				
//				
//				
//			}
//		}
//		
//		if(isset($this->data['FunctionManagement']['chus_height']) && !empty($this->data['FunctionManagement']['chus_height']) && is_numeric($this->data['FunctionManagement']['chus_height'])) {
//			if(!in_array($this->data['FunctionManagement']['chus_height_unit'], array('cm','foots'))) {
//				$this->validationErrors['chus_height_unit'] = 'please select a unit';
//			} else {
//				
//			}
//		}	
//			
//		//Calculate ICM
//		
//		
//		
//		
//		
//	
//
//
//
////Conversion des Pieds ( foot ) en Mètres : Multiplier par 0,3047
////Conversion des Livres ( lb ) en Kilogrammes : Multiplier par 0,45359
//		
//		
//		
		
		
	}
	
	function addBmiValue( $event_data ) {
		if((isset($event_data['EventDetail']['weight']))
		&& (isset($event_data['EventDetail']['height']))) {
			// Format 'numeric' value
			$event_data['EventDetail']['weight'] = str_replace(',', '.', $event_data['EventDetail']['weight']);
			$event_data['EventDetail']['height'] = str_replace(',', '.', $event_data['EventDetail']['height']);
				
			$weight = $event_data['EventDetail']['weight'];
			$height = $event_data['EventDetail']['height'];
				
			if(is_numeric($weight) && is_numeric($height) && (!empty($height))) {
				$event_data['EventDetail']['bmi'] =  ($weight/($height*$height)) * 10000;
			}
		}
	
		return $event_data;
	}
	
}