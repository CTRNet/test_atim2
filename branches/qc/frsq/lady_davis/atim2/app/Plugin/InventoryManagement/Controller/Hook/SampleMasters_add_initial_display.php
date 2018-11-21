<?php 

// *********** BLOOD ***********

if ($sampleControlData['SampleControl']['sample_type'] == 'blood') {
    $existingCollectionBloods = $this->SampleMaster->find('first', array(
        'conditions' => array(
            'SampleMaster.collection_id' => $collectionId,
            'SampleControl.sample_type' => 'blood'
        ),
        'order' => 'SampleMaster.id DESC',
        'recursive' => 0
    ));
    if($existingCollectionBloods) {
        $this->request->data['SampleMaster']['qc_lady_sop_followed'] = $existingCollectionBloods['SampleMaster']['qc_lady_sop_followed'];
        $this->request->data['SampleMaster']['qc_lady_sop_deviations'] = $existingCollectionBloods['SampleMaster']['qc_lady_sop_deviations'];
    } else {
        $this->request->data['SampleMaster']['sop_master_id'] = $collectionData['Collection']['sop_master_id'];
        $this->request->data['SampleMaster']['qc_lady_sop_followed'] = $collectionData['Collection']['qc_lady_sop_followed'];
        $this->request->data['SampleMaster']['qc_lady_sop_deviations'] = $collectionData['Collection']['qc_lady_sop_deviations'];
    }
}