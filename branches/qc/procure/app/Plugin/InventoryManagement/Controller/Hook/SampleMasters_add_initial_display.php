<?php

// # 1 # ATiM Processing Site Data Check
// ===================================================
// Sample created by system to migrate aliquot from ATiM-Processing site can be used as parent sample when at least one aliquot exists for this sample into the ATiM
// used (this one is the aliquot previously transferred from bank different than PS3 to 'Processing Site' and now merged into the ATiM of PS3).
if ($parent_sample_data && $parent_sample_data['SampleMaster']['procure_created_by_bank'] == 's') {
    $tmp_aliquots_count = $this->AliquotMaster->find('count', array(
        'conditions' => array(
            'AliquotMaster.sample_master_id' => $parent_sample_data['SampleMaster']['id']
        )
    ));
    if (! $tmp_aliquots_count) {
        $this->flash(__('no derivative can be created from sample created by system/script to migrate data from the processing site with no aliquot'), "javascript:history.back();", 5);
        return;
    }
}

// # 2 # Default Values
// ===================================================

// --------------------------------------------------------------------------------
// BLOOD
// --------------------------------------------------------------------------------

if ($sample_control_data['SampleControl']['sample_type'] == 'blood') {
    $collection_blood_types = $this->SampleMaster->find('list', array(
        'conditions' => array(
            'SampleMaster.collection_id' => $collection_id,
            'SampleMaster.sample_control_id' => $sample_control_data['SampleControl']['id']
        ),
        'fields' => array(
            "SampleDetail.blood_type"
        ),
        'recursive' => '0'
    ));
    $last_received_blood_sample = $this->SampleMaster->find('first', array(
        'conditions' => array(
            'SampleMaster.collection_id' => $collection_id,
            'SampleMaster.sample_control_id' => $sample_control_data['SampleControl']['id']
        ),
        'order' => array(
            'SpecimenDetail.reception_datetime DESC'
        ),
        'recursive' => '0'
    ));
    if (! empty($last_received_blood_sample)) {
        // Collection blood sample already created
        if (! in_array('serum', $collection_blood_types)) {
            $this->request->data['SampleDetail']['blood_type'] = 'serum';
        } else 
            if (! in_array('paxgene', $collection_blood_types)) {
                $this->request->data['SampleDetail']['blood_type'] = 'paxgene';
            } else 
                if (! in_array('k2-EDTA', $collection_blood_types)) {
                    $this->request->data['SampleDetail']['blood_type'] = 'k2-EDTA';
                }
        
        $this->request->data['SpecimenDetail']['reception_datetime'] = $last_received_blood_sample['SpecimenDetail']['reception_datetime'];
        $this->request->data['SpecimenDetail']['reception_datetime_accuracy'] = $last_received_blood_sample['SpecimenDetail']['reception_datetime_accuracy'];
        
        $this->request->data['SampleDetail']['procure_collection_site'] = $last_received_blood_sample['SampleDetail']['procure_collection_site'];
    } else {
        // No collection blood sample already created
        $this->ViewCollection = AppModel::getInstance("InventoryManagement", "ViewCollection", true);
        $collection = $this->ViewCollection->find('first', array(
            'conditions' => array(
                'ViewCollection.collection_id' => $collection_id
            ),
            'recursive' => '-1'
        ));
        
        $this->request->data['SpecimenDetail']['reception_datetime'] = $collection['ViewCollection']['collection_datetime'];
        $this->request->data['SpecimenDetail']['reception_datetime_accuracy'] = ($collection['ViewCollection']['collection_datetime_accuracy'] == 'c') ? 'h' : $collection['ViewCollection']['collection_datetime_accuracy'];
        
        $this->request->data['SampleDetail']['procure_collection_site'] = 'clinic';
        
        $this->request->data['SampleDetail']['blood_type'] = 'serum';
    }
} else 
    if (in_array($sample_control_data['SampleControl']['sample_type'], array(
        'urine',
        'tissue'
    ))) {
        
        // --------------------------------------------------------------------------------
        // URINE
        // --------------------------------------------------------------------------------
        
        $this->ViewCollection = AppModel::getInstance("InventoryManagement", "ViewCollection", true);
        $collection = $this->ViewCollection->find('first', array(
            'conditions' => array(
                'ViewCollection.collection_id' => $collection_id
            ),
            'recursive' => '-1'
        ));
        
        switch ($sample_control_data['SampleControl']['sample_type']) {
            case 'urine':
                $this->request->data['SampleDetail']['collected_volume_unit'] = 'ml';
                $this->request->data['SampleDetail']['urine_aspect'] = 'clear';
                $this->request->data['SampleDetail']['procure_hematuria'] = 'n';
                $this->request->data['SampleDetail']['procure_collected_via_catheter'] = 'n';
                $this->request->data['SampleDetail']['collected_volume_unit'] = 'ml';
                break;
            case 'tissue':
                $participant_identifier = empty($collection['ViewCollection']['participant_identifier']) ? '?' : $collection['ViewCollection']['participant_identifier'];
                $this->request->data['SampleDetail']['procure_tissue_identification'] = $participant_identifier . ' ' . $collection['ViewCollection']['procure_visit'] . ' -PST1';
                break;
        }
        
        $this->request->data['SpecimenDetail']['reception_datetime'] = $collection['ViewCollection']['collection_datetime'];
        $this->request->data['SpecimenDetail']['reception_datetime_accuracy'] = ($collection['ViewCollection']['collection_datetime_accuracy'] == 'c') ? 'h' : $collection['ViewCollection']['collection_datetime_accuracy'];
    } else 
        if (in_array($sample_control_data['SampleControl']['sample_type'], array(
            'plasma',
            'serum',
            'pbmc',
            'buffy coat'
        ))) {
            
            // --------------------------------------------------------------------------------
            // SERUM, PLASMA, PBMC, Buffy coat
            // --------------------------------------------------------------------------------
            
            $procure_sample_types = ($sample_control_data['SampleControl']['sample_type'] == 'serum') ? array(
                'serum'
            ) : array(
                'plasma',
                'buffy coat',
                'pbmc'
            );
            $sample_control_ids = $this->SampleControl->find('list', array(
                'conditions' => array(
                    'sample_type' => $procure_sample_types
                )
            ));
            $collection_blood_derivatives = $this->SampleMaster->find('first', array(
                'conditions' => array(
                    'SampleMaster.collection_id' => $collection_id,
                    'SampleMaster.sample_control_id' => $sample_control_ids
                ),
                'order' => array(
                    'DerivativeDetail.creation_datetime DESC'
                ),
                'recursive' => '0'
            ));
            if ($collection_blood_derivatives) {
                $this->request->data['DerivativeDetail']['creation_datetime'] = $collection_blood_derivatives['DerivativeDetail']['creation_datetime'];
                $this->request->data['DerivativeDetail']['creation_datetime_accuracy'] = $collection_blood_derivatives['DerivativeDetail']['creation_datetime_accuracy'];
            } else {
                $this->request->data['DerivativeDetail']['creation_datetime'] = $parent_sample_data['SpecimenDetail']['reception_datetime'];
                $this->request->data['DerivativeDetail']['creation_datetime_accuracy'] = ($parent_sample_data['SpecimenDetail']['reception_datetime_accuracy'] == 'c') ? 'h' : $parent_sample_data['SpecimenDetail']['reception_datetime_accuracy'];
            }
        } else 
            if (in_array($sample_control_data['SampleControl']['sample_type'], array(
                'centrifuged urine'
            ))) {
                
                // --------------------------------------------------------------------------------
                // CENT. URINE
                // --------------------------------------------------------------------------------
                
                $this->request->data['DerivativeDetail']['creation_datetime'] = $parent_sample_data['SpecimenDetail']['reception_datetime'];
                $this->request->data['DerivativeDetail']['creation_datetime_accuracy'] = ($parent_sample_data['SpecimenDetail']['reception_datetime_accuracy'] == 'c') ? 'h' : $parent_sample_data['SpecimenDetail']['reception_datetime_accuracy'];
                $this->request->data['DerivativeDetail']['procure_pellet_volume_ml'] = '50';
            }

?>