<?php

	// --------------------------------------------------------------------------------
	// Set default aliquot label(s)
	// --------------------------------------------------------------------------------
	if(isset($default_aliquot_labels)){
		foreach($this->request->data as &$tmp_new_aliquots_set) {
			if(isset($default_aliquot_labels[$tmp_new_aliquots_set['parent']['ViewSample']['sample_master_id']]) && $default_aliquot_labels[$tmp_new_aliquots_set['parent']['ViewSample']['sample_master_id']] != 'n/a') {
				$tmp_default_aliquot_label = $default_aliquot_labels[$tmp_new_aliquots_set['parent']['ViewSample']['sample_master_id']];
				$label_counter = 0;
				foreach($tmp_new_aliquots_set['children'] as &$tmp_new_aliquot) {
					$label_counter++;
					$tmp_new_aliquot['AliquotMaster']['aliquot_label'] = $tmp_default_aliquot_label."-$label_counter";
				}
			}
		}
	}
