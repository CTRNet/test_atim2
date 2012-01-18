<?php
class AliquotMasterCustom extends AliquotMaster{
	var $useTable = 'aliquot_masters';
	var $name = 'AliquotMaster';
	
	function generateDefaultAliquotLabel($sample_master_id, $aliquot_control_data) {
		// Parameters check: Verify parameters have been set
		if(empty($sample_master_id) || empty($aliquot_control_data)) AppController::getInstance()->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		
		// Get Sample Data
		$sample_master_model = AppModel::getInstance('inventorymanagement', 'SampleMaster', true);
		$sample_master_model->unbindModel(array('hasMany' => array('AliquotMaster'), 'belongsTo' => array('Collection')));
		$sample_data = $sample_master_model->redirectIfNonExistent($sample_master_id, __METHOD__, __LINE__, true);
		if(empty($sample_data)) {
			AppController::getInstance()->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
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
					AppController::getInstance()->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
			}
	
		} else if($sample_data['SampleControl']['sample_category'] == 'derivative'){
			$initial_specimen_label = $this->createSpecimenSampleLabel($sample_data['SampleMaster']['collection_id'], $sample_data['SampleMaster']['initial_specimen_sample_id']);
			$sample_type_code = '';//$sample_data['SampleControl']['sample_type_code'];//TODO, sample_type_code has been removed from 2.4.0
	
			switch ($sample_data['SampleControl']['sample_type']) {
				case 'pbmc':
					$sample_type_code = 'PBMC';
					break;
				case 'plasma':
					$sample_type_code = 'PLS';
					break;
				case 'serum':
					$sample_type_code = 'SER';
					break;
				case 'tissue suspension':
					$sample_type_code = 'T-SUSP';
					break;
				default :
					// Type is unknown
					AppController::getInstance()->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
			}
			$sample_label = $sample_type_code. ' ' . $initial_specimen_label;
			$aliquot_creation_date = $sample_data['DerivativeDetail']['creation_datetime'];
				
		} else {
			AppController::getInstance()->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		}
	
		return $sample_label . (empty($aliquot_creation_date)? '' : ' ' . substr($aliquot_creation_date, 0, strpos($aliquot_creation_date," ")));
	}
	
	function createSpecimenSampleLabel($collection_id, $specimen_sample_master_id, $specimen_data = null) {
		$new_sample_label = null;
	
		// Parameters check: Verify parameters have been set
		if(empty($collection_id) || empty($specimen_sample_master_id)) {
			AppController::getInstance()->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		}
	
		if(is_null($specimen_data)) {
			// Get Specimen Data
			$sample_master_model = AppModel::getInstance('inventorymanagement', 'SampleMaster', true);
			$sample_master_model->unbindModel(array('hasMany' => array('AliquotMaster'), 'belongsTo' => array('Collection')));
			$specimen_data = $sample_master_model->find('first', array('conditions' => array('SampleMaster.collection_id' => $collection_id, 'SampleMaster.id' => $specimen_sample_master_id)));
			if(empty($specimen_data)) {
				AppController::getInstance()->redirect('/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true);
			}
		}
	
		if(!isset($specimen_data['SpecimenDetail'])) {
			AppController::getInstance()->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		}
	
		// Build label
		if(!array_key_exists('qc_hb_sample_code', $specimen_data['SpecimenDetail'])) {
			AppController::getInstance()->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		}
		$specimen_type_code =  (empty($specimen_data['SpecimenDetail']['qc_hb_sample_code']))? 'n/a' : $specimen_data['SpecimenDetail']['qc_hb_sample_code'];
	
		$ViewCollection = AppModel::getInstance('Inventorymanagement', 'ViewCollection', true);
		$view_collection = $ViewCollection->find('first', array('conditions' => array('ViewCollection.collection_id' => $collection_id)));
		if(empty($view_collection)) {
			AppController::getInstance()->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		}
		$bank_participant_identifier = empty($view_collection['ViewCollection']['participant_identifier'])? 'n/a' : $view_collection['ViewCollection']['participant_identifier'];
			
		$new_sample_label = $specimen_type_code . ' - ' . $bank_participant_identifier;
		switch ($specimen_data['SampleControl']['sample_type']) {
			// Specimen
			case 'blood':
				if(!array_key_exists('blood_type', $specimen_data['SampleDetail'])) {
					AppController::getInstance()->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
				}
				$new_sample_label .= (empty($specimen_data['SampleDetail']['blood_type'])? ' n/a': ' ' . $specimen_data['SampleDetail']['blood_type']);
				break;
				 
			case 'tissue':
				break;
	
			default :
				// Type is unknown
				AppController::getInstance()->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		}
	
		return $new_sample_label;
	}
}
