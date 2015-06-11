<?php 

	$default_aliquot_data = array();
	foreach($this->request->data as &$new_sample_record) {
		$set_default_value = true;
		
		$sample_data = $this->SampleMaster->find('first', array('conditions' => array('SampleMaster.id' => $new_sample_record['parent']['ViewSample']['sample_master_id']), 'recursive' => '0'));
		
		$participant_identifier = empty($new_sample_record['parent']['ViewSample']['participant_identifier'])? '?' : $new_sample_record['parent']['ViewSample']['participant_identifier'];
		$visite = $new_sample_record['parent']['ViewSample']['procure_visit'];
		
		$barcode_suffix = '-?';
		$default_in_stock_value = 'yes - available';
		$default_storage_datetime = ($sample_data['SampleControl']['sample_category'] == 'specimen')?  $sample_data['SpecimenDetail']['reception_datetime'] : $sample_data['DerivativeDetail']['creation_datetime'];
		if($default_storage_datetime) $default_storage_datetime = substr($default_storage_datetime, 0, strpos($default_storage_datetime, ' '));
		$default_volume = '';
		$default_concentration_unit = '';
		$default_procure_card_completed_datetime = '';
		
		switch($new_sample_record['parent']['ViewSample']['sample_type'].'-'.$aliquot_control['AliquotControl']['aliquot_type']) {	
			//--------------------------------------------------------------------------------
			//  BLOOD
			//--------------------------------------------------------------------------------
			case 'blood-tube':
				switch($sample_data['SampleDetail']['blood_type']) {
					case 'serum':
						$barcode_suffix = '-SRB';
						$default_in_stock_value = 'no';
						$default_storage_datetime = '';
						$default_volume = '5.0';
						break;
					case 'paxgene':
						$barcode_suffix = '-RNB';
						$default_volume = '9.0';
						break;
					case 'k2-EDTA':
						$barcode_suffix = '-EDB';
						$default_in_stock_value = 'no';
						$default_storage_datetime = '';
						$default_volume = '9.0';
						break;
					default:
						$barcode_suffix = '-?';
						$default_in_stock_value = 'no';
						$default_storage_datetime = '';
				}
				break;
			case 'blood-whatman paper':
				$barcode_suffix = '-WHT';
				$default_procure_card_completed_datetime = $default_storage_datetime;
				$default_storage_datetime = '';
				break;
			case 'serum-tube':
				$barcode_suffix = '-SER';
				break;
			case 'plasma-tube':
				$barcode_suffix = '-PLA';
				break;
			case 'pbmc-tube':		
				$barcode_suffix = '-BFC';
				break;
			//--------------------------------------------------------------------------------
			//  URINE
			//--------------------------------------------------------------------------------
			case 'urine-cup':
				$barcode_suffix = '-URI';
				$default_in_stock_value = 'no';
				$default_storage_datetime = '';
				$default_volume = $sample_data['SampleDetail']['collected_volume'];	
				break;				
			case 'centrifuged urine-tube':
				$barcode_suffix = '-URN';
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
		
		$tmp_default_aliquot_data = array();
		if($set_default_value) {
			$tmp_default_aliquot_data['AliquotMaster.barcode'] = $participant_identifier . ' ' . $visite . ' ' . $barcode_suffix;
			$tmp_default_aliquot_data['AliquotMaster.in_stock'] = $default_in_stock_value;
			$tmp_default_aliquot_data['AliquotMaster.storage_datetime'] = $default_storage_datetime;
			if(strlen($default_volume)) $tmp_default_aliquot_data['AliquotMaster.initial_volume'] = $default_volume;
			if($default_concentration_unit) $tmp_default_aliquot_data['AliquotDetail.concentration_unit'] = $default_concentration_unit;
			if($default_procure_card_completed_datetime) {
				$tmp_default_aliquot_data['AliquotDetail.procure_card_completed_datetime'] = $default_procure_card_completed_datetime;
				$tmp_default_aliquot_data['AliquotDetail.procure_card_sealed_date'] = $default_procure_card_completed_datetime;				
			}
			//Add barcode suffix number
			$counter = 0;
			foreach($new_sample_record['children'] AS &$new_aliquot) {
				$counter++;
				$new_aliquot['AliquotMaster']['barcode'] = $tmp_default_aliquot_data['AliquotMaster.barcode'].$counter;				
				if($counter == '3' && $new_sample_record['parent']['ViewSample']['sample_type'] == 'pbmc') $new_aliquot['AliquotMaster']['initial_volume'] = '0.3';
			}
		}	
		$default_aliquot_data[$new_sample_record['parent']['ViewSample']['sample_master_id']] = $tmp_default_aliquot_data;
	}
	$this->set('default_aliquot_data', $default_aliquot_data);
	