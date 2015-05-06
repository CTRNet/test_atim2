<?php 
	if(empty($errors)){
		$quantity_calculated = false;
		foreach($this->request->data as &$tmp_created_aliquots){
			if($tmp_created_aliquots['parent']['ViewSample']['sample_type'] == 'rna') {
				$quantity_calculated = true;
				foreach($tmp_created_aliquots['children'] as &$tmp_new_aliquot) {
					list($tmp_new_aliquot['AliquotDetail']['procure_total_quantity_ug'], $tmp_new_aliquot['AliquotDetail']['procure_total_quantity_ug_nanodrop'])  = $this->AliquotMaster->calculateRnaQuantity($tmp_new_aliquot);
				}
			}
		}
		if($quantity_calculated) $this->AliquotMaster->addWritableField(array('procure_total_quantity_ug', 'procure_total_quantity_ug_nanodrop'));
	}
	