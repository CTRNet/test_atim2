<?php
if ($collectionData) {
    if ($collectionData['Collection']['collection_property'] != 'independent collection') {
        // Controls
        if ($this->request->data['SampleMaster']['qbcf_tma_sample_control_code']) {
            $this->SampleMaster->validationErrors['qbcf_tma_sample_control_code'][] = __('no control data has to be set for a participant tissue');
            $submittedDataValidates = false;
        }
        $controlDetailFields = array(
            'qbcf_control_er_overall',
            'qbcf_control_pr_overall',
            'qbcf_control_her_2_status',
            'qbcf_control_tnbc'
        );
        foreach ($controlDetailFields as $newCtrlField) {
            if ($this->request->data['SampleDetail'][$newCtrlField]) {
                $this->SampleMaster->validationErrors[$newCtrlField][] = __('no control data has to be set for a participant tissue');
                $submittedDataValidates = false;
            }
        }
    } else {
        // Tissue from banks
        $this->request->data['SampleMaster']['qbcf_is_tma_sample_control'] = 'y';
        $this->SampleMaster->addWritableField(array(
            'qbcf_is_tma_sample_control'
        ));
        if (! $this->request->data['SampleMaster']['qbcf_tma_sample_control_code']) {
            $this->SampleMaster->validationErrors['qbcf_tma_sample_control_code'][] = __('the code of a control is required');
            $submittedDataValidates = false;
        } else {
            $conditions = array(
                'SampleMaster.qbcf_tma_sample_control_code' => $this->request->data['SampleMaster']['qbcf_tma_sample_control_code'],
                'SampleDetail.tissue_source' => $this->request->data['SampleDetail']['tissue_source']
            );
            $joins = array(
                array(
                    'table' => 'sd_spe_tissues',
                    'alias' => 'SampleDetail',
                    'type' => 'INNER',
                    'conditions' => array(
                        'SampleDetail.sample_master_id = SampleMaster.id'
                    )
                )
            );
            if ($this->SampleMaster->find('count', array(
                'conditions' => $conditions,
                'joins' => $joins,
                'recursvie' => '-1'
            ))) {
                $this->SampleMaster->validationErrors['qbcf_tma_sample_control_code'][] = __('qbcf_tma_sample_control_code and tissue_source combination should be unique');
                $submittedDataValidates = false;
            }
        }
    }
} else {
    $this->redirect('/Pages/err_plugin_system_error?method=Collection.add(),line=' . __LINE__, null, true);
}