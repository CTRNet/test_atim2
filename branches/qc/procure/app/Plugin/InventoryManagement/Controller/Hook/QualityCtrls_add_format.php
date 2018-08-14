<?php

// ATiM Processing Site Data Check
// ===================================================
// A quality control can only be created for a sample created by system to migrate aliquot from ATiM-Processing site when at least one aliquot
// exists for this sample into the ATiM used (this one is the aliquot previously transferred from bank different than PS3 to 'Processing Site'
// and now merged into the ATiM of PS3).
if (isset($this->request->data[0]['parent']['AliquotMaster'])) {
    // All samples are linked to aliquot
} else {
    // Check
    $data_set_nbr_in_error = array();
    $tmp_record_counter = 0;
    foreach ($this->request->data as $tmp_procure_new_data_set) {
        $tmp_record_counter ++;
        if ($tmp_procure_new_data_set['parent']['ViewSample']['procure_created_by_bank'] == 's') {
            $tmp_aliquots_count = $this->AliquotMaster->find('count', array(
                'conditions' => array(
                    'AliquotMaster.sample_master_id' => $tmp_procure_new_data_set['parent']['ViewSample']['sample_master_id']
                )
            ));
            if (! $tmp_aliquots_count) {
                $data_set_nbr_in_error[] = $tmp_record_counter;
            }
        }
    }
    if ($data_set_nbr_in_error) {
        $this->flash(__('no quality control can be created from sample created by system/script to migrate data from the processing site with no aliquot') . ' ' . str_replace('%s', '[' . implode('] ,[', $data_set_nbr_in_error) . ']', __('see # %s')), $cancel_button, 5);
        return;
    }
}
	
