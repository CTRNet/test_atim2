<?php
if (! $sample_master_id) {
    $array_to_sort = array();
    foreach ($this->request->data as $tmp_new_sample)
        $array_to_sort[strtolower($tmp_new_sample['SampleMaster']['qc_tf_tma_sample_control_code'])][] = $tmp_new_sample;
    $this->request->data = array();
    ksort($array_to_sort);
    foreach ($array_to_sort as $tmp_new_sample_level_1) {
        foreach ($tmp_new_sample_level_1 as $tmp_new_sample_level_2) {
            $this->request->data[] = $tmp_new_sample_level_2;
        }
    }
}

?>
