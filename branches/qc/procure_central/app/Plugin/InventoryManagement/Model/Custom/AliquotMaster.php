<?php

class AliquotMasterCustom extends AliquotMaster {	
	var $useTable = 'aliquot_masters';
	var $name = 'AliquotMaster';
	
	function validates($options = array()){
		$val_res = parent::validates($options);
		
		if(array_key_exists('AliquotDetail', $this->data)) {
			if(array_key_exists('block_type', $this->data['AliquotDetail']) 
			&& !in_array(($this->data['AliquotDetail']['block_type'].$this->data['AliquotDetail']['procure_freezing_type']), array('frozen','frozenISO','frozenISO+OCT','frozenOCT','paraffin'))) {
				$this->validationErrors['procure_freezing_type'][] = 'only frozen blocks can be associated to a freezing type';
				$val_res = false;
			}
			if(array_key_exists('procure_card_completed_datetime', $this->data['AliquotDetail']) && strlen($this->data['AliquotMaster']['storage_datetime'])) {
				$this->validationErrors['storage_datetime'][] = 'no storage datetime has to be completed for whatman paper';
				$val_res = false;
			}
			//Manage Bioanalyzer Concentration and quantity
			if(array_key_exists('concentration', $this->data['AliquotDetail']) && strlen($this->data['AliquotDetail']['concentration']) && !strlen($this->data['AliquotDetail']['concentration_unit'])) {
				$this->validationErrors['concentration_unit'][] = 'concentration unit has to be completed';
				$val_res = false;
			}
			//Manage Nanodrop Concentration and quantity
			if(array_key_exists('procure_concentration_nanodrop', $this->data['AliquotDetail']) && strlen($this->data['AliquotDetail']['procure_concentration_nanodrop']) && !strlen($this->data['AliquotDetail']['procure_concentration_unit_nanodrop'])) {
				$this->validationErrors['procure_concentration_unit_nanodrop'][] = 'concentration unit has to be completed';
				$val_res = false;
			}
			if(array_key_exists('procure_freezing_type', $this->data['AliquotDetail']) && $this->data['AliquotDetail']['procure_freezing_type'] == 'OCT'){
				AppController::addWarningMsg(__('block freezing type OCT has not to be used anymore'));
			}
			if(array_key_exists('procure_date_at_minus_80', $this->data['AliquotDetail'])) {
			    $procure_time_at_minus_80_days = '';
			    if($this->data['AliquotDetail']['procure_date_at_minus_80'] && $this->data['AliquotMaster']['storage_datetime']) {
			        if($this->data['AliquotDetail']['procure_date_at_minus_80_accuracy'] == 'c' && in_array($this->data['AliquotMaster']['storage_datetime_accuracy'], array('c','h','i',''))) {
                        $datetime1 = new DateTime($this->data['AliquotDetail']['procure_date_at_minus_80']);
			            $datetime2 = new DateTime(substr($this->data['AliquotMaster']['storage_datetime'], 0, 10));
			            $interval = $datetime1->diff($datetime2);
			            if($interval->invert) {
			                $this->validationErrors['procure_date_at_minus_80'][] = 'error in the date definitions';
                            $val_res = false;
			            } else {
			                $procure_time_at_minus_80_days = $interval->days;
			            }
			        } else {
			            AppController::addWarningMsg(__('storage dates precisions do not allow system to calculate the days at -80'));
			        }
			    }
			    $this->data['AliquotDetail']['procure_time_at_minus_80_days'] = $procure_time_at_minus_80_days;
			    $this->addWritableField(array('procure_time_at_minus_80_days'));
			}
		}
		
		return $val_res;
	}
	
	function validateBarcode($barcode, $procure_created_by_bank, $procure_participant_identifier = null, $procure_visit = null) {
		$error = false;
		if($procure_created_by_bank != 'p') {
			if(!$procure_participant_identifier || !$procure_visit || !preg_match('/^'.$procure_participant_identifier.' '.$procure_visit.' \-[A-Z]{3}/', $barcode)) {
				$error = 'aliquot barcode format errror - should begin with the participant identifier and the visit PS0P0000 V00 -AAA';
			}
		}
		return $error;
	}
	
	function calculateRnaQuantity($aliquot_data) {
		//Get initial volume
		$current_volume = null;
		if(array_key_exists('AliquotMaster', $aliquot_data) && array_key_exists('current_volume', $aliquot_data['AliquotMaster']) && array_key_exists('AliquotControl', $aliquot_data) && array_key_exists('volume_unit', $aliquot_data['AliquotControl'])) {
			if($aliquot_data['AliquotControl']['volume_unit'] == 'ul') {
				if(strlen($aliquot_data['AliquotMaster']['current_volume'])) $current_volume = $aliquot_data['AliquotMaster']['current_volume'];
			} else {
				AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
			}
		}
		//Calculate quantity
		$procure_total_quantity_ug = '';
		$procure_total_quantity_ug_nanodrop = '';
		if(!is_null($current_volume)) {
			//Bioanalyzer
			if(array_key_exists('AliquotDetail', $aliquot_data) && array_key_exists('concentration', $aliquot_data['AliquotDetail']) && strlen($aliquot_data['AliquotDetail']['concentration']) && array_key_exists('concentration_unit', $aliquot_data['AliquotDetail'])) {
				$concentration = $aliquot_data['AliquotDetail']['concentration'];
				switch($aliquot_data['AliquotDetail']['concentration_unit']) {
					case 'pg/ul':
						$concentration = $concentration/1000;
					case 'ng/ul':
						$concentration = $concentration/1000;
					case 'ug/ul':
						$procure_total_quantity_ug = $current_volume * $concentration;
						break;
					default:
						AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
				}
			}
			//Nanodrop
			if(array_key_exists('AliquotDetail', $aliquot_data) && array_key_exists('procure_concentration_nanodrop', $aliquot_data['AliquotDetail']) && strlen($aliquot_data['AliquotDetail']['procure_concentration_nanodrop']) && array_key_exists('procure_concentration_unit_nanodrop', $aliquot_data['AliquotDetail'])) {
				$concentration = $aliquot_data['AliquotDetail']['procure_concentration_nanodrop'];
				switch($aliquot_data['AliquotDetail']['procure_concentration_unit_nanodrop']) {
					case 'pg/ul':
						$concentration = $concentration/1000;
					case 'ng/ul':
						$concentration = $concentration/1000;
					case 'ug/ul':
						$procure_total_quantity_ug_nanodrop = $current_volume * $concentration;
						break;
					default:
						AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
				}
			}
		}
		return array($procure_total_quantity_ug, $procure_total_quantity_ug_nanodrop);
	}	
	
	function updateAliquotVolume($aliquot_master_id, $remove_from_stock_if_empty_volume = false){
		if(empty($aliquot_master_id)){
			AppController::getInstance()->redirect('/Pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, null, true);
		}
	
		// Get aliquot data
		$aliquot_data = $this->getOrRedirect($aliquot_master_id);
	
		// Set variables
		$aliquot_data_to_save = array();
		$aliquot_uses = null;
			
		// MANAGE CURRENT VOLUME
	
		$initial_volume = $aliquot_data['AliquotMaster']['initial_volume'];
	
		// Manage new current volume
		if(empty($initial_volume)){
			// Initial_volume is null or equal to 0
			// To be sure value and type of both variables are identical
			$current_volume = $initial_volume;
				
		}else {
			// A value has been set for the intial volume
			if((!is_numeric($initial_volume)) || ($initial_volume < 0)){
				AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
			}
				
			$total_used_volume = 0;
			$view_aliquot_use = AppModel::getInstance("InventoryManagement", "ViewAliquotUse", true);
			$aliquot_uses = $this->tryCatchQuery(str_replace('%%WHERE%%', "AND AliquotMaster.id= $aliquot_master_id", $view_aliquot_use::$table_query));
			foreach($aliquot_uses as $aliquot_use){
				$used_volume = $aliquot_use['0']['used_volume'];
				if(!empty($used_volume)){
					// Take used volume in consideration only when this one is not empty
					if((!is_numeric($used_volume)) || ($used_volume < 0)){
						AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
					}
					$total_used_volume += $used_volume;
				}
			}
				
			$current_volume = round(($initial_volume - $total_used_volume), 5);
			if($current_volume < 0){
				$current_volume = 0;
				$tmp_msg = __("the aliquot with barcode [%s] has reached a volume below 0");
				AppController::addWarningMsg(sprintf($tmp_msg, $aliquot_data['AliquotMaster']['barcode']));
			}
		}
	
		$aliquot_data_to_save["current_volume"] = $current_volume;
		if($current_volume <= 0 && $remove_from_stock_if_empty_volume){
			$aliquot_data_to_save['storage_master_id'] = NULL;
			$aliquot_data_to_save['storage_coord_x'] = NULL;
			$aliquot_data_to_save['storage_coord_y'] = NULL;
			$aliquot_data_to_save['in_stock'] = 'no';
			$aliquot_data_to_save['in_stock_detail'] = 'empty';
		}
	
		// SAVE DATA
	
		$aliquot_data_to_save['id'] = $aliquot_master_id;
	
		//---------------------------------------------------------
		// Set data to empty array to guaranty
		// no merge will be done with previous AliquotMaster data
		// when AliquotMaster set() function will be called again.
		//---------------------------------------------------------
		$this->data = array();	//
		$this->id = $aliquot_master_id;
		$this->read();
		$save_required = false;
		foreach($aliquot_data_to_save as $key_to_save => $value_to_save){
			if($key_to_save == "current_volume") $this->data['AliquotMaster'][$key_to_save] = str_replace('0.00000', '0', $this->data['AliquotMaster'][$key_to_save]);
			if(strcmp($this->data['AliquotMaster'][$key_to_save], $value_to_save)){
				$save_required = true;
			}
		}
	
		$prev_check_writable_fields = $this->check_writable_fields;
		$this->check_writable_fields = false;
//PROCURE
		$aliquot_detail_data_to_save = array();
		if($save_required && $aliquot_data['SampleControl']['sample_type'] == 'rna' && $aliquot_data['AliquotControl']['aliquot_type'] == 'tube' && array_key_exists('current_volume', $aliquot_data_to_save)) {
			$tmp_aliquot_data = $aliquot_data;
			$tmp_aliquot_data['AliquotMaster']['current_volume'] = $aliquot_data_to_save["current_volume"];
			list($aliquot_detail_data_to_save['procure_total_quantity_ug'], $aliquot_detail_data_to_save['procure_total_quantity_ug_nanodrop']) = $this->calculateRnaQuantity($tmp_aliquot_data);
		}
		$result = $save_required && !$this->save(array("AliquotMaster" => $aliquot_data_to_save, "AliquotDetail" => $aliquot_detail_data_to_save), false);
//		$result = $save_required && !$this->save(array("AliquotMaster" => $aliquot_data_to_save), false);
//END PROCURE
		$this->check_writable_fields = $prev_check_writable_fields;
		return !$result;
	}
	
}