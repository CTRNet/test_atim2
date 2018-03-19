<?php
if ($collection_data) {
    if ($collection_data['Collection']['collection_property'] != 'independent collection') {
        // Participant Tissue: Prostate tissue (not a control)
        if ($this->request->data['SampleDetail']['tissue_source'] != 'prostate') {
            $this->SampleMaster->validationErrors['tissue_source'][] = __('tissue source of a participant tissue should be a prostate');
            $submitted_data_validates = false;
        }
        if ($this->request->data['SampleMaster']['qc_tf_tma_sample_control_code']) {
            $this->SampleMaster->validationErrors['qc_tf_tma_sample_control_code'][] = __('no control data has to be set for a participant tissue');
            $submitted_data_validates = false;
        }
        if ($this->request->data['SampleMaster']['qc_tf_tma_sample_control_bank_id']) {
            $this->SampleMaster->validationErrors['qc_tf_tma_sample_control_bank_id'][] = __('no control data has to be set for a participant tissue');
            $submitted_data_validates = false;
        }
    } else {
        $this->request->data['SampleMaster']['qc_tf_is_tma_sample_control'] = 'y';
        $this->SampleMaster->addWritableField(array(
            'qc_tf_is_tma_sample_control'
        ));
        if (! $this->request->data['SampleMaster']['qc_tf_tma_sample_control_code']) {
            $this->SampleMaster->validationErrors['qc_tf_tma_sample_control_code'][] = __('the code of a control is required');
            $submitted_data_validates = false;
        }
    }
} else {
    $this->redirect('/Pages/err_plugin_system_error?method=Collection.add(),line=' . __LINE__, null, true);
}

?>
