<?php 
	if(empty($errors)){
		$tmp_sample_control = $this->SampleControl->getOrRedirect($child_aliquot_ctrl['AliquotControl']['sample_control_id']);
		if($tmp_sample_control['SampleControl']['sample_type'] == 'rna') {
			foreach($this->request->data as &$created_aliquots){
				foreach($created_aliquots['children'] as &$new_aliquot) {
					list($new_aliquot['AliquotDetail']['procure_total_quantity_ug'], $new_aliquot['AliquotDetail']['procure_total_quantity_ug_nanodrop'])  = $this->AliquotMaster->calculateRnaQuantity($new_aliquot);
				}
			}
			$this->AliquotMaster->addWritableField(array('procure_total_quantity_ug', 'procure_total_quantity_ug_nanodrop'));
		}
	}
	