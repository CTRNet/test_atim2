<?php

class AliquotsComponent extends Object {
	
	function initialize(&$controller, $settings=array()) {
		$this->controller =& $controller;
	}
	
	/**
	 * Update the current volume of an aliquot.
	 * 
	 * Note:
	 *  - When the intial volume is null, the current volume will be set to null.
	 *  - Status and status reason won't be updated.
	 *
	 * @param $aliquot_master_id Master Id of the aliquot.
	 * 
	 * @return FALSE when error has been detected
	 * 
	 * @author N. Luc
	 * @date 2007-08-15
	 */
	 
	function updateAliquotCurrentVolume($aliquot_master_id){
		if(empty($aliquot_master_id)) { $this->redirect('/pages/err_inv_aliquot_no_id', null, true); }
		
//TODO: There was a bug attached to this function
//The system is unable to update correclty the current volume when this function has been called 
//by a function that added a record into the use table (the last aliquot use won't be take in consideration).
		
		$aliquot_data = $this->controller->AliquotMaster->find('first', array('conditions' => array('AliquotMaster.id' => $aliquot_master_id)));
		if(empty($aliquot_data)) { $this->redirect('/pages/err_inv_aliquot_no_data', null, true); }
				
		$initial_volume = $aliquot_data['AliquotMaster']['initial_volume'];
		$current_volume = $aliquot_data['AliquotMaster']['current_volume'];
		
		// Manage new current volume
		if(empty($initial_volume)){	
			// Initial_volume is null or equal to 0
			if($initial_volume === $current_volume) {
				//Nothing to do
				return true;
			}
			
			// To be sure value and type of both variables are identical
			$current_volume = $initial_volume;
					
		}else {
			// A value has been set for the intial volume		
			if((!is_numeric($initial_volume)) || ($initial_volume < 0))  { $this->redirect('/pages/err_inv_system_error', null, true); }
					
			$new_current_volume = $initial_volume;
			
			foreach($aliquot_data['AliquotUse'] as $id => $aliquot_use){
				$used_volume = $aliquot_use['used_volume'];
				if(!empty($used_volume)){
					// Take used volume in consideration only when this one is not empty
					if((!is_numeric($used_volume)) || ($used_volume < 0))  { $this->redirect('/pages/err_inv_system_error', null, true); }
					$new_current_volume= bcsub($new_current_volume, $used_volume, 5);
				}
			}
			$new_current_volume = ($new_current_volume <= 0)? 0: $new_current_volume;

			if($new_current_volume === $current_volume) {
				//Nothing to do
				return true;
			}
			$current_volume = $new_current_volume;
		}
	
		// Save Data
		$this->controller->AliquotMaster->id = $aliquot_master_id;
		if(!$this->controller->AliquotMaster->save(array('AliquotMaster' => array('current_volume' => $current_volume)))) {
			return false;
		}
		
		return true;
	}
	
}

?>