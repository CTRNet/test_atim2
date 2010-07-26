<?php

class AliquotMastersControllerCustom extends AliquotMastersController {
	
	/**
	 * Create default aliquot barcodes that will be unique.
	 * 
	 * @author N. Luc
	 * @date 2007-11-29
	 */
	function generateDefaultAliquotBarcode($sample_data) {
		if(!empty($this->data)) {
			// Get last aliquot master id
			$tmp_id_search = $this->AliquotMaster->query("SELECT MAX( id ) FROM `aliquot_masters`");
			$tmp_last_aliq_master_id = empty($tmp_id_search)? '0' : ($tmp_id_search[0][0]['MAX( id )']);
	
			$stop_barcode_creation = false;
			$suffix = '';
			$counter = 0;
			while(!$stop_barcode_creation) {
				$next_aliq_master_id = $tmp_last_aliq_master_id;
				foreach($this->data as $key => $new_record){
					$next_aliq_master_id++;
					$this->data[$key]['AliquotMaster']['barcode'] = 'tmp_'.str_replace(" ", "", $sample_data['SampleMaster']['sample_code']).'_'.$next_aliq_master_id.$suffix;
				}
								
				$duplicated_barcode_validation = $this->isDuplicatedAliquotBarcode($this->data);
				if($duplicated_barcode_validation['is_duplicated_barcode']) {
					// Duplicated barcodes : add suffix
					$suffix = '.'.$counter;
				} else {
					// Barcodes creation done without duplicated barcodes
					return;
				}
				
				// counter to avoid loop
				$counter++;
				if($counter > 5) { $stop_barcode_creation = true; }			
			}
			
			// Launch page error
			$this->redirect('/pages/qc_err_inv_barcode_generation_error', null, true);
		}	
	}

}

?>