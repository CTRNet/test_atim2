<?php
if (isset($default_aliquot_labels)) {
    foreach ($this->request->data as &$new_sample_and_aliquots) {
        if ($new_sample_and_aliquots['parent']['ViewSample']['bank_id'] == 4) {
            $sample_master_id = $new_sample_and_aliquots['parent']['ViewSample']['sample_master_id'];
            if (array_key_exists($sample_master_id, $default_aliquot_labels)) {
                $counter = 0;
                foreach ($new_sample_and_aliquots['children'] as &$new_aliquot) {
                    $counter ++;
                    $new_aliquot['AliquotMaster']['aliquot_label'] = $default_aliquot_labels[$sample_master_id] . $counter;
                }
            }
        }
    }
}