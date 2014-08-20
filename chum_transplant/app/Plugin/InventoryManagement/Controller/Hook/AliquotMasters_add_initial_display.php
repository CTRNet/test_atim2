<?php

// --------------------------------------------------------------------------------
// Set default aliquot label(s)
// --------------------------------------------------------------------------------

foreach($this->request->data as $sample_key => $studied_sample) {
	$studied_sample_master_id = $studied_sample['parent']['ViewSample']['sample_master_id'];
	if(isset($default_aliquot_labels) && isset($default_aliquot_labels[$studied_sample_master_id]) && isset($studied_sample['children'])) {
		$created_aliquots_nbr = sizeof($studied_sample['children']);
		$tmp_aliquot_counter = 0;
		foreach($studied_sample['children'] as $aliquot_key => $studied_aliquot_data) {
			$tmp_aliquot_counter++;
			$updated_label = str_replace('?:?', "$tmp_aliquot_counter:$created_aliquots_nbr", $default_aliquot_labels[$studied_sample_master_id]);
			$this->request->data[$sample_key]['children'][$aliquot_key]['AliquotMaster']['aliquot_label'] = $updated_label;
		}
	}
}


