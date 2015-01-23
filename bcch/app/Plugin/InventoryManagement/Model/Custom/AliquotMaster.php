<?php
class AliquotMasterCustom extends AliquotMaster {

	var $useTable = 'aliquot_masters';	
	var $name = 'AliquotMaster';	
	
/*	function summary($variables=array()) {
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
*/	
	function generateAliquotLabel($sample_master_data, $aliquot_control_data, $aliquotIDs) {
		// Parameters check: Verify parameters have been set
		if(empty($sample_master_data) || empty($aliquot_control_data)) AppController::getInstance()->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		
		// Get all aliquots that need labels
		$aliquots_to_update = 
			$this->find('all', array('conditions' => array('AliquotMaster.id' => $aliquotIDs)));

		$sample_code = $sample_master_data['ViewSample']['sample_code'];
		$number_aliquots = count($aliquots_to_update);
		$new_label = '';
		$i = 1;
					
		// Save aliquot labels
		foreach($aliquots_to_update as $aliquot) {
			
			$new_label = $sample_code.$i;
			$i = $i + 1;
			$aliquot_data = array('AliquotMaster' => array('aliquot_label' => $new_label), 'AliquotDetail' => array());
			$this->id = $aliquot['AliquotMaster']['id'];
			$this->data = null;
			$this->addWritableField(array('aliquot_label'));
			$this->save($aliquot_data, false);
		}
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