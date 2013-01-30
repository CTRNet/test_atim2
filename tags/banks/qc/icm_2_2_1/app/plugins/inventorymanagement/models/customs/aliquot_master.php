<?php

class AliquotMasterCustom extends AliquotMaster {

	var $useTable = 'aliquot_masters';	
	var $name = 'AliquotMaster';	
	
	function generateDefaultAliquotLabel($view_sample, $aliquot_control_data) {
			
		// Parameters check: Verify parameters have been set
		if(empty($view_sample) || empty($aliquot_control_data)) AppController::getInstance()->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
	
		// Check sample collection is a prostate bank collection
		$is_prostate_bank_collection = false;	
		if(!empty($view_sample['ViewSample']['bank_id'])) {
			$bank_model = AppModel::atimNew('Administrate', 'Bank', true);
			$bank_model->bindModel(array('belongsTo' => array(
				'MiscIdentifierControl' => array(
					'className' => 'Clinicalannotation.MiscIdentifierControl',
					'foreignKey'  => 'misc_identifier_control_id'))));	
			$collection_bank_data = $bank_model->find('first', array('conditions' => array('Bank.id' => $view_sample['ViewSample']['bank_id'])));
			if(empty($collection_bank_data)) AppController::getInstance()->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
			
			if(!empty($collection_bank_data['MiscIdentifierControl']) && ($collection_bank_data['MiscIdentifierControl']['misc_identifier_name'] == 'prostate bank no lab')) {
				$is_prostate_bank_collection = true;
			}
		}
		
		// Set Default Sample Label
		$default_sample_label = '';
				
		if($is_prostate_bank_collection){
			
			// ** Manage label for prostate bank **
			
			$visit_label = (empty($view_sample['ViewSample']['visit_label'])? 'V0' : $view_sample['ViewSample']['visit_label']);
			$default_sample_label = 'PS1P_PROCURE_BC '.$visit_label;
			
			switch($view_sample['ViewSample']['sample_type']) {
				case 'serum':
					$default_sample_label .= ' -SER1';
					break;
				case 'plasma':
					$default_sample_label .= ' -PLA1';
					break;
				case 'b cell':
				case 'pbmc':
				case 'blood cell':
					$default_sample_label .= ' -BFC1';
					break;
				case 'centrifuged urine':
					$default_sample_label .= ' -URN1';
					break;
				case 'rna':
					$default_sample_label .= ' -RNA1';
					break;
				case 'blood':
					if($aliquot_control_data['AliquotControl']['aliquot_type'] == 'whatman paper') {
						$default_sample_label .= ' -WHT1';
					} else if(strpos($view_sample['ViewSample']['sample_label'], 'EDTA') !== FALSE) {
						$default_sample_label .= ' -EDB1';
					} else if(strpos($view_sample['ViewSample']['sample_label'], 'ZCSA') !== FALSE) {
						$default_sample_label .= ' -SRB1';
					} else if(strpos($view_sample['ViewSample']['sample_label'], 'gel SST') !== FALSE) {
						$default_sample_label .= ' -SRB1';
					} else if(strpos($view_sample['ViewSample']['sample_label'], 'paxgene') !== FALSE) {
						$default_sample_label .= ' -RNB1';
					}
					break;
				default:
					// Keep label empty to be managed by the rest of the code	
					$default_sample_label = '';
			}
			
			if(!empty($default_sample_label) && !empty($view_sample['ViewSample']['participant_id'])) {
				// Try to add procure barcode to the label
				$misc_identifier = AppModel::atimNew('Clinicalannotation', 'MiscIdentifier', true);
				
				$criteria = array();
				$criteria['MiscIdentifier.participant_id'] = $view_sample['ViewSample']['participant_id'];
				$criteria['MiscIdentifier.identifier_name'] = 'code-barre';
				$barcode_data = $misc_identifier->find('first', array('conditions' => $criteria));		
				
				$default_sample_label = str_replace('_PROCURE_BC', (empty($barcode_data)? '0' : $barcode_data['MiscIdentifier']['identifier_value']), $default_sample_label);
			}
		}
		
		if(empty($default_sample_label)) {
			
			// ** Manage label for either all bank excepted prostate bank or undefined sample label **
			
			// Set date for aliquot label			
			$aliquot_creation_date = '';			
			if($view_sample['ViewSample']['sample_category'] == 'specimen'){
				// Specimen Aliquot
				if(!isset($this->SpecimenDetail)) $this->SpecimenDetail = AppModel::atimNew('Clinicalannotation', 'SpecimenDetail', true);
				
				$specimen_detail = $this->SpecimenDetail->find('first', array('conditions' => array('sample_master_id' => $view_sample['ViewSample']['sample_master_id'])));
				if(empty($specimen_detail)) AppController::getInstance()->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true); 
				
				$aliquot_creation_date = $specimen_detail['SpecimenDetail']['reception_datetime'];

			}else{
				// Derviative Aliquot
				if(!isset($this->DerivativeDetail)) $this->DerivativeDetail = AppModel::atimNew('Clinicalannotation', 'DerivativeDetail', true);
				
				$derivative_detail = $this->DerivativeDetail->find('first', array('conditions' => array('sample_master_id' => $view_sample['ViewSample']['sample_master_id'])));
				if(empty($derivative_detail)) AppController::getInstance()->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true); 
				
				$aliquot_creation_date = $derivative_detail['DerivativeDetail']['creation_datetime'];
			} 
			
			$default_sample_label =
				(empty($view_sample['ViewSample']['sample_label'])? 'n/a' : $view_sample['ViewSample']['sample_label']) .
				(empty($aliquot_creation_date)? '' : ' ' . substr($aliquot_creation_date, 0, strpos($aliquot_creation_date," ")));
		}

		return $default_sample_label;
	}
	
	function regenerateAliquotBarcode() {
		$this->unbindModel(array(
		'hasOne' => array('SpecimenDetail'),
		'belongsTo' => array('Collection','StorageMaster')));
		$aliquots_to_update = $this->find('all', array('conditions' => array('AliquotMaster.barcode' => '')));
		foreach($aliquots_to_update as $new_aliquot) {
			$this->data = array();
			$this->id = $new_aliquot['AliquotMaster']['id'];
			$barcode = 'tmp_'.str_replace(" ", "", $new_aliquot['SampleMaster']['sample_code']).'_'.$new_aliquot['AliquotMaster']['id'];
			if(!$this->save(array('AliquotMaster' => array('barcode' => $barcode)), false)) AppController::getInstance()->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		}	
	}
	
}

?>