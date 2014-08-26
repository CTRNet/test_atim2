<?php 

	$default_aliquot_data = array();
	foreach($this->request->data as &$new_sample_record) {
		$set_default_value = true;
		
		$sample_data = $this->SampleMaster->find('first', array('conditions' => array('SampleMaster.id' => $new_sample_record['parent']['ViewSample']['sample_master_id']), 'recursive' => '0'));
		
		$participant_identifier = empty($new_sample_record['parent']['ViewSample']['participant_identifier'])? '?' : $new_sample_record['parent']['ViewSample']['participant_identifier'];

		$visite = $new_sample_record['parent']['ViewSample']['procure_visit'];
		$label = '-?';
		$default_in_stock_value = 'yes - available';
		$default_volume = '';
		$default_concentration_unit = '';
			
		$default_storage_datetime = ($sample_data['SampleControl']['sample_category'] == 'specimen')?  $sample_data['SpecimenDetail']['reception_datetime'] : $sample_data['DerivativeDetail']['creation_datetime'];
		if($default_storage_datetime) $default_storage_datetime = substr($default_storage_datetime, 0, strpos($default_storage_datetime, ' '));
		
		switch($new_sample_record['parent']['ViewSample']['sample_type'].'-'.$aliquot_control['AliquotControl']['aliquot_type']) {
			
			//--------------------------------------------------------------------------------
			//  BLOOD
			//--------------------------------------------------------------------------------
			
			case 'blood-tube':
				$default_in_stock_value = 'no';
				switch($sample_data['SampleDetail']['blood_type']) {
					case 'serum':
						$label = '-SRB';
						$default_volume = '5.0';
						break;
					case 'paxgene':
						$label = '-RNB';
						$default_volume = '9.0';
						break;
					case 'k2-EDTA':
						$label = '-EDB';
						$default_volume = '9.0';
						break;
				}
				break;
				
			case 'blood-whatman paper':
				$label = '-WHT';
				break;
			case 'serum-tube':
				$label = '-SER';
				break;
			case 'plasma-tube':
				$label = '-PLA';
				break;
			case 'pbmc-tube':		
				$label = '-BFC';
				break;
				
			//--------------------------------------------------------------------------------
			//  URINE
			//--------------------------------------------------------------------------------
				
			case 'urine-cup':
				$default_in_stock_value = 'no';
				$default_volume = $sample_data['SampleDetail']['collected_volume'];	
				$label = '-URI';
				break;				
			case 'centrifuged urine-tube':
					$label = '-URN';
					break;
				
			//--------------------------------------------------------------------------------
			//  TISSUE
			//--------------------------------------------------------------------------------
				
			case 'tissue-block':
				$label = '-FRZ';
				break;	
				
			//--------------------------------------------------------------------------------
			//  RNA
			//--------------------------------------------------------------------------------
				
			case 'rna-tube':
				$label = '-RNA';
				$default_concentration_unit = 'ng/ul';
				if(is_null($template_init_id) && sizeof($new_sample_record['children']) == 1) $new_sample_record['children'][1] = $new_sample_record['children'][0];				
				break;		
									
			//--------------------------------------------------------------------------------
			//  DNA
			//--------------------------------------------------------------------------------
				
			case 'dna-tube':
				$label = '-DNA';
				$default_concentration_unit = 'ng/ul';
				if(is_null($template_init_id) && sizeof($new_sample_record['children']) == 1) $new_sample_record['children'][1] = $new_sample_record['children'][0];				
				break;		
									
			default:
				$set_default_value = false;
		}
		
		// SET data 
		
		$tmp_default_aliquot_data = array();
		if($set_default_value) {
			$tmp_default_aliquot_data['AliquotMaster.barcode'] = $participant_identifier . ' ' . $visite . ' ' . $label;
			$tmp_default_aliquot_data['AliquotMaster.in_stock'] = $default_in_stock_value;
			if($default_volume) $tmp_default_aliquot_data['AliquotMaster.initial_volume'] = $default_volume;
			if($default_concentration_unit) $tmp_default_aliquot_data['AliquotDetail.concentration_unit'] = $default_concentration_unit;
			$tmp_default_aliquot_data['AliquotMaster.storage_datetime'] = $default_storage_datetime;
			
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
	