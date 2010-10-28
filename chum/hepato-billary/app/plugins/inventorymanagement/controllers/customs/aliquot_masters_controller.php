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
	
	function generateDefaultAliquotLabel($collection_id, $sample_master_id, $aliquot_control_data) {	
		// Parameters check: Verify parameters have been set
		if(empty($collection_id) || empty($sample_master_id) || empty($aliquot_control_data)) { $this->redirect('/pages/err_inv_system_error', null, true); }

		// Get Sample Data
		$this->SampleMaster->unbindModel(array('hasMany' => array('AliquotMaster'), 'belongsTo' => array('Collection')));
		$sample_data = $this->SampleMaster->find('first', array('conditions' => array('SampleMaster.collection_id' => $collection_id, 'SampleMaster.id' => $sample_master_id)));
		if(empty($sample_data)) { $this->redirect('/pages/err_inv_system_error', null, true); }
		
		$sample_label = null;	
		$aliquot_creation_date = null;	
		if($sample_data['SampleMaster']['sample_category'] == 'specimen') {
			$sample_label = $this->createSpecimenSampleLabel($collection_id, $sample_master_id, $sample_data);
			$aliquot_creation_date = $sample_data['SpecimenDetail']['reception_datetime'];
		
		} else if($sample_data['SampleMaster']['sample_category'] == 'derivative'){
			$initial_specimen_label = $this->createSpecimenSampleLabel($collection_id, $sample_data['SampleMaster']['initial_specimen_sample_id']);
			$sample_type_code = $sample_data['SampleControl']['sample_type_code'];

			switch ($sample_data['SampleMaster']['sample_type']) {
				case 'pbmc':
				case 'plasma':
				case 'serum':			
	    		case 'tissue suspension':
					$sample_label = $sample_type_code. ' ' . $initial_specimen_label;
	    			break;
	    		default :
	    			// Type is unknown
					$this->redirect('/pages/err_inv_system_error', null, true);
			}
			
			$aliquot_creation_date = $sample_data['DerivativeDetail']['creation_datetime'];
			
		} else {
			$this->redirect('/pages/err_inv_system_error', null, true);
		}		
		
		return $sample_label . (empty($aliquot_creation_date)? '' : ' ' . substr($aliquot_creation_date, 0, strpos($aliquot_creation_date," ")));
	}
	
	function createSpecimenSampleLabel($collection_id, $specimen_sample_master_id, $specimen_data = null) {
		$new_sample_label = null;
				
		// Parameters check: Verify parameters have been set
		if(empty($collection_id) || empty($specimen_sample_master_id)) { $this->redirect('/pages/err_inv_system_error', null, true); }
		
		if(is_null($specimen_data)) {
			// Get Specimen Data
			$this->SampleMaster->unbindModel(array('hasMany' => array('AliquotMaster'), 'belongsTo' => array('Collection')));
			$specimen_data = $this->SampleMaster->find('first', array('conditions' => array('SampleMaster.collection_id' => $collection_id, 'SampleMaster.id' => $specimen_sample_master_id)));
			if(empty($specimen_data)) { $this->redirect('/pages/err_inv_no_data', null, true); }				
		}

		if(!isset($specimen_data['SpecimenDetail'])) { $this->redirect('/pages/err_inv_system_error', null, true); }
		
		// Build label
		if(!array_key_exists('qc_hb_sample_code', $specimen_data['SpecimenDetail'])) { $this->redirect('/pages/err_inv_system_error', null, true); }
		$specimen_type_code =  (empty($specimen_data['SpecimenDetail']['qc_hb_sample_code']))? 'n/a' : $specimen_data['SpecimenDetail']['qc_hb_sample_code']; 
		
		App::import('Model', 'Inventorymanagement.ViewCollection');		
		$ViewCollection = new ViewCollection();					
		$view_collection = $ViewCollection->find('first', array('conditions' => array('ViewCollection.collection_id' => $collection_id)));
		if(empty($view_collection)) { $this->redirect('/pages/err_inv_system_error', null, true); }
		$bank_participant_identifier = empty($view_collection['ViewCollection']['hepato_bil_bank_participant_id'])? 'n/a' : $view_collection['ViewCollection']['hepato_bil_bank_participant_id'];		

		$new_sample_label = $specimen_type_code . ' - ' . $bank_participant_identifier;
		switch ($specimen_data['SampleMaster']['sample_type']) {
			// Specimen
			case 'blood':
				if(!array_key_exists('blood_type', $specimen_data['SampleDetail'])) { $this->redirect('/pages/err_inv_system_error', null, true); }
				$new_sample_label .= (empty($specimen_data['SampleDetail']['blood_type'])? ' n/a': ' ' . $specimen_data['SampleDetail']['blood_type']);	
    			break;
    			
			case 'tissue':
				if(!array_key_exists('tissue_laterality', $specimen_data['SampleDetail'])) { $this->redirect('/pages/err_inv_system_error', null, true); }
				switch($specimen_data['SampleDetail']['tissue_laterality']) {
					case 'left':
						$new_sample_label .= ' L';
						break;
					case 'right':
						$new_sample_label .= ' R';
						break;
					default:
						$new_sample_label .= ' n/a';
				}
				break;
    		
    		default :
    			// Type is unknown
				$this->redirect('/pages/err_inv_system_error', null, true);
		}

		return $new_sample_label;
	}

}

?>