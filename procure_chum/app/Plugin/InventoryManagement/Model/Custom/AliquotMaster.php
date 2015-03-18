<?php

class AliquotMasterCustom extends AliquotMaster {	
	var $useTable = 'aliquot_masters';
	var $name = 'AliquotMaster';
	
	function validates($options = array()){
		$val_res = parent::validates($options);
		
		if(array_key_exists('block_type', $this->data['AliquotDetail']) 
		&& !in_array(($this->data['AliquotDetail']['block_type'].$this->data['AliquotDetail']['procure_freezing_type']), array('frozen','frozenISO','frozenISO+OCT','paraffin'))) {
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
			
		return $val_res;
	}
	
	function calculateRnaQuantity($aliquot_data) {
		//Get initial volume
		$inital_volume = null;
		if(array_key_exists('AliquotMaster', $aliquot_data) && array_key_exists('initial_volume', $aliquot_data['AliquotMaster']) && array_key_exists('AliquotControl', $aliquot_data) && array_key_exists('volume_unit', $aliquot_data['AliquotControl'])) {
			if($aliquot_data['AliquotControl']['volume_unit'] == 'ul') {
				if(strlen($aliquot_data['AliquotMaster']['initial_volume'])) $inital_volume = $aliquot_data['AliquotMaster']['initial_volume'];
			} else {
				AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
			}
		}
		//Calculate quantity
		$procure_total_quantity_ug = '';
		$procure_total_quantity_ug_nanodrop = '';
		if(!is_null($inital_volume)) {
			//Bioanalyzer
			if(array_key_exists('AliquotDetail', $aliquot_data) && array_key_exists('concentration', $aliquot_data['AliquotDetail']) && strlen($aliquot_data['AliquotDetail']['concentration']) && array_key_exists('concentration_unit', $aliquot_data['AliquotDetail'])) {
				$concentration = $aliquot_data['AliquotDetail']['concentration'];
				switch($aliquot_data['AliquotDetail']['concentration_unit']) {
					case 'pg/ul':
						$concentration = $concentration/1000;
					case 'ng/ul':
						$concentration = $concentration/1000;
					case 'ug/ul':
						$procure_total_quantity_ug = $inital_volume * $concentration;
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
						$procure_total_quantity_ug_nanodrop = $inital_volume * $concentration;
						break;
					default:
						AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
				}
			}
		}
		return array($procure_total_quantity_ug, $procure_total_quantity_ug_nanodrop);
	}	
}