<?php
class AliquotMasterCustom extends AliquotMaster {

	var $useTable = 'aliquot_masters';	
	var $name = 'AliquotMaster';	
	
	function summary($variables=array()) {
		$return = false;
		
		if (isset($variables['Collection.id']) && isset($variables['SampleMaster.id']) && isset($variables['AliquotMaster.id'])) {
			
			$result = $this->find('first', array('conditions'=>array('AliquotMaster.collection_id'=>$variables['Collection.id'], 'AliquotMaster.sample_master_id'=>$variables['SampleMaster.id'], 'AliquotMaster.id'=>$variables['AliquotMaster.id'])));
			if(!isset($result['AliquotMaster']['storage_coord_y'])){
				$result['AliquotMaster']['storage_coord_y'] = "";
			}
			$return = array(
					'menu'	        	=> array(null, __($result['AliquotControl']['aliquot_type'], true) . ' : '. $result['AliquotMaster']['aliquot_label']),
					'title'		  		=> array(null, __($result['AliquotControl']['aliquot_type'], true) . ' : '. $result['AliquotMaster']['aliquot_label']),
					'data'				=> $result,
					'structure alias'	=> 'aliquot_masters'
			);
		}
		
		return $return;
	}
	
	function generateDefaultAliquotLabel($view_sample, $aliquot_control_data) {
			
		// Parameters check: Verify parameters have been set
		if(empty($view_sample) || empty($aliquot_control_data)) AppController::getInstance()->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		
		// Set date for aliquot label			
		$aliquot_creation_date = '';			
		if($view_sample['ViewSample']['sample_category'] == 'specimen'){
			// Specimen Aliquot
			if(!isset($this->SpecimenDetail)){
				$this->SpecimenDetail = AppModel::getInstance('InventoryManagement', 'SpecimenDetail', true);
			}
			$specimen_detail = $this->SpecimenDetail->getOrRedirect($view_sample['ViewSample']['sample_master_id']);
			
			$aliquot_creation_date = $specimen_detail['SpecimenDetail']['reception_datetime'];

		}else{
			// Derviative Aliquot
			if(!isset($this->DerivativeDetail)){
				$this->DerivativeDetail = AppModel::getInstance('InventoryManagement', 'DerivativeDetail', true);
			}
			
			$derivative_detail = $this->DerivativeDetail->getOrRedirect($view_sample['ViewSample']['sample_master_id']);
			
			$aliquot_creation_date = $derivative_detail['DerivativeDetail']['creation_datetime'];
		} 
		
		$default_sample_label =
			(empty($view_sample['ViewSample']['qc_nd_sample_label'])? 'n/a' : $view_sample['ViewSample']['qc_nd_sample_label']) .
			(empty($aliquot_creation_date)? '' : ' ' . substr($aliquot_creation_date, 0, strpos($aliquot_creation_date," ")));

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
}

?>
