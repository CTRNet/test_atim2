<?php

	// --------------------------------------------------------------------------------
	// Set default aliquot label(s)
	// --------------------------------------------------------------------------------
	if(isset($default_aliquot_labels)){
		foreach($this->request->data as &$tmp_new_aliquots_set) {
			if(isset($default_aliquot_labels[$tmp_new_aliquots_set['parent']['ViewSample']['sample_master_id']])) {
				$tmp_default_aliquot_label = $default_aliquot_labels[$tmp_new_aliquots_set['parent']['ViewSample']['sample_master_id']];
				$label_counter = ($aliquot_control['AliquotControl']['aliquot_type'] == 'block')? 'a' : 1;
				foreach($tmp_new_aliquots_set['children'] as &$tmp_new_aliquot) {
					$tmp_new_aliquot['AliquotMaster']['aliquot_label'] = $tmp_default_aliquot_label.$label_counter;
					$label_counter++;
				}
			}
		}
	}
