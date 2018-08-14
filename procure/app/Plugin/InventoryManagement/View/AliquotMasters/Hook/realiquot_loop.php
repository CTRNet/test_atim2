<?php
if (isset($procure_default_aliquot_data[$parent['AliquotMaster']['sample_master_id']])) {
    foreach ($procure_default_aliquot_data[$parent['AliquotMaster']['sample_master_id']] as $mode_field => $procure_value) {
        $final_options_children['override'][$mode_field] = $procure_value;
    }
}

?>
