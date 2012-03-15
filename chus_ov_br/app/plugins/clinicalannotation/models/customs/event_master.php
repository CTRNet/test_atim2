<?php
class EventMasterCustom extends EventMaster{
	var $useTable = 'event_masters';
	var $name = 'EventMaster';
	
	function beforeValidate($options) {
		
		//-------------------------------------------------------------------------------------------------------
		// EventMaster - CHUS - Followup
		//-------------------------------------------------------------------------------------------------------
		$weight_in_kg_for_bmi = null;
		if(array_key_exists('weight_in_kg', $this->data['EventDetail'])) {
			$weight_in_kg = str_replace(',', '.', $this->data['EventDetail']['weight_in_kg']);
			
			if(($weight_in_kg != '') && is_numeric($weight_in_kg) && $weight_in_kg == 0) {
				$this->validationErrors[] = "weight or height can not be equal to 0";
			} else {
				$weight_in_kg_for_bmi = $weight_in_kg;
				$this->data['EventDetail']['weight_in_kg'] = $weight_in_kg;
			}
		}
		
		$height_in_cm_for_bmi = null;
		if(array_key_exists('height_in_cm', $this->data['EventDetail'])) {
			$height_in_cm = str_replace(',', '.', $this->data['EventDetail']['height_in_cm']);
			
			if(($height_in_cm != '') && is_numeric($height_in_cm) && $height_in_cm == 0) {
				$this->validationErrors[] = "weight or height can not be equal to 0";
			} else {
				$height_in_cm_for_bmi = $height_in_cm;
				$this->data['EventDetail']['height_in_cm'] = $height_in_cm;
			}
		}
		
		if(!is_null($weight_in_kg_for_bmi) && !is_null($height_in_cm_for_bmi)) {
			$this->data['EventDetail']['bmi'] = ($weight_in_kg_for_bmi/($height_in_cm_for_bmi*$height_in_cm_for_bmi)) * 10000;	
		}
	}
		
}