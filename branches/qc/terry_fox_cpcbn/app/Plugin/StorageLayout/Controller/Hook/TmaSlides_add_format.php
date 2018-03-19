<?php
if (! $initialDisplay) {
    foreach ($this->request->data as $tmpKeyBlockStorageMasterId => &$tmpDataUnit) {
        $lastBlockTmaSectionId = '';
        foreach ($tmpDataUnit as &$tmpData) {
            if (isset($tmpData['TmaSlide'])) {
                if (preg_match('/[0-9]+/', $tmpData['TmaSlide']['qc_tf_cpcbn_section_id'])) {
                    $lastBlockTmaSectionId = $tmpData['TmaSlide']['qc_tf_cpcbn_section_id'];
                } elseif ($tmpData['TmaSlide']['qc_tf_cpcbn_section_id'] == '+' && preg_match('/[0-9]+/', $lastBlockTmaSectionId)) {
                    $lastBlockTmaSectionId ++;
                    $tmpData['TmaSlide']['qc_tf_cpcbn_section_id'] = $lastBlockTmaSectionId;
                } else {
                    $lastBlockTmaSectionId = '';
                }
            }
        }
    }
}