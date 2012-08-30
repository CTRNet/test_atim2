<?php 

	foreach($this->request->data as &$new_sample_record) {
		$set_default_value = true;
		
		$participant_identifier = empty($new_sample_record['parent']['ViewSample']['participant_identifier'])? '?' : $new_sample_record['parent']['ViewSample']['participant_identifier'];
		$visite = 'V0';
		$label = '-?';
		$default_in_stock_value = 'yes - available';
		$default_volume = '';
		
		switch($new_sample_record['parent']['ViewSample']['sample_type'].'-'.$aliquot_control['AliquotControl']['aliquot_type']) {
			case 'blood-tube':
				$default_in_stock_value = 'no';
				$sample_data = $this->SampleMaster->find('first', array('conditions' => array('SampleMaster.id' => $new_sample_record['parent']['ViewSample']['sample_master_id']), 'recursive' => '0'));
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
				$label = '-RNB';
				break;
			case 'serum-tube':
				$label = '-SER';
				break;
			case 'plasma-tube':
				$label = 'pbmc-PLA';
				break;
			case '-tube':
				$label = '-BFC';
				break;
			default:
				$set_default_value = false;
		}
		
		if($set_default_value) {
		$counter = 0;
			foreach($new_sample_record['children'] AS &$new_aliquot) {
				$counter++;
				$new_aliquot['AliquotMaster']['barcode'] = $participant_identifier . ' ' . $visite . ' ' . $label.$counter;
				$new_aliquot['AliquotMaster']['in_stock'] = $default_in_stock_value;
				if($default_volume) $new_aliquot['AliquotMaster']['initial_volume'] = $default_volume;
				
				if($counter == '3' && $new_sample_record['parent']['ViewSample']['sample_type'] == 'pbmc') $new_aliquot['AliquotMaster']['initial_volume'] = '0.3';
			}
		}		
	}

?>