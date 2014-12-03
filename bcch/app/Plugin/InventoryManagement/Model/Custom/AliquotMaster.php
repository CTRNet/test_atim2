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
	
	function generateAliquotLabel($view_sample, $aliquot_control_data, $current_aliquot_count) {
		// Parameters check: Verify parameters have been set
		if(empty($view_sample) || empty($aliquot_control_data)) AppController::getInstance()->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		
		// Participant Identifier + Sample Type + Sample #(AI) + Aliquot #(AI) Ex: C0001BL0101	
		$aliquot_label = '';
		
		// Get current participant identifier
		$participant_identifier = 'C00000';
		
		// $identifier_value = empty($view_sample['ViewSample']['identifier_value'])? '?': $view_sample['ViewSample']['identifier_value'];

		// Set sample label based on sample type				
		$sample_label = '';
		switch($view_sample['ViewSample']['sample_type']) {
			case 'blood':
				$sample_label = 'BL';
				break;
			case 'bone marrow':
				$sample_label = 'BM';
				break;
			case 'cell culture':
				$sample_label = 'CC';
				break;
			case 'cell lysate':
				$sample_label = 'CL';
				break;
			case 'csf':
				$sample_label = 'CSF';
				break;
			case 'rna':
				$sample_label = 'RNA';
				break;
			case 'saliva':
				$sample_label = 'SL';
				break;
			case 'tissue':
				$sample_label = 'TI';
				break;
			case 'tissue suspension':
				$sample_label = 'TS';
				break;
		}
		
		// Get sample number for current participant
		$sample_count = '01'; 
		
		// Get sample number for current participant
		// $aliquot_count = '01'; 
		
		$aliquot_label = $participant_identifier . '' . $sample_label . $sample_count . $current_aliquot_count;
		
		return $aliquot_label;
	}
	
	function generateAliquotBarcode($aliquotIDs) {
		
		// Get all aliquots that now need barcodes
		$aliquots_to_update = 
			$this->find('all', array('conditions' => array('AliquotMaster.id' => $aliquotIDs)));			
		
		// Update barcode for selected aliquots
		foreach($aliquots_to_update as $aliquot) {
			// Find next barcode to use
			$new_barcode = $this->findNextBarcode();
			
			$aliquot_data = array('AliquotMaster' => array('barcode' => $new_barcode), 'AliquotDetail' => array());
			$this->id = $aliquot['AliquotMaster']['id'];
			$this->data = null;
			$this->addWritableField(array('barcode'));
			$this->save($aliquot_data, false);
		}
	}
	
	function findNextBarcode() {
		
		// Find all barcodes, including for deleted aliquots
		$barcodes = 
			$this->find('all', array('conditions' => array('AliquotMaster.deleted' => array(0,1)),
			'fields' => array('AliquotMaster.barcode')));
		
		// Generate random barcodes until one not used is created
		do {
			$valid_barcode = true;
			$next_barcode = rand(1000000000, 9999999999);
			$next_barcode = (string)$next_barcode;
			// Search existing set of barcodes for a match to newly generated barcode
			foreach ($barcodes as $key => $val) {
       			if ($val['AliquotMaster']['barcode'] === $next_barcode) {
           			$valid_barcode = false;
       			}
   			}
		} while (!$valid_barcode);
		return $next_barcode;
	}
}

?>