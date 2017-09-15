<?php
if ($sampleControlData['SampleControl']['sample_category'] == 'specimen' && ! empty($collectionData['Collection']['collection_datetime'])) {
    $this->request->data['SpecimenDetail']['reception_datetime'] = $collectionData['Collection']['collection_datetime'];
    $this->request->data['SpecimenDetail']['reception_datetime_accuracy'] = in_array($collectionData['Collection']['collection_datetime_accuracy'], array(
        'i',
        'c'
    )) ? 'h' : $collectionData['Collection']['collection_datetime_accuracy'];
}

// TODO: To un-comment if user requests this specific change
// $tmpSessionData = $this->passedArgs;
// $tmpTemplateSessionData = isset($tmpSessionData['templateInitId'])? $this->Session->read('Template.init_data.'.$tmpSessionData['templateInitId']) : array();
// $qcLadyisBloodMetaTemplate = (isset($tmpTemplateSessionData['FunctionManagement']['qc_ladyis_blood_meta_template']) && $tmpTemplateSessionData['FunctionManagement']['qc_ladyis_blood_meta_template'])? true : false;

// *********** BLOOD ***********

if ($sampleControlData['SampleControl']['sample_type'] == 'blood') {
    $this->request->data['SampleDetail']['collected_volume_unit'] = 'ml';
    
    $this->request->data['SampleMaster']['sop_master_id'] = $collectionData['Collection']['sop_master_id'];
    $this->request->data['SampleMaster']['qc_lady_sop_followed'] = $collectionData['Collection']['qc_lady_sop_followed'];
    $this->request->data['SampleMaster']['qc_lady_sop_deviations'] = $collectionData['Collection']['qc_lady_sop_deviations'];
    
    // if($qcLadyisBloodMetaTemplate) {
    $existingCollectionBloods = $this->SampleMaster->find('all', array(
        'conditions' => array(
            'SampleMaster.collection_id' => $collectionId,
            'SampleControl.sample_type' => 'blood'
        ),
        'order' => 'SampleMaster.id DESC',
        'recursive' => 0
    ));
    switch (sizeof($existingCollectionBloods)) {
        case '0':
            $this->request->data['SampleDetail']['blood_type'] = 'EDTA';
            $this->request->data['SpecimenDetail']['reception_by'] = 'Urszula Krzemien';
            $this->request->data['SpecimenDetail']['reception_datetime'] = $collectionData['Collection']['collection_datetime'];
            $this->request->data['SpecimenDetail']['reception_datetime_accuracy'] = $collectionData['Collection']['collection_datetime_accuracy'];
            $this->request->data['SampleDetail']['collected_tube_nbr'] = '3';
            break;
        
        case '1':
            $this->request->data['SampleDetail']['blood_type'] = 'CTAD';
            $this->request->data['SpecimenDetail']['supplier_dept'] = $existingCollectionBloods[0]['SpecimenDetail']['supplier_dept'];
            $this->request->data['SpecimenDetail']['reception_by'] = $existingCollectionBloods[0]['SpecimenDetail']['reception_by'];
            $this->request->data['SpecimenDetail']['reception_datetime'] = $existingCollectionBloods[0]['SpecimenDetail']['reception_datetime'];
            $this->request->data['SpecimenDetail']['reception_datetime_accuracy'] = $existingCollectionBloods[0]['SpecimenDetail']['reception_datetime_accuracy'];
            $this->request->data['SampleMaster']['sop_master_id'] = $existingCollectionBloods[0]['SampleMaster']['sop_master_id'];
            $this->request->data['SampleMaster']['qc_lady_sop_followed'] = $existingCollectionBloods[0]['SampleMaster']['qc_lady_sop_followed'];
            $this->request->data['SampleMaster']['qc_lady_sop_deviations'] = $existingCollectionBloods[0]['SampleMaster']['qc_lady_sop_deviations'];
            $this->request->data['SampleDetail']['collected_tube_nbr'] = '1';
            break;
        
        case '2':
            $this->request->data['SampleDetail']['blood_type'] = 'serum';
            $this->request->data['SpecimenDetail']['supplier_dept'] = $existingCollectionBloods[0]['SpecimenDetail']['supplier_dept'];
            $this->request->data['SpecimenDetail']['reception_by'] = $existingCollectionBloods[0]['SpecimenDetail']['reception_by'];
            $this->request->data['SpecimenDetail']['reception_datetime'] = $existingCollectionBloods[0]['SpecimenDetail']['reception_datetime'];
            $this->request->data['SpecimenDetail']['reception_datetime_accuracy'] = $existingCollectionBloods[0]['SpecimenDetail']['reception_datetime_accuracy'];
            $this->request->data['SampleMaster']['sop_master_id'] = $existingCollectionBloods[0]['SampleMaster']['sop_master_id'];
            $this->request->data['SampleMaster']['qc_lady_sop_followed'] = $existingCollectionBloods[0]['SampleMaster']['qc_lady_sop_followed'];
            $this->request->data['SampleMaster']['qc_lady_sop_deviations'] = $existingCollectionBloods[0]['SampleMaster']['qc_lady_sop_deviations'];
            $this->request->data['SampleDetail']['collected_tube_nbr'] = '1';
            break;
        
        default:
    }
    // }
    
    // *********** PBMC, SERUM, PLASMA ***********
} else 
    if (in_array($sampleControlData['SampleControl']['sample_type'], array(
        'pbmc',
        'serum',
        'plasma'
    ))) {
        $existingBloodDerivative = $this->SampleMaster->find('first', array(
            'conditions' => array(
                'SampleMaster.collection_id' => $collectionId,
                'SampleControl.sample_type' => array(
                    'pbmc',
                    'serum',
                    'plasma'
                )
            ),
            'order' => 'SampleMaster.id DESC',
            'recursive' => 0
        ));
        if ($existingBloodDerivative) {
            $this->request->data['DerivativeDetail']['creation_by'] = $existingBloodDerivative['DerivativeDetail']['creation_by'];
            $this->request->data['DerivativeDetail']['creation_datetime'] = $existingBloodDerivative['DerivativeDetail']['creation_datetime'];
            $this->request->data['DerivativeDetail']['creation_datetime_accuracy'] = $existingBloodDerivative['DerivativeDetail']['creation_datetime_accuracy'];
        } else {
            $this->request->data['DerivativeDetail']['creation_by'] = $parentSampleData['SpecimenDetail']['reception_by'];
            $this->request->data['DerivativeDetail']['creation_datetime'] = $parentSampleData['SpecimenDetail']['reception_datetime'];
            $this->request->data['DerivativeDetail']['creation_datetime_accuracy'] = $parentSampleData['SpecimenDetail']['reception_datetime_accuracy'];
        }
    }