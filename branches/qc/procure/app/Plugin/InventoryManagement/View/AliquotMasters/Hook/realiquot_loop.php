<?php
if (isset($procureDefaultAliquotData[$parent['AliquotMaster']['sample_master_id']])) {
    foreach ($procureDefaultAliquotData[$parent['AliquotMaster']['sample_master_id']] as $modeField => $procureValue) {
        $finalOptionsChildren['override'][$modeField] = $procureValue;
    }
}