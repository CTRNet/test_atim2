<?php
class AliquotMasterCustom extends AliquotMaster {

	var $useTable = 'aliquot_masters';	
	var $name = 'AliquotMaster';	
	
	function generateDefaultAliquotLabel($view_sample, $aliquot_control_data) {
			
		// Parameters check: Verify parameters have been set
		if(empty($view_sample) || empty($aliquot_control_data)) AppController::getInstance()->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
	
		$sample_type = $view_sample['ViewSample']['sample_type'];
		$qc_tf_bank_id = empty($view_sample['ViewSample']['qc_tf_bank_id'])? null : $view_sample['ViewSample']['qc_tf_bank_id'];
// 		$qc_tf_bank_name = '?';
// 		if($qc_tf_bank_id) {
// 			$bank_model = AppModel::getInstance('Administrate', 'Bank', true);
// 			$bank_data = $bank_model->getOrRedirect($qc_tf_bank_id);
// 			$qc_tf_bank_name = $bank_data['Bank']['name'];
// 		}
// 		$qc_tf_bank_identifier = empty($view_sample['ViewSample']['qc_tf_bank_identifier'])? '?' : $view_sample['ViewSample']['qc_tf_bank_identifier'];
		$participant_identifier = $view_sample['ViewSample']['participant_identifier'];
		
		switch ($view_sample['ViewSample']['sample_type']) {
			case 'blood':
				$sample_label = 'S';
    			break;
    		case 'tissue':
    			$sample_label = ''.(($aliquot_control_data['AliquotControl']['aliquot_type'] == 'tube')? 'FT' : 'FFPE');
    			break;
    		case 'blood cell':
				$sample_label = 'BC';
    			break;
    		case 'amplified dna': 
				$sample_label = 'aDNA';
    			break;			
    		case 'amplified rna':
				$sample_label = 'aRNA';
    			break;					
    		case 'purified rna':	
				$sample_label = 'pRNA';
    			break;			
    		case 'plasma':
				$sample_label = 'PLA';
    			break;	
			case 'serum':
				$sample_label = 'SER';
    			break;	
    		case 'dna': 
				$sample_label = 'DNA';
    			break;				
    		case 'rna':	
				$sample_label = 'RNA';
    			break;
    		case 'ascite':
				$sample_label = 'ASC';
    			break;
    		default :
    			$sample_label = '?';
		}

		$default_sample_label = "$sample_label $participant_identifier";// [$qc_tf_bank_identifier $qc_tf_bank_name]";
		
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
