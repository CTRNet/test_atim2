<?php
	
	if(empty($errors) && (strpos($aliquot_control['AliquotControl']['detail_form_alias'], 'chus_dna_rna_weight') !== false)) {
		if($aliquot_control['AliquotControl']['volume_unit'] != 'ul') $this->redirect('/Pages/err_plugin_record_err?method='.__METHOD__.',line='.__LINE__, null, true); 
		$this->AliquotDetail->addWritableField(array('chum_current_weight_ug'));
		foreach($this->request->data as &$created_aliquots){
			foreach($created_aliquots['children'] as &$new_aliquot_for_weight) {
				$current_volume_ul = $new_aliquot_for_weight['AliquotMaster']['current_volume'];
				$concentration_ug_ml = $new_aliquot_for_weight['AliquotDetail']['concentration'];
				$concentration_unit_ug_ml= $new_aliquot_for_weight['AliquotDetail']['concentration_unit'];
				if(strlen($current_volume_ul.$concentration_ug_ml)) {
					if(strlen($current_volume_ul) && strlen($concentration_ug_ml) && strlen($concentration_unit_ug_ml)) {
						if($concentration_unit_ug_ml != 'ug/ml') $this->redirect('/Pages/err_plugin_record_err?method='.__METHOD__.',line='.__LINE__, null, true);
						$chum_current_weight_ug = ($current_volume_ul/1000)*$concentration_ug_ml;
						$new_aliquot_for_weight['AliquotDetail']['chum_current_weight_ug']=($current_volume_ul/1000)*$concentration_ug_ml;
					} else {
						AppController::addWarningMsg(__('at least one information (volume, concentration, unit) is missing to calculate the current weight'));
					}
				}
			}
		}
	}
