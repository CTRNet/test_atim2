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
		
		if(array_key_exists('AliquotDetail', $this->data) && array_key_exists('qbcf_core_nature_site', $this->data['AliquotDetail'])) {
			// Set core aliquot label
			$this->data['AliquotMaster']['aliquot_label'] = substr(strtoupper(strlen($this->data['AliquotDetail']['qbcf_core_nature_revised'])? $this->data['AliquotDetail']['qbcf_core_nature_revised'] : (strlen($this->data['AliquotDetail']['qbcf_core_nature_site'])? $this->data['AliquotDetail']['qbcf_core_nature_site'] : 'U')), 0, 1);
			$this->addWritableField(array('aliquot_label'));
		}
		
		return $ret_val;
	}

	function afterFind($results, $primary = false){
		$results = parent::afterFind($results);
		
		if(isset($results[0]['AliquotMaster'])) {
			$ViewAliquotModel = null;
			foreach($results as &$result) {
				//Manage confidential information and create the aliquot information label to display: Will Use data returned by ViewAliquot.afterFind() function
				if(array_key_exists('aliquot_label', $result['AliquotMaster'])) {
					$aliquot_view_data = null;
					if(!isset($result['ViewAliquot'])) {
						if(!$ViewAliquotModel) $ViewAliquotModel = AppModel::getInstance("InventoryManagement", "ViewAliquot", true);
						$aliquot_view_data = $ViewAliquotModel->find('first', array('conditions' => array('ViewAliquot.aliquot_master_id' => $result['AliquotMaster']['id']), 'recursive' => '-1'));
					} else {
						$aliquot_view_data = array('ViewAliquot' => $result['ViewAliquot']);
					}
					if(isset($result['AliquotMaster']['aliquot_label'])) {
						$result['AliquotMaster']['aliquot_label'] = isset($aliquot_view_data['ViewAliquot']['aliquot_label'])? $aliquot_view_data['ViewAliquot']['aliquot_label'] : CONFIDENTIAL_MARKER;
					}
					if(isset($aliquot_view_data['ViewAliquot']['qbcf_generated_label_for_display'])) {
						$result['AliquotMaster']['qbcf_generated_label_for_display'] = isset($aliquot_view_data['ViewAliquot']['qbcf_generated_label_for_display'])? $aliquot_view_data['ViewAliquot']['qbcf_generated_label_for_display'] : CONFIDENTIAL_MARKER;
					}
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
