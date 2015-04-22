<?php 
	if(empty($errors)){
		$quantity_calculated = false;
		foreach($this->request->data as &$created_aliquots){
			if($created_aliquots['parent']['ViewSample']['sample_type'] == 'rna') {
				$quantity_calculated = true;
				foreach($created_aliquots['children'] as &$new_aliquot) {
					list($new_aliquot['AliquotDetail']['procure_total_quantity_ug'], $new_aliquot['AliquotDetail']['procure_total_quantity_ug_nanodrop'])  = $this->AliquotMaster->calculateRnaQuantity($new_aliquot);
				}
			}
		}
		if($quantity_calculated) $this->AliquotMaster->addWritableField(array('procure_total_quantity_ug', 'procure_total_quantity_ug_nanodrop'));
	}
	