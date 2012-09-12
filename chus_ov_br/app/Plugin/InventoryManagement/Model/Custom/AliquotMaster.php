<?php

class AliquotMasterCustom extends AliquotMaster {

	var $useTable = 'aliquot_masters';	
	var $name = 'AliquotMaster';
	
	function generateDefaultAliquotLabel($view_sample, $aliquot_control_data) {
		// Parameters check: Verify parameters have been set
		if(empty($view_sample) || empty($aliquot_control_data)) AppController::getInstance()->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);

		$default_sample_label = '';
			
		preg_match('/^(OV|BR)([A-Za-z]*)([0-9]+)$/', $view_sample['ViewSample']['frsq_number'], $matches);	
		$bank_initials = isset($matches[1])? $matches[1] : '?';
		$bank_number = isset($matches[3])? $matches[3] : '?';
		
		switch($view_sample['ViewSample']['sample_type']) {
			case 'tissue':
				$SampleMasterModel = AppModel::getInstance("ClinicalAnnotation", "SampleMaster", true);
				$tmp_sample_data = $SampleMasterModel->find('first',array('conditions' => array('SampleMaster.id' => $view_sample['ViewSample']['sample_master_id']), 'recursive' => '0'));
				$type_char = '';
				$suffix = '';					
				if($tmp_sample_data['SampleDetail']['tissue_source'] == 'breast') {
					if(in_array($tmp_sample_data['SampleDetail']['tissue_nature'], array('borderline','tumoral','metastatic'))) {
						$type_char = 'C';
					} else if($tmp_sample_data['SampleDetail']['tissue_nature'] == 'benign') {
						$type_char = 'B';
					} else if($tmp_sample_data['SampleDetail']['tissue_nature'] == 'normal') {
						$type_char = 'N';
					}
				} else if($tmp_sample_data['SampleDetail']['tissue_source'] == 'ovary') {
					$suffix = 'O';
					switch($tmp_sample_data['SampleDetail']['tissue_laterality']) {
						case 'right':
							$suffix .= 'D';
							break;
						case 'left':
							$suffix .= 'G';
							break;
						default:	
					}
				}
				$default_sample_label = $bank_initials.$type_char.$bank_number.' FT'.$suffix;
				break;
	              
			case 'ascite supernatant':
				$default_sample_label = $bank_initials.$bank_number.' FA';
				break;

			case 'plasma':
				$default_sample_label = $bank_initials.$bank_number.' S';
				break;

			case 'dna':
				$default_sample_label = $bank_initials.$bank_number.' D';
				break;
								
			default:
				$default_sample_label = $bank_initials.$bank_number;
		}

		return $default_sample_label;
	}
	
	function regenerateAliquotBarcode() {
		$aliquots_to_update = $this->find('all', array('conditions' => array("AliquotMaster.barcode IS NULL OR AliquotMaster.barcode LIKE ''"), 'fields' => array('AliquotMaster.id')));
		foreach($aliquots_to_update as $new_aliquot) {
			$new_aliquot_id = $new_aliquot['AliquotMaster']['id'];
			$aliquot_data = array('AliquotMaster' => array('barcode' => $new_aliquot_id), 'AliquotDetail' => array());
				
			$this->id = $new_aliquot_id;
			$this->data = null;
			$this->addWritableField(array('barcode'));
			$this->save($aliquot_data, false);
		}
	}

	function updateAliquotUseAndVolume($aliquot_master_id, $update_current_volume = true, $update_uses_counter = true, $remove_from_stock_if_empty_volume = false){
		if(empty($aliquot_master_id)){
			AppController::getInstance()->redirect('/Pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, null, true);
		}
	
		// Get aliquot data
		$aliquot_data = $this->getOrRedirect($aliquot_master_id);
	
		// Set variables
		$aliquot_data_to_save = array();
		$aliquot_uses = null;
//------------------------------------------------------------------------------------
//  SECTION ADDED TO CALCULATE WEIGHT
//------------------------------------------------------------------------------------
		$chum_current_weight_ug = null;
//- END SECTION ADDED ----------------------------------------------------------------
			
		if($update_current_volume) {
				
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
				$aliquot_uses = $view_aliquot_use->findFastFromAliquotMasterId($aliquot_master_id);
				foreach($aliquot_uses as $id => $aliquot_use){
					$used_volume = $aliquot_use['ViewAliquotUse']['used_volume'];
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

//------------------------------------------------------------------------------------
//  SECTION ADDED TO CALCULATE WEIGHT
//------------------------------------------------------------------------------------
			if(strpos($aliquot_data['AliquotControl']['detail_form_alias'], 'chus_dna_rna_weight') !== false) {
				if($aliquot_data['AliquotControl']['volume_unit'] != 'ul') AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
				$AliquotDetail = AppModel::getInstance("InventoryManagement", "AliquotDetail", true);
				$AliquotDetail->addWritableField(array('chum_current_weight_ug'));
				
				$current_volume_ul = $aliquot_data_to_save["current_volume"];
				$concentration_ug_ml = $aliquot_data['AliquotDetail']['concentration'];
				$concentration_unit_ug_ml= $aliquot_data['AliquotDetail']['concentration_unit'];
				if(strlen($current_volume_ul.$concentration_ug_ml)) {
					if(strlen($current_volume_ul) && strlen($concentration_ug_ml) && strlen($concentration_unit_ug_ml)) {
						if($concentration_unit_ug_ml != 'ug/ml') $this->redirect('/Pages/err_plugin_record_err?method='.__METHOD__.',line='.__LINE__, null, true);
						$chum_current_weight_ug = ($current_volume_ul/1000)*$concentration_ug_ml;
					} else {
						AppController::addWarningMsg(__('at least one information (volume, concentration, unit) is missing to calculate the current weight'));
					}
				}
			}
//- END SECTION ADDED ----------------------------------------------------------------		
		}
	
		if($update_uses_counter) {
				
			// UPDATE ALIQUOT USE COUNTER
	
			if(is_null($aliquot_uses)) {
				$view_aliquot_use = AppModel::getInstance("InventoryManagement", "ViewAliquotUse", true);
				$aliquot_uses = $view_aliquot_use->findFastFromAliquotMasterId($aliquot_master_id);
			}
				
			$aliquot_data_to_save['use_counter'] = sizeof($aliquot_uses);
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
			if($this->data['AliquotMaster'][$key_to_save] != $value_to_save){
				$save_required = true;
			}
		}
//------------------------------------------------------------------------------------
//  SECTION ADDED TO CALCULATE WEIGHT
//------------------------------------------------------------------------------------
		if(!is_null($chum_current_weight_ug) && $this->data['AliquotDetail']['chum_current_weight_ug'] != $chum_current_weight_ug) {
			$save_required = true;
		}
//- END SECTION ADDED ----------------------------------------------------------------	
	
		$prev_check_writable_fields = $this->check_writable_fields;
		$this->check_writable_fields = false;
		
//------------------------------------------------------------------------------------
//  SECTION ADDED TO CALCULATE WEIGHT
//------------------------------------------------------------------------------------
		$tmp_data = array("AliquotMaster" => $aliquot_data_to_save);
		if(!is_null($chum_current_weight_ug)) $tmp_data['AliquotDetail']['chum_current_weight_ug'] = $chum_current_weight_ug;
		$result = $save_required && !$this->save($tmp_data, false);
//- END SECTION ADDED ----------------------------------------------------------------		
		
		$this->check_writable_fields = $prev_check_writable_fields;
		return !$result;
	}
}

?>
