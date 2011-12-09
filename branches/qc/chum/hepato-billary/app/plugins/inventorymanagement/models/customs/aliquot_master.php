<?php
class AliquotMasterCustom extends AliquotMaster{
	var $useTable = 'aliquot_masters';
	var $name = 'AliquotMaster';
	
	/**
	* Create default aliquot barcodes that will be unique.
	*
	* @author N. Luc
	* @date 2007-11-29
	*/
	function generateDefaultAliquotBarcode(&$data){
		//TODO: updated to 2.4.0, is it ok?
		if(!empty($data)){
			// Get last aliquot master id
			$tmp_id_search = $this->query("SELECT MAX( id ) FROM `aliquot_masters`");
			$tmp_last_aliq_master_id = empty($tmp_id_search)? '0' : ($tmp_id_search[0][0]['MAX( id )']);
	
			$stop_barcode_creation = false;
			$suffix = '';
			$counter = 0;
			pr($data);
			do{
				unset($this->validationErrors['barcode']);
				$next_aliq_master_id = $tmp_last_aliq_master_id;
				foreach($data as &$parent_children){
					foreach($parent_children['children'] as &$aliquot_data){
						++ $next_aliq_master_id;
						$aliquot_data['AliquotMaster']['barcode'] = 'tmp_'.str_replace(" ", "", $parent_children['parent']['ViewSample']['sample_code']).'_'.$next_aliq_master_id.$suffix;
						$this->checkDuplicatedAliquotBarcode($aliquot_data);
					}
				}
				
				++ $counter;
			}while(array_key_exists('barcode', $this->validationErrors) && $counter < 5);
	
			if(array_key_exists('barcode', $this->validationErrors)){
				// Launch page error
				AppController::getInstance()->redirect('/pages/qc_err_inv_barcode_generation_error', null, true);
			}
			
		}
	}
	
	function generateDefaultAliquotLabel($sample_master_id, $aliquot_control_data) {
		// Parameters check: Verify parameters have been set
		if(empty($sample_master_id) || empty($aliquot_control_data)) {
			AppController::getInstance()->redirect('/pages/err_plugin_system_error', null, true);
		}
		
		
	
		// Get Sample Data
		$sample_master_model = AppModel::getInstance('inventorymanagement', 'SampleMaster', true);
		$sample_master_model->unbindModel(array('hasMany' => array('AliquotMaster'), 'belongsTo' => array('Collection')));
		$sample_data = $sample_master_model->redirectIfNonExistent($sample_master_id, __METHOD__, __LINE__, true);
		if(empty($sample_data)) {
			AppController::getInstance()->redirect('/pages/err_plugin_system_error', null, true);
		}
	
		$sample_label = null;
		$aliquot_creation_date = null;
		if($sample_data['SampleControl']['sample_category'] == 'specimen') {
			$sample_label = $this->createSpecimenSampleLabel($sample_data['SampleMaster']['collection_id'], $sample_master_id, $sample_data);
			$aliquot_creation_date = $sample_data['SpecimenDetail']['reception_datetime'];
	
			switch ($sample_data['SampleControl']['sample_type']) {
				case 'blood':
					break;
				case 'tissue':
					$sample_label .= ' -'.(($aliquot_control_data['AliquotControl']['aliquot_type'] == 'block')? 'OCT': 'SF');
					break;
				default :
					// Type is unknown
					AppController::getInstance()->redirect('/pages/err_plugin_system_error', null, true);
			}
	
		} else if($sample_data['SampleControl']['sample_category'] == 'derivative'){
			$initial_specimen_label = $this->createSpecimenSampleLabel($sample_data['SampleMaster']['collection_id'], $sample_data['SampleMaster']['initial_specimen_sample_id']);
			$sample_type_code = '';//$sample_data['SampleControl']['sample_type_code'];//TODO, sample_type_code has been removed from 2.4.0
	
			switch ($sample_data['SampleControl']['sample_type']) {
				case 'pbmc':
				case 'plasma':
				case 'serum':
				case 'tissue suspension':
					$sample_label = $sample_type_code. ' ' . $initial_specimen_label;
					break;
				default :
					// Type is unknown
					AppController::getInstance()->redirect('/pages/err_plugin_system_error', null, true);
			}
				
			$aliquot_creation_date = $sample_data['DerivativeDetail']['creation_datetime'];
				
		} else {
			AppController::getInstance()->redirect('/pages/err_plugin_system_error', null, true);
		}
	
		return $sample_label . (empty($aliquot_creation_date)? '' : ' ' . substr($aliquot_creation_date, 0, strpos($aliquot_creation_date," ")));
	}
	
	function createSpecimenSampleLabel($collection_id, $specimen_sample_master_id, $specimen_data = null) {
		$new_sample_label = null;
	
		// Parameters check: Verify parameters have been set
		if(empty($collection_id) || empty($specimen_sample_master_id)) {
			AppController::getInstance()->redirect('/pages/err_plugin_system_error', null, true);
		}
	
		if(is_null($specimen_data)) {
			// Get Specimen Data
			$sample_master_model = AppModel::getInstance('inventorymanagement', 'SampleMaster', true);
			$sample_master_model->unbindModel(array('hasMany' => array('AliquotMaster'), 'belongsTo' => array('Collection')));
			$specimen_data = $sample_master_model->find('first', array('conditions' => array('SampleMaster.collection_id' => $collection_id, 'SampleMaster.id' => $specimen_sample_master_id)));
			if(empty($specimen_data)) {
				AppController::getInstance()->redirect('/pages/err_plugin_no_data', null, true);
			}
		}
	
		if(!isset($specimen_data['SpecimenDetail'])) {
			AppController::getInstance()->redirect('/pages/err_plugin_system_error', null, true);
		}
	
		// Build label
		if(!array_key_exists('qc_hb_sample_code', $specimen_data['SpecimenDetail'])) {
			AppController::getInstance()->redirect('/pages/err_plugin_system_error', null, true);
		}
		$specimen_type_code =  (empty($specimen_data['SpecimenDetail']['qc_hb_sample_code']))? 'n/a' : $specimen_data['SpecimenDetail']['qc_hb_sample_code'];
	
		App::import('Model', 'Inventorymanagement.ViewCollection');
		$ViewCollection = new ViewCollection();
		$view_collection = $ViewCollection->find('first', array('conditions' => array('ViewCollection.collection_id' => $collection_id)));
		if(empty($view_collection)) {
			AppController::getInstance()->redirect('/pages/err_plugin_system_error', null, true);
		}
		$bank_participant_identifier = empty($view_collection['ViewCollection']['hepato_bil_bank_participant_id'])? 'n/a' : $view_collection['ViewCollection']['hepato_bil_bank_participant_id'];
	
		$new_sample_label = $specimen_type_code . ' - ' . $bank_participant_identifier;
		switch ($specimen_data['SampleControl']['sample_type']) {
			// Specimen
			case 'blood':
				if(!array_key_exists('blood_type', $specimen_data['SampleDetail'])) {
					AppController::getInstance()->redirect('/pages/err_plugin_system_error', null, true);
				}
				$new_sample_label .= (empty($specimen_data['SampleDetail']['blood_type'])? ' n/a': ' ' . $specimen_data['SampleDetail']['blood_type']);
				break;
				 
			case 'tissue':
				break;
	
			default :
				// Type is unknown
				AppController::getInstance()->redirect('/pages/err_plugin_system_error', null, true);
		}
	
		return $new_sample_label;
	}
}
