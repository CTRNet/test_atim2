<?php
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
    
    $this->request->data['SpecimenDetail']['qc_hb_sample_code'] = 'S';
    $this->request->data['SpecimenDetail']['reception_by'] = 'louise rousseau';
    if (! empty($dataToDuplicate)) {
        $this->request->data['SampleMaster']['is_problematic'] = $dataToDuplicate['SampleMaster']['is_problematic'];
        $this->request->data['SampleMaster']['sop_master_id'] = $dataToDuplicate['SampleMaster']['sop_master_id'];
        $this->request->data['SpecimenDetail']['reception_by'] = $dataToDuplicate['SpecimenDetail']['reception_by'];
        $this->request->data['SpecimenDetail']['supplier_dept'] = $dataToDuplicate['SpecimenDetail']['supplier_dept'];
        $this->request->data['SpecimenDetail']['reception_datetime'] = $dataToDuplicate['SpecimenDetail']['reception_datetime'];
        $this->request->data['SpecimenDetail']['reception_datetime_accuracy'] = $dataToDuplicate['SpecimenDetail']['reception_datetime_accuracy'];
    }
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
    
    $this->request->data['SpecimenDetail']['supplier_dept'] = "pathology";
    $this->request->data['SpecimenDetail']['reception_by'] = 'louise rousseau';
    $this->request->data['SpecimenDetail']['qc_hb_sample_code'] = 'T';
    if (! empty($dataToDuplicate)) {
        $this->request->data['SampleMaster']['is_problematic'] = $dataToDuplicate['SampleMaster']['is_problematic'];
        $this->request->data['SampleMaster']['sop_master_id'] = $dataToDuplicate['SampleMaster']['sop_master_id'];
        $this->request->data['SpecimenDetail']['reception_by'] = $dataToDuplicate['SpecimenDetail']['reception_by'];
        $this->request->data['SpecimenDetail']['supplier_dept'] = $dataToDuplicate['SpecimenDetail']['supplier_dept'];
        $this->request->data['SpecimenDetail']['reception_datetime'] = $dataToDuplicate['SpecimenDetail']['reception_datetime'];
        $this->request->data['SpecimenDetail']['reception_datetime_accuracy'] = $dataToDuplicate['SpecimenDetail']['reception_datetime_accuracy'];
        if (array_key_exists('tissue_source', $dataToDuplicate['SampleDetail'])) {
            // Default existing sample was a tissue
            $this->request->data['SpecimenDetail']['qc_hb_sample_code'] = ($dataToDuplicate['SpecimenDetail']['qc_hb_sample_code'] == 'T') ? 'N' : 'T';
            $this->request->data['SampleDetail']['tissue_source'] = $dataToDuplicate['SampleDetail']['tissue_source'];
            $this->request->data['SampleDetail']['pathology_reception_datetime'] = $dataToDuplicate['SampleDetail']['pathology_reception_datetime'];
            $this->request->data['SampleDetail']['qc_hb_patho_report_no'] = $dataToDuplicate['SampleDetail']['qc_hb_patho_report_no'];
        }
    }
} elseif (in_array($sampleControlData['SampleControl']['sample_type'], array(
    'pbmc',
    'plasma',
    'serum'
))) {
    
    // ** PBMC, PLASMA, SERUM **
    
    // Set default blood derivative data based on last created blood derivative
    $dataToDuplicate = $this->SampleMaster->find('first', array(
        'conditions' => array(
            'SampleMaster.collection_id' => $collectionId,
            'SampleMaster.parent_id' => $parentSampleMasterId
        ),
        'order' => array(
            'SampleMaster.created DESC'
        ),
        'recursive' => 0
    ));
    
    if (empty($dataToDuplicate)) {
        // No existing derivative for the parent... find other collection blood derivative
        $dataToDuplicate = $this->SampleMaster->find('first', array(
            'conditions' => array(
                'SampleMaster.collection_id' => $collectionId,
                'SampleControl.sample_type' => array(
                    'pbmc',
                    'plasma',
                    'serum'
                )
            ),
            'order' => array(
                'SampleMaster.created DESC'
            ),
            'recursive' => 0
        ));
    }
    
    $this->request->data['DerivativeDetail']['creation_site'] = "cr. st-luc";
    $this->request->data['DerivativeDetail']['creation_by'] = 'louise rousseau';
    if (! empty($dataToDuplicate)) {
        $this->request->data['SampleMaster']['sop_master_id'] = $dataToDuplicate['SampleMaster']['sop_master_id'];
        $this->request->data['SampleMaster']['is_problematic'] = $dataToDuplicate['SampleMaster']['is_problematic'];
        $this->request->data['DerivativeDetail']['creation_site'] = $dataToDuplicate['DerivativeDetail']['creation_site'];
        $this->request->data['DerivativeDetail']['creation_by'] = $dataToDuplicate['DerivativeDetail']['creation_by'];
        $this->request->data['DerivativeDetail']['creation_datetime'] = $dataToDuplicate['DerivativeDetail']['creation_datetime'];
    }
} else {
    
    $this->request->data['DerivativeDetail']['creation_site'] = "cr. st-luc";
    $this->request->data['DerivativeDetail']['creation_by'] = 'louise rousseau';
    $this->request->data['SampleDetail']['qc_hb_macs_enzymatic_milieu'] = 'collagenase + dnase';
}