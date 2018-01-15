<?php

// --------------------------------------------------------------------------------
// Update Derivatives Sample Labels of an updated Specimen
// --------------------------------------------------------------------------------
if ($isSpecimen && ($sampleData['SampleMaster']['qc_nd_sample_label'] != $this->data['SampleMaster']['qc_nd_sample_label'])) {
    $specimenSampleLabel = $this->data['SampleMaster']['qc_nd_sample_label'];
    
    // Get bank_participant_identifier
    $viewCollectionModel = AppModel::getInstance('InventoryManagement', 'ViewCollection', true);
    
    $viewCollection = $viewCollectionModel->find('first', array(
        'conditions' => array(
            'ViewCollection.collection_id' => $collectionId
        )
    ));
    if (empty($viewCollection)) {
        $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
    }
    
    $bankParticipantIdentifier = $viewCollection['ViewCollection']['identifier_value'];
    
    // Get specimen derivatives list
    $this->SampleMaster->unbindModel(array(
        'belongsTo' => array(
            'Collection'
        ),
        'hasOne' => array(
            'SpecimenDetail',
            'DerivativeDetail'
        ),
        'hasMany' => array(
            'AliquotMaster'
        )
    ));
    $specimenDerivativesList = $this->SampleMaster->find('all', array(
        'conditions' => array(
            'SampleMaster.initial_specimen_sample_id' => $sampleMasterId,
            'SampleControl.sample_category' => 'derivative'
        )
    ));
    
    // Update derivative samples label
    foreach ($specimenDerivativesList as $newDerivative) {
        $derivativeDataToSave = array();
        $derivativeDataToSave['SampleMaster']['qc_nd_sample_label'] = $this->SampleMaster->createSampleLabel($collectionId, $newDerivative, $bankParticipantIdentifier, $specimenSampleLabel);
        
        $this->SampleMaster->data = array();
        $this->SampleMaster->id = $newDerivative['SampleMaster']['id'];
        $this->SampleMaster->save($derivativeDataToSave, false);
    }
}