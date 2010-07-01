<?php

class AliquotMastersControllerCustom extends AliquotMastersController {
	
	/**
	 * Create a default aliquot label based on collection
	 * and sample data.
	 *
	 * @param $sample_data Data of the sample.
	 * @param $aliquot_control_data Aliquot control data.
	 * 
	 * @author N. Luc
	 * @date 2007-11-29
	 */
	function generateDefaultAliquotLabel($sample_data, $aliquot_control_data) {
				
		// Parameters check: Verify parameters have been set
		if(empty($sample_data) || empty($aliquot_control_data)) { $this->redirect('/pages/err_inv_system_error', null, true); }
	
		// Get collection data
		App::import('Model', 'Inventorymanagement.ViewCollection');		
		$ViewCollection = new ViewCollection();
				
		$view_collection = $ViewCollection->find('first', array('conditions' => array('ViewCollection.collection_id' => $sample_data['SampleMaster']['collection_id'])));
		if(empty($view_collection)) { $this->redirect('/pages/err_inv_system_error', null, true); }

		// Check collection is a prostate bank collection
		$is_prostate_bank_collection = false;	
		if(!empty($view_collection['ViewCollection']['bank_id'])) {
			// Find bank data
			App::import('Model', 'Administrate.Bank');		
			$Bank = new Bank();		
			$collection_bank_data = $Bank->find('first', array('conditions' => array('Bank.id' => $view_collection['ViewCollection']['bank_id'])));
			if(empty($collection_bank_data)) { $this->redirect('/pages/err_inv_system_error', null, true); }
			
			
			if(!empty($collection_bank_data['Bank']['misc_identifier_control_id'])) {
				// Check identifier of the bank is prostate bank identifier
				App::import('Model', 'Clinicalannotation.MiscIdentifierControl');
				$MiscIdentifierControl = new MiscIdentifierControl();				
					
				$is_prostate_bank_identifier = $MiscIdentifierControl->find('count', array('conditions' => array('MiscIdentifierControl.id' => $collection_bank_data['Bank']['misc_identifier_control_id'], 'MiscIdentifierControl.misc_identifier_name' => 'prostate bank no lab')));
				$is_prostate_bank_collection = ($is_prostate_bank_identifier? true : false);
			}
		}
			
		// Set Default Sample Label
		$default_sample_label = '';
				
		if($is_prostate_bank_collection) {
			
			// ** Manage label for prostate bank **
			
			$visit_label = (empty($view_collection['ViewCollection']['visit_label'])? 'V0' : $view_collection['ViewCollection']['visit_label']);
			$default_sample_label = 'PS1P_PROCURE_BC '.$visit_label;
			
			switch($sample_data['SampleMaster']['sample_type']) {
				case 'serum':
					$default_sample_label .= ' -SER1';
					break;
				case 'plasma':
					$default_sample_label .= ' -PLA1';
					break;
				case 'b cell':
				case 'pbmc':
				case 'blood cell':
					$default_sample_label .= ' -BFC1';
					break;
				case 'centrifuged urine':
					$default_sample_label .= ' -URN1';
					break;
				case 'rna':
					$default_sample_label .= ' -RNA1';
					break;
				case 'blood':
					if($aliquot_control_data['AliquotControl']['aliquot_type'] == 'whatman paper') {
						$default_sample_label .= ' -WHT1';
					} else if(strpos($sample_data['SampleMaster']['sample_label'], 'EDTA') !== FALSE) {
						$default_sample_label .= ' -EDB1';
					} else if(strpos($sample_data['SampleMaster']['sample_label'], 'ZCSA') !== FALSE) {
						$default_sample_label .= ' -SRB1';
					} else if(strpos($sample_data['SampleMaster']['sample_label'], 'gel SST') !== FALSE) {
						$default_sample_label .= ' -SRB1';
					} else if(strpos($sample_data['SampleMaster']['sample_label'], 'paxgene') !== FALSE) {
						$default_sample_label .= ' -RNB1';
					}
					break;
				default:
					// Keep label empty to be managed by the rest of the code	
					$default_sample_label = '';
			}
			
			if(!(empty($default_sample_label) || empty($view_collection['ViewCollection']['participant_id']))) {
				// Try to add procure barcode to the label
				App::import('Model', 'Clinicalannotation.MiscIdentifier');
				$MiscIdentifier = new MiscIdentifier();	
				
				$criteria = array();
				$criteria['MiscIdentifier.participant_id'] = $view_collection['ViewCollection']['participant_id'];
				$criteria['MiscIdentifier.identifier_name'] = 'code-barre';
				$code_barre_data = $MiscIdentifier->find('first', array('conditions' => $criteria));		
				
				$default_sample_label = str_replace('_PROCURE_BC', (empty($code_barre_data)? '0' : $code_barre_data['MiscIdentifier']['identifier_value']), $default_sample_label);
			}
		}
		
		if(empty($default_sample_label)) {
			
			// ** Manage label for either all bank excepted prostate bank or undefined sample label **
			
			// Set date for aliquot label			
			$aliquot_creation_date = '';			
			if($sample_data['SampleMaster']['sample_category'] == 'specimen') {
				// Specimen Aliquot
				if(!isset($this->SpecimenDetail)) {
					App::import('Model', 'Clinicalannotation.SpecimenDetail');
					$this->SpecimenDetail = new SpecimenDetail();	
				}
				$specimen_detail = $this->SpecimenDetail->find('first', array('conditions' => array('sample_master_id' => $sample_data['SampleMaster']['id'])));
				if(empty($specimen_detail)) { $this->redirect('/pages/err_inv_system_error', null, true); }
				$aliquot_creation_date = $specimen_detail['SpecimenDetail']['reception_datetime'];

			} else {
				// Derviative Aliquot
				$derivative_detail = $this->DerivativeDetail->find('first', array('conditions' => array('sample_master_id' => $sample_data['SampleMaster']['id'])));
				if(empty($derivative_detail)) { $this->redirect('/pages/err_inv_system_error', null, true); }
				$aliquot_creation_date = $derivative_detail['DerivativeDetail']['creation_datetime'];
	
			} 
			
			$default_sample_label =
				(empty($sample_data['SampleMaster']['sample_label'])? 'n/a' : $sample_data['SampleMaster']['sample_label']) .
				(empty($aliquot_creation_date)? '' : ' ' . substr($aliquot_creation_date, 0, strpos($aliquot_creation_date," ")));
		}

		return $default_sample_label;
	}
	
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