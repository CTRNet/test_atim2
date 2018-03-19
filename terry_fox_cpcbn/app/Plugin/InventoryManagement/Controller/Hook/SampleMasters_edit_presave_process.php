<?php
if ($sampleData['Collection']['collection_property'] != 'independent collection') {
    // Participant Tissue: Prostate tissue (not a control)
    if ($this->request->data['SampleDetail']['tissue_source'] != 'prostate') {
        $this->SampleMaster->validationErrors['tissue_source'][] = __('tissue source of a participant tissue should be a prostate');
        $submittedDataValidates = false;
    }
    if ($this->request->data['SampleMaster']['qc_tf_tma_sample_control_code']) {
        $this->SampleMaster->validationErrors['qc_tf_tma_sample_control_code'][] = __('no control data has to be set for a participant tissue');
        $submittedDataValidates = false;
    }
    if ($this->request->data['SampleMaster']['qc_tf_tma_sample_control_bank_id']) {
        $this->SampleMaster->validationErrors['qc_tf_tma_sample_control_bank_id'][] = __('no control data has to be set for a participant tissue');
        $submittedDataValidates = false;
    }
} else {
    if (! $this->request->data['SampleMaster']['qc_tf_tma_sample_control_code']) {
        $this->SampleMaster->validationErrors['qc_tf_tma_sample_control_code'][] = __('the code of a control is required');
        $submittedDataValidates = false;
    }
}