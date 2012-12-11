<?php
class AliquotMasterCustom extends AliquotMaster {

	var $useTable = 'aliquot_masters';	
	var $name = 'AliquotMaster';	
	
	function generateDefaultAliquotLabel($sample_master_id) {
		$SampleModel = AppModel::getInstance('InventoryManagement', 'SampleMaster', true);
		$sample_data = $SampleModel->find('first', array('conditions' => array('SampleMaster.id' => $sample_master_id), 'recursive' => 0));
		if(empty($sample_data)) AppController::getInstance()->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		
		if($sample_data['SampleControl']['sample_type'] != 'tissue') {
			return '';
		}
		
		$bank_id = empty($sample_data['ViewSample']['bank_id'])? null : $sample_data['ViewSample']['bank_id'];
		$qc_tf_bank_name = '?';
		if($bank_id) {
			$bank_model = AppModel::getInstance('Administrate', 'Bank', true);
			$bank_data = $bank_model->getOrRedirect($bank_id);
			$qc_tf_bank_name = $bank_data['Bank']['name'];
		}
		$qc_tf_bank_participant_identifier = empty($sample_data['ViewSample']['qc_tf_bank_participant_identifier'])? '?' : $sample_data['ViewSample']['qc_tf_bank_participant_identifier'];

		$default_sample_label = $qc_tf_bank_participant_identifier.' '.(str_replace(array('normal','benin','tumoral','unknown',''), array('N','B','T','U','U'), $sample_data['SampleDetail']['qc_tf_collected_specimen_nature'])).' ['. $qc_tf_bank_name.']';
		
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
