<?php
class EventMasterCustom extends EventMaster{
	var $useTable = 'event_masters';
	var $name = 'EventMaster';
	
	function beforeValidate($options) {
		
		//-------------------------------------------------------------------------------------------------------
		// EventMaster - CHUS - Followup
		//-------------------------------------------------------------------------------------------------------
		$weight_in_kg_for_bmi = null;
		if(array_key_exists('weight_in_kg', $this->data['EventDetail']) && array_key_exists('weight_in_lbs', $this->data['EventDetail'])) {
			$weight_in_kg = str_replace(',', '.', $this->data['EventDetail']['weight_in_kg']);
			$weight_in_lbs = str_replace(',', '.', $this->data['EventDetail']['weight_in_lbs']);
			
			if(($weight_in_kg != '') || ($weight_in_lbs != '')) {
				if((is_numeric($weight_in_kg) && $weight_in_kg == 0) || (is_numeric($weight_in_lbs) && $weight_in_lbs == 0)) {
					$this->validationErrors[] = "weight or height can not be equal to 0";
				} else {
					if(empty($weight_in_kg) && !empty($weight_in_lbs) && is_numeric($weight_in_lbs)) {
						$weight_in_kg = $weight_in_lbs * 0.45359;
					} else if(empty($weight_in_lbs) && !empty($weight_in_kg) && is_numeric($weight_in_kg)) {
						$weight_in_lbs = $weight_in_kg / 0.45359;
					} else if(!empty($weight_in_kg) && !empty($weight_in_lbs) && is_numeric($weight_in_kg) && is_numeric($weight_in_lbs)) {
						$diff = $weight_in_kg - $weight_in_lbs * 0.45359;
						if(abs($diff) > 0.5) $this->validationErrors['weight_in_kg'] = 'weight and height are not consistent';					
					}
					$weight_in_kg_for_bmi = $weight_in_kg;
					$this->data['EventDetail']['weight_in_kg'] = $weight_in_kg;
					$this->data['EventDetail']['weight_in_lbs'] = $weight_in_lbs;
				}
			}
		}
		
		$height_in_cm_for_bmi = null;
		if(array_key_exists('height_in_cm', $this->data['EventDetail']) && array_key_exists('height_in_feet', $this->data['EventDetail'])) {
			$height_in_cm = str_replace(',', '.', $this->data['EventDetail']['height_in_cm']);
			$height_in_feet = str_replace(',', '.', $this->data['EventDetail']['height_in_feet']);
			
			if(($height_in_cm != '') || ($height_in_feet != '')) {
				if((is_numeric($height_in_cm) && $height_in_cm == 0) || (is_numeric($height_in_feet) && $height_in_feet == 0)) {
					$this->validationErrors[] = "weight or height can not be equal to 0";
				} else {
					if(empty($height_in_cm) && !empty($height_in_feet) && is_numeric($height_in_feet)) {
						$height_in_cm = $height_in_feet * 30.47;
					} else if(empty($height_in_feet) && !empty($height_in_cm) && is_numeric($height_in_cm)) {
						$height_in_feet = $height_in_cm / 30.47;
					} else if(!empty($height_in_cm) && !empty($height_in_feet) && is_numeric($height_in_cm) && is_numeric($height_in_feet)) {
						$diff = $height_in_cm - $height_in_feet * 30.47;
						if(abs($diff) > 1) $this->validationErrors['height_in_cm'] = 'weights or heights are not consistent';					
					}
					$height_in_cm_for_bmi = $height_in_cm;
					$this->data['EventDetail']['height_in_cm'] = $height_in_cm;
					$this->data['EventDetail']['height_in_feet'] = $height_in_feet;
				}
			}
		}
		
		if(!is_null($weight_in_kg_for_bmi) && !is_null($height_in_cm_for_bmi)) {
			$this->data['EventDetail']['bmi'] = ($weight_in_kg_for_bmi/($height_in_cm_for_bmi*$height_in_cm_for_bmi)) * 10000;	
		}
	}
		
}