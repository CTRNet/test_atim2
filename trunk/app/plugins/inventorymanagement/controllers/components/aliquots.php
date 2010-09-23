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
		if(empty($aliquot_master_id)) { $this->controller->redirect('/pages/err_inv_funct_param_missing', null, true); }
		
		$aliquot_data = $this->controller->AliquotMaster->find('first', array('conditions' => array('AliquotMaster.id' => $aliquot_master_id)));
		
		if(empty($aliquot_data)) { $this->controller->redirect('/pages/err_inv_no_data', null, true); }
				
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
			if((!is_numeric($initial_volume)) || ($initial_volume < 0))  { $this->controller->redirect('/pages/err_inv_system_error', null, true); }
					
			$total_used_volume = 0;
			foreach($aliquot_data['AliquotUse'] as $id => $aliquot_use){
				$used_volume = $aliquot_use['used_volume'];
				if(!empty($used_volume)){
					// Take used volume in consideration only when this one is not empty
					if((!is_numeric($used_volume)) || ($used_volume < 0))  { $this->controller->redirect('/pages/err_inv_system_error', null, true); }
					$total_used_volume += $used_volume;
				}

			}
			$new_current_volume = round(($initial_volume - $total_used_volume), 5);
			if($new_current_volume < 0){
				$new_current_volume = 0;
				if(!isset($_SESSION['ctrapp_core']['warning_msg'])){
					$_SESSION['ctrapp_core']['warning_msg'] = array();
				}
				$tmp_msg = __("the aliquot with barcode [%s] has a reached a volume bellow 0", true);
				$_SESSION['ctrapp_core']['warning_msg'][] = sprintf($tmp_msg, $aliquot_data['AliquotMaster']['barcode']);
			}

			if($new_current_volume === $current_volume) {
				//Nothing to do
				return true;
			}
			$current_volume = $new_current_volume;
		}
		
		// Save Data
		$this->controller->AliquotMaster->id = $aliquot_master_id;
		if(!$this->controller->AliquotMaster->save(array('AliquotMaster' => array('id' => $aliquot_master_id, 'current_volume' => $current_volume)))) {
			return false;
		}
		return true;
	}
	
	/**
	 * Will update use_datetime and used_by fields for a list of aliquot uses.
	 *
	 * @param $aliquot_use_ids List of aliquot use ids to update.
	 * @param $use_datetime New use_datetime value
	 * @param $used_by New used_by value 
	 * 
	 * @return FALSE when error has been detected
	 * 
	 * @author N. Luc
	 * @date 2007-08-15
	 */
	 
	function updateAliquotUses($aliquot_use_ids, $use_datetime, $used_by) {
		if(((!is_array($aliquot_use_ids)) && !$aliquot_use_ids) || (!$use_datetime) || (!$used_by)) { $this->controller->redirect('/pages/err_inv_funct_param_missing', null, true); }		
		foreach($aliquot_use_ids as $aliquot_use_id) {
			$this->controller->AliquotUse->id = $aliquot_use_id;
			if(!$this->controller->AliquotUse->save(array('AliquotUse' => array('used_by' => $used_by, 'use_datetime' => $use_datetime)))) { return false; }
		}
		return true;
	}
	
	function removeAliquotStorageData($aliquot_master_data) {
		$aliquot_master_data['storage_master_id'] = null;
		$aliquot_master_data['storage_coord_x'] = null;
		$aliquot_master_data['coord_x_order'] = null;
		$aliquot_master_data['storage_coord_y'] = null;
		$aliquot_master_data['coord_y_order'] = null;	
		
		return $aliquot_master_data;
	}
}

?>