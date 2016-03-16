<?php
class AliquotMasterCustom extends AliquotMaster {

	var $useTable = 'aliquot_masters';	
	var $name = 'AliquotMaster';
	
	function regenerateAliquotBarcode() {
		$query = "UPDATE aliquot_masters SET barcode = id WHERE barcode LIKE '' OR barcode IS NULL";
		$this->tryCatchQuery($query);
		$this->tryCatchQuery(str_replace('aliquot_masters', 'aliquot_masters_revs', $query));
		//The Barcode values of AliquotView will be updated by AppModel::releaseBatchViewsUpdateLock(); call in AliquotMaster.add() and AliquotMaster.realiquot() function
	}
	
	function beforeSave($options = array()){
		$ret_val = parent::beforeSave($options);
		
		if(array_key_exists('AliquotDetail', $this->data) && array_key_exists('qc_tf_core_nature_site', $this->data['AliquotDetail'])) {
			// Set core aliquot label
			$this->data['AliquotMaster']['aliquot_label'] = substr(strtoupper(strlen($this->data['AliquotDetail']['qc_tf_core_nature_revised'])? $this->data['AliquotDetail']['qc_tf_core_nature_revised'] : (strlen($this->data['AliquotDetail']['qc_tf_core_nature_site'])? $this->data['AliquotDetail']['qc_tf_core_nature_site'] : 'U')), 0, 1);
			$this->addWritableField(array('aliquot_label'));
		}
		
		return $ret_val;
	}
	
	function generateDefaultAliquotLabel($view_data) {
		// Parameters check: Verify parameters have been set
		if(empty($view_data)) AppController::getInstance()->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
			
		$default_aliquot_label = '';
		if($view_data['sample_type'] == 'dna'){
			if($view_data['participant_identifier']) {
				$default_aliquot_label = $view_data['participant_identifier'].'-';
			}
			$default_aliquot_label .= 'DNA-';
		} else if($view_data['sample_type'] == 'rna'){
			if($view_data['participant_identifier']) {
				$default_aliquot_label = $view_data['participant_identifier'].'-';
			}
			$default_aliquot_label .= 'RNA-';
		}
	
		return $default_aliquot_label;
	}

	function afterFind($results, $primary = false){
		$results = parent::afterFind($results);
		
		if(isset($results[0]['AliquotMaster'])) {
			//Get user and bank information
				// NOTE: Will Use data returned by ViewAliquot.afterFind() function
			//Process data
			$ViewAliquotModel = null;
			foreach($results as &$result) {
				//Manage confidential information and create the aliquot information label to display
					// NOTE: Will Use data returned by ViewAliquot.afterFind() function
				if(array_key_exists('aliquot_label', $result['AliquotMaster'])) {
					$aliquot_view_data = null;
					if(!isset($result['ViewAliquot'])) {
						if(!$ViewAliquotModel) $ViewAliquotModel = AppModel::getInstance("InventoryManagement", "ViewAliquot", true);
						$aliquot_view_data = $ViewAliquotModel->find('first', array('conditions' => array('ViewAliquot.aliquot_master_id' => $result['AliquotMaster']['id']), 'recursive' => '-1'));
					} else {
						$aliquot_view_data = array('ViewAliquot' => $result['ViewAliquot']);
					}
					if(isset($result['AliquotMaster']['aliquot_label'])) $result['AliquotMaster']['aliquot_label'] = $aliquot_view_data['ViewAliquot']['aliquot_label'];
					if(isset($aliquot_view_data['ViewAliquot']['qc_tf_generated_label_for_display'])) $result['AliquotMaster']['qc_tf_generated_label_for_display'] = $aliquot_view_data['ViewAliquot']['qc_tf_generated_label_for_display'];
				}
			}
		} else if(isset($results['AliquotMaster'])){
			pr('TODO afterFind ViewAliquot');
			pr($results);
			exit;
		}
		return $results;
	}
}

?>
