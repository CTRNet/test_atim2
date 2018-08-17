<?php
$qcHbSampleCode = null;
if ($sampleControlData['SampleControl']['sample_type'] == 'blood') {
    
    // ** BLOOD **
    
    // Set default blood data based on last created blood
    $dataToDuplicate = $this->SampleMaster->find('first', array(
        'conditions' => array(
            'SampleMaster.collection_id' => $collectionId,
            'SampleMaster.sample_control_id' => $sampleControlData['SampleControl']['id']
        ),
        'order' => array(
            'SampleMaster.created DESC'
        ),
        'recursive' => 0
    ));
    
    if (empty($dataToDuplicate)) {
        // No existing blood... find tissue
        $dataToDuplicate = $this->SampleMaster->find('first', array(
            'conditions' => array(
                'SampleMaster.collection_id' => $collectionId,
                'SampleControl.sample_type' => 'tissue'
            ),
            'order' => array(
                'SampleMaster.created DESC'
            ),
            'recursive' => 0
        ));
    }
    
    $qcHbSampleCode = 'S';
} elseif ($sampleControlData['SampleControl']['sample_type'] == 'tissue') {
    
    // ** TISSUE **
    
    // Set default tissue data on last created tissue
    $dataToDuplicate = $this->SampleMaster->find('first', array(
        'conditions' => array(
            'SampleMaster.collection_id' => $collectionId,
            'SampleMaster.sample_control_id' => $sampleControlData['SampleControl']['id']
        ),
        'order' => array(
            'SampleMaster.created DESC'
        ),
        'recursive' => 0
    ));
    
    if (empty($dataToDuplicate)) {
        // No existing tissue... find blood
        $dataToDuplicate = $this->SampleMaster->find('first', array(
            'conditions' => array(
                'SampleMaster.collection_id' => $collectionId,
                'SampleControl.sample_type' => 'blood'
            ),
            'order' => array(
                'SampleMaster.created DESC'
            ),
            'recursive' => 0
        ));
    }
    
    $qcHbSampleCode = 'T';
    if (! empty($dataToDuplicate)) {
        if (array_key_exists('tissue_source', $dataToDuplicate['SampleDetail'])) {
            // Default existing sample was a tissue
            $qcHbSampleCode = ($dataToDuplicate['SpecimenDetail']['qc_hb_sample_code'] == 'T') ? 'N' : 'T';
        }
    }
}
$this->set('qcHbSampleCode', $qcHbSampleCode);
