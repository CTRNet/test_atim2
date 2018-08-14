<?php

// # 1 # ATiM Processing Site Data Check
// ===================================================
// Sample created by system to migrate aliquot from ATiM-Processing site can be used as parent sample when at least one aliquot exists for this sample into the ATiM
// used (this one is the aliquot previously transferred from bank different than PS3 to 'Processing Site' and now merged into the ATiM of PS3).
if ($parentSampleData && $parentSampleData['SampleMaster']['procure_created_by_bank'] == 's') {
    $tmpAliquotsCount = $this->AliquotMaster->find('count', array(
        'conditions' => array(
            'AliquotMaster.sample_master_id' => $parentSampleData['SampleMaster']['id']
        )
    ));
    if (! $tmpAliquotsCount) {
        $this->atimFlashError(__('no derivative can be created from sample created by system/script to migrate data from the processing site with no aliquot'), "javascript:history.back();", 5);
        return;
    }
}

// # 2 # Default Values
// ===================================================

// --------------------------------------------------------------------------------
// BLOOD
// --------------------------------------------------------------------------------

if ($sampleControlData['SampleControl']['sample_type'] == 'blood') {
    $collectionBloodTypes = $this->SampleMaster->find('list', array(
        'conditions' => array(
            'SampleMaster.collection_id' => $collectionId,
            'SampleMaster.sample_control_id' => $sampleControlData['SampleControl']['id']
        ),
        'fields' => array(
            "SampleDetail.blood_type"
        ),
        'recursive' => 0
    ));
    $lastReceivedBloodSample = $this->SampleMaster->find('first', array(
        'conditions' => array(
            'SampleMaster.collection_id' => $collectionId,
            'SampleMaster.sample_control_id' => $sampleControlData['SampleControl']['id']
        ),
        'order' => array(
            'SpecimenDetail.reception_datetime DESC'
        ),
        'recursive' => 0
    ));
    if (! empty($lastReceivedBloodSample)) {
        // Collection blood sample already created
        if (! in_array('serum', $collectionBloodTypes)) {
            $this->request->data['SampleDetail']['blood_type'] = 'serum';
        } else 
            if (! in_array('paxgene', $collectionBloodTypes)) {
                $this->request->data['SampleDetail']['blood_type'] = 'paxgene';
            } else 
                if (! in_array('k2-EDTA', $collectionBloodTypes)) {
                    $this->request->data['SampleDetail']['blood_type'] = 'k2-EDTA';
                }
        
        $this->request->data['SpecimenDetail']['reception_datetime'] = $lastReceivedBloodSample['SpecimenDetail']['reception_datetime'];
        $this->request->data['SpecimenDetail']['reception_datetime_accuracy'] = $lastReceivedBloodSample['SpecimenDetail']['reception_datetime_accuracy'];
        
        $this->request->data['SampleDetail']['procure_collection_site'] = $lastReceivedBloodSample['SampleDetail']['procure_collection_site'];
    } else {
        // No collection blood sample already created
        $this->ViewCollection = AppModel::getInstance("InventoryManagement", "ViewCollection", true);
        $collection = $this->ViewCollection->find('first', array(
            'conditions' => array(
                'ViewCollection.collection_id' => $collectionId
            ),
            'recursive' => -1
        ));
        
        $this->request->data['SpecimenDetail']['reception_datetime'] = $collection['ViewCollection']['collection_datetime'];
        $this->request->data['SpecimenDetail']['reception_datetime_accuracy'] = ($collection['ViewCollection']['collection_datetime_accuracy'] == 'c') ? 'h' : $collection['ViewCollection']['collection_datetime_accuracy'];
        
        $this->request->data['SampleDetail']['procure_collection_site'] = 'clinic';
        
        $this->request->data['SampleDetail']['blood_type'] = 'serum';
    }
} else 
    if (in_array($sampleControlData['SampleControl']['sample_type'], array(
        'urine',
        'tissue'
    ))) {
        
        // --------------------------------------------------------------------------------
        // URINE
        // --------------------------------------------------------------------------------
        
        $this->ViewCollection = AppModel::getInstance("InventoryManagement", "ViewCollection", true);
        $collection = $this->ViewCollection->find('first', array(
            'conditions' => array(
                'ViewCollection.collection_id' => $collectionId
            ),
            'recursive' => -1
        ));
        
        switch ($sampleControlData['SampleControl']['sample_type']) {
            case 'urine':
                $this->request->data['SampleDetail']['collected_volume_unit'] = 'ml';
                $this->request->data['SampleDetail']['urine_aspect'] = 'clear';
                $this->request->data['SampleDetail']['procure_hematuria'] = 'n';
                $this->request->data['SampleDetail']['procure_collected_via_catheter'] = 'n';
                $this->request->data['SampleDetail']['collected_volume_unit'] = 'ml';
                break;
            case 'tissue':
                $participantIdentifier = empty($collection['ViewCollection']['participant_identifier']) ? '?' : $collection['ViewCollection']['participant_identifier'];
                $this->request->data['SampleDetail']['procure_tissue_identification'] = $participantIdentifier . ' ' . $collection['ViewCollection']['procure_visit'] . ' -PST1';
                break;
        }
        
        $this->request->data['SpecimenDetail']['reception_datetime'] = $collection['ViewCollection']['collection_datetime'];
        $this->request->data['SpecimenDetail']['reception_datetime_accuracy'] = ($collection['ViewCollection']['collection_datetime_accuracy'] == 'c') ? 'h' : $collection['ViewCollection']['collection_datetime_accuracy'];
    } else 
        if (in_array($sampleControlData['SampleControl']['sample_type'], array(
            'plasma',
            'serum',
            'pbmc',
            'buffy coat'
        ))) {
            
            // --------------------------------------------------------------------------------
            // SERUM, PLASMA, PBMC, Buffy coat
            // --------------------------------------------------------------------------------
            
            $procureSampleTypes = ($sampleControlData['SampleControl']['sample_type'] == 'serum') ? array(
                'serum'
            ) : array(
                'plasma',
                'buffy coat',
                'pbmc'
            );
            $sampleControlIds = $this->SampleControl->find('list', array(
                'conditions' => array(
                    'sample_type' => $procureSampleTypes
                )
            ));
            $collectionBloodDerivatives = $this->SampleMaster->find('first', array(
                'conditions' => array(
                    'SampleMaster.collection_id' => $collectionId,
                    'SampleMaster.sample_control_id' => $sampleControlIds
                ),
                'order' => array(
                    'DerivativeDetail.creation_datetime DESC'
                ),
                'recursive' => 0
            ));
            if ($collectionBloodDerivatives) {
                $this->request->data['DerivativeDetail']['creation_datetime'] = $collectionBloodDerivatives['DerivativeDetail']['creation_datetime'];
                $this->request->data['DerivativeDetail']['creation_datetime_accuracy'] = $collectionBloodDerivatives['DerivativeDetail']['creation_datetime_accuracy'];
            } else {
                $this->request->data['DerivativeDetail']['creation_datetime'] = $parentSampleData['SpecimenDetail']['reception_datetime'];
                $this->request->data['DerivativeDetail']['creation_datetime_accuracy'] = ($parentSampleData['SpecimenDetail']['reception_datetime_accuracy'] == 'c') ? 'h' : $parentSampleData['SpecimenDetail']['reception_datetime_accuracy'];
            }
        } else 
            if (in_array($sampleControlData['SampleControl']['sample_type'], array(
                'centrifuged urine'
            ))) {
                
                // --------------------------------------------------------------------------------
                // CENT. URINE
                // --------------------------------------------------------------------------------
                
                $this->request->data['DerivativeDetail']['creation_datetime'] = $parentSampleData['SpecimenDetail']['reception_datetime'];
                $this->request->data['DerivativeDetail']['creation_datetime_accuracy'] = ($parentSampleData['SpecimenDetail']['reception_datetime_accuracy'] == 'c') ? 'h' : $parentSampleData['SpecimenDetail']['reception_datetime_accuracy'];
                $this->request->data['DerivativeDetail']['procure_pellet_volume_ml'] = '50';
            }