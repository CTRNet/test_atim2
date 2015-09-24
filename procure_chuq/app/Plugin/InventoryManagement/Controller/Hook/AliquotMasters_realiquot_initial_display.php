<?php
	
	// --------------------------------------------------------------------------------
	// Set default aliquot data
	// -------------------------------------------------------------------------------- 	
	$procure_default_aliquot_data = array();
	$processing_site_last_barcode = null;
	foreach($this->request->data as $tmp_key => &$new_data_set){
		$sample_master_id = $new_data_set['parent']['AliquotMaster']['sample_master_id'];
		if(in_array($new_data_set['parent']['ViewAliquot']['sample_type'], array('rna','dna'))) $procure_default_aliquot_data[$sample_master_id]['AliquotDetail.concentration_unit'] = 'ng/ul';
		if(Configure::read('procure_atim_version') == 'PROCESSING') {
			if(is_null($processing_site_last_barcode)) {
				$tmp_barcode_data = $this->AliquotMaster->find('first', array('conditions' => array("AliquotMaster.barcode REGEXP '^[0-9]+$'"), 'fields' => array("MAX(AliquotMaster.barcode) AS barcode"), 'recursive'=>'-1'));
				if(empty($tmp_barcode_data['0']['barcode'])) {
					$processing_site_last_barcode = 0;
				} else {
					$processing_site_last_barcode = $tmp_barcode_data['0']['barcode'];
				}
			}
			if(empty($new_data_set['children'])) {
				$processing_site_last_barcode++;
				$new_data_set['children'][] = array('AliquotMaster' => array('barcode' => $processing_site_last_barcode));
			} else {
				foreach($new_data_set['children'] AS &$new_aliquot) {
					$processing_site_last_barcode++;
					$new_aliquot['AliquotMaster']['barcode'] = $processing_site_last_barcode;
				}
			}
		} else {
			$procure_default_aliquot_data[$sample_master_id]['AliquotMaster.barcode'] = $new_data_set['parent']['AliquotMaster']['barcode'];
		}	
	}
	$this->set('procure_default_aliquot_data', $procure_default_aliquot_data);
	