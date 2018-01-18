<?php 
	
	//$aliquot_control
	if($aliquot_control['AliquotControl']['aliquot_type'] == 'whatman paper') {
		AppController::addWarningMsg(__('whatman paper should not be created anymore'));
	}
	
	$default_aliquot_data = array();
	$processing_site_last_barcode = null;
	$data_set_nbr_in_error = array();
	$tmp_record_counter = 0;
	foreach($this->request->data as &$new_sample_record) {
		
	    // ATiM Processing Site Data Check
	    //===================================================	
	    // A new aliquot can be created for a sample created by system to migrate aliquot from ATiM-Processing site and defined as created by another bank than the bank of the ATiM used when
	    // at least one aliquot is still recorded for this sample (aliquot previously transferred from bank different than PS3 to 'Processing Site'
	    // and now merged into the ATiM of PS3)
	        
	    $tmp_record_counter++;
	    if($new_sample_record['parent']['ViewSample']['procure_created_by_bank'] == 's') {
	        $tmp_aliquots_count = $this->AliquotMaster->find('count', array('conditions' => array('AliquotMaster.sample_master_id' => $new_sample_record['parent']['ViewSample']['sample_master_id'])));
	        if(!$tmp_aliquots_count) {
	            $data_set_nbr_in_error[] = $tmp_record_counter;
	        }
	    }
	    
		// Set Default Data
		//===================================================
		
		$set_default_value = true;
		$tmp_default_aliquot_data = array();
		
		$sample_data = $this->SampleMaster->find('first', array('conditions' => array('SampleMaster.id' => $new_sample_record['parent']['ViewSample']['sample_master_id']), 'recursive' => '0'));
		
		$participant_identifier = empty($new_sample_record['parent']['ViewSample']['participant_identifier'])? '?' : $new_sample_record['parent']['ViewSample']['participant_identifier'];
		$visite = $new_sample_record['parent']['ViewSample']['procure_visit'];
		
		$barcode_suffix = '-?';
		$default_in_stock_value = 'yes - available';
		$default_storage_datetime = ($sample_data['SampleControl']['sample_category'] == 'specimen')?  $sample_data['SpecimenDetail']['reception_datetime'] : $sample_data['DerivativeDetail']['creation_datetime'];
		$default_storage_datetime_accuracy = 'h';
		if(in_array($new_sample_record['parent']['ViewSample']['sample_type'], array('serum', 'pbmc', 'buffy coat', 'plasma'))) {
			$sample_control_ids = $this->SampleControl->find('list', array('conditions' => array('sample_type' => array('serum', 'plasma', 'buffy coat', 'pbmc'))));
			$aliquot_control_ids = $this->AliquotControl->find('list', array('conditions' => array('sample_control_id' => $sample_control_ids)));
			$collection_blood_derivative_aliquots = $this->AliquotMaster->find('first', array('conditions' => array('AliquotMaster.collection_id' => $new_sample_record['parent']['ViewSample']['collection_id'], 'AliquotMaster.aliquot_control_id' => $aliquot_control_ids), 'order' => array('AliquotMaster.storage_datetime DESC'), 'recursive' => '1'));
			if($collection_blood_derivative_aliquots) {
				$default_storage_datetime = $collection_blood_derivative_aliquots['AliquotMaster']['storage_datetime'];
				$default_storage_datetime_accuracy = $collection_blood_derivative_aliquots['AliquotMaster']['storage_datetime_accuracy'];
			}
		}			
		$default_volume = '';
		$default_concentration_unit = '';
		$default_hemolysis_signs = '';
		
		$default_storage = null;
		$last_stored_aliquot = $this->AliquotMaster->find('first', array('conditions' => array('AliquotMaster.aliquot_control_id' => $aliquot_control['AliquotControl']['id'], 'AliquotMaster.storage_master_id IS NOT NULL'), 'recursive' => '0', 'order' => array('AliquotMaster.created DESC')));
		if($last_stored_aliquot) $default_storage = $this->StorageMaster->getStorageLabelAndCodeForDisplay(array('StorageMaster' => $last_stored_aliquot['StorageMaster']));
		
		switch($new_sample_record['parent']['ViewSample']['sample_type'].'-'.$aliquot_control['AliquotControl']['aliquot_type']) {	
			//--------------------------------------------------------------------------------
			//  BLOOD
			//--------------------------------------------------------------------------------
			case 'blood-tube':
				switch($sample_data['SampleDetail']['blood_type']) {
					case 'paxgene':
						$barcode_suffix = '-RNB';
						$default_volume = '9';
						break;
					default:
						$barcode_suffix = '-?';
						$default_in_stock_value = 'no';
				}
				break;
			case 'serum-tube':
				$default_hemolysis_signs = 'n';
				$default_volume = '1.8';
				$barcode_suffix = '-SER';
				break;
			case 'plasma-tube':
				$default_hemolysis_signs = 'n';
				$default_volume = '1.8';
				$barcode_suffix = '-PLA';
				break;
			case 'pbmc-tube':		
				$barcode_suffix = '-PBMC';
				$default_volume = '1';
				$tmp_default_aliquot_data['AliquotDetail.procure_date_at_minus_80'] = substr($default_storage_datetime, 0, 10);
				$tmp_default_aliquot_data['AliquotDetail.procure_date_at_minus_80_accuracy'] = str_replace(array('', 'i', 'h'), array('c', 'c', 'c'), $default_storage_datetime_accuracy);
				if($tmp_default_aliquot_data['AliquotDetail.procure_date_at_minus_80_accuracy'] == 'c') {
				    $default_storage_datetime = date('Y-m-d', strtotime($tmp_default_aliquot_data['AliquotDetail.procure_date_at_minus_80']."+1 day"));
                    $default_storage_datetime_accuracy = 'h';
				} else {
				    $default_storage_datetime = '';
                    $default_storage_datetime_accuracy = '';
				}
				break;
			case 'buffy coat-tube':		
				$barcode_suffix = '-BFC';
				break;
			//--------------------------------------------------------------------------------
			//  URINE
			//--------------------------------------------------------------------------------
			case 'urine-cup':
				$barcode_suffix = '-URI';
				$default_in_stock_value = 'no';
				$default_volume = $sample_data['SampleDetail']['collected_volume'];	
				break;				
			case 'centrifuged urine-tube':
				$barcode_suffix = '-URN';
				$default_volume = '5';
				break;
			//--------------------------------------------------------------------------------
			//  TISSUE
			//--------------------------------------------------------------------------------
			case 'tissue-block':
				$barcode_suffix = '-FRZ';
				break;
			//--------------------------------------------------------------------------------
			//  RNA
			//--------------------------------------------------------------------------------
			case 'rna-tube':
				$barcode_suffix = '-RNA';
				$default_concentration_unit = 'ng/ul';
				if(is_null($template_init_id) && sizeof($new_sample_record['children']) == 1) $new_sample_record['children'][1] = $new_sample_record['children'][0];				
				break;
			//--------------------------------------------------------------------------------
			//  DNA
			//--------------------------------------------------------------------------------
			case 'dna-tube':
				$barcode_suffix = '-DNA';
				$default_concentration_unit = 'ng/ul';
				if(is_null($template_init_id) && sizeof($new_sample_record['children']) == 1) $new_sample_record['children'][1] = $new_sample_record['children'][0];				
				break;
			//--------------------------------------------------------------------------------
			//  Unknown
			//--------------------------------------------------------------------------------
			default:
				$set_default_value = false;
		}
		
		// SET data 
		
		if($set_default_value) {
			$tmp_default_aliquot_data['AliquotMaster.barcode'] = $participant_identifier . ' ' . $visite . ' ' . $barcode_suffix;
			$tmp_default_aliquot_data['AliquotMaster.in_stock'] = $default_in_stock_value;
			$tmp_default_aliquot_data['AliquotMaster.storage_datetime'] = $default_storage_datetime;
			$tmp_default_aliquot_data['AliquotMaster.storage_datetime_accuracy'] = $default_storage_datetime_accuracy;
			if(strlen($default_volume)) $tmp_default_aliquot_data['AliquotMaster.initial_volume'] = $default_volume;
			if($default_concentration_unit) $tmp_default_aliquot_data['AliquotDetail.concentration_unit'] = $default_concentration_unit;
			if($default_hemolysis_signs) $tmp_default_aliquot_data['AliquotDetail.hemolysis_signs'] = $default_hemolysis_signs;
			if($default_storage) $tmp_default_aliquot_data['FunctionManagement.recorded_storage_selection_label'] = $default_storage;
			//Add barcode suffix number
			$counter = 0;
			foreach($new_sample_record['children'] AS &$new_aliquot) {
				$counter++;
				if($counter == '2' && $new_sample_record['parent']['ViewSample']['sample_type'] == 'buffy coat') {
					$counter++;
					$new_aliquot['AliquotMaster']['initial_volume'] = '0.3';
				}
				$new_aliquot['AliquotMaster']['barcode'] = $tmp_default_aliquot_data['AliquotMaster.barcode'].$counter;	
			}
            $default_aliquot_data[$new_sample_record['parent']['ViewSample']['sample_master_id']] = $tmp_default_aliquot_data;
		}
	}
	$this->set('default_aliquot_data', $default_aliquot_data);
	
	// ATiM Processing Site Data Check
	//===================================================
	
	if($data_set_nbr_in_error) {
	    $this->flash(
	        __('no aliquot can be created from sample created by system/script to migrate data from the processing site with no aliquot').' '.str_replace('%s', '['.implode('] ,[',$data_set_nbr_in_error).']', __('see # %s')),
	        $url_to_cancel,
	        5);
	    return;
	}
	
	
	