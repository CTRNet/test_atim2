<?php 

	if($tx_master_data['TreatmentControl']['tx_method'] == 'medication worksheet') {
		$ordered_drugs_to_dispay = array(
				'prostate' => array('avodart' => null,'proscar'=> null,'flomax'=> null,'xatral'=> null,'cipro'=> null),
				'open sale' => array('aspirine'=> null, 'advil'=> null, 'tylenol'=> null, 'vitamines'=> null));
		$drug_model = AppModel::getInstance("Drug", "Drug", true);
		$all_drugs = $drug_model->find('all', array('order' => array('Drug.generic_name')));
		foreach($all_drugs as $new_drug) {
			$type = $new_drug['Drug']['type'];
			$generic_name = strtolower($new_drug['Drug']['generic_name']);
	
			if(array_key_exists($generic_name, $ordered_drugs_to_dispay[$type])) $ordered_drugs_to_dispay[$type][$generic_name] = $new_drug['Drug']['id'];
		}
		
		$this->request->data = array();
		foreach($ordered_drugs_to_dispay as $drug_sets) {
			foreach($drug_sets as $generic_name => $drug_id) {
				if($drug_id) $this->request->data[]['TreatmentExtend']['drug_id'] = $drug_id;
			}
		}
	}
	