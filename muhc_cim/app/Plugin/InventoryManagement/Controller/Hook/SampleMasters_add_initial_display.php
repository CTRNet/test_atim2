<?php
/** **********************************************************************
 * CUSM-CIM Project.
 * ***********************************************************************
 *
 * InventoryManagement plugin custom code
 *
 * @author N. Luc - CTRNet (nicolas.luc@gmail.com)
 * @since 2018-02-21
 */

// Set sample default values

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
        'recursive' => '0'
    ));
    $lastReceivedBloodSample = $this->SampleMaster->find('first', array(
        'conditions' => array(
            'SampleMaster.collection_id' => $collectionId,
            'SampleMaster.sample_control_id' => $sampleControlData['SampleControl']['id']
        ),
        'order' => array(
            'SpecimenDetail.reception_datetime DESC'
        ),
        'recursive' => '0'
    ));
    if (! empty($lastReceivedBloodSample)) {
        // Collection blood sample already created
        if (! in_array('EDTA', $collectionBloodTypes)) {
            $this->request->data['SampleDetail']['blood_type'] = 'EDTA';
        } else 
            if (! in_array('paxgene', $collectionBloodTypes)) {
                $this->request->data['SampleDetail']['blood_type'] = 'paxgene';
            } else {
                $this->request->data['SampleDetail']['blood_type'] = 'no additif';
            }
        
        $this->request->data['SampleMaster']['cusm_cim_material_id_1'] = $lastReceivedBloodSample['SampleMaster']['cusm_cim_material_id_1'];
        
        $this->request->data['SpecimenDetail']['reception_datetime'] = $lastReceivedBloodSample['SpecimenDetail']['reception_datetime'];
        $this->request->data['SpecimenDetail']['reception_datetime_accuracy'] = $lastReceivedBloodSample['SpecimenDetail']['reception_datetime_accuracy'];
        $this->request->data['SpecimenDetail']['supplier_dept'] = $lastReceivedBloodSample['SpecimenDetail']['supplier_dept'];
        $this->request->data['SpecimenDetail']['reception_by'] = $lastReceivedBloodSample['SpecimenDetail']['reception_by'];
        $this->request->data['SpecimenDetail']['time_at_room_temp_mn'] = $lastReceivedBloodSample['SpecimenDetail']['time_at_room_temp_mn'];
    } else {
        // No collection blood sample already created
        $this->ViewCollection = AppModel::getInstance("InventoryManagement", "ViewCollection", true);
        $collection = $this->ViewCollection->find('first', array(
            'conditions' => array(
                'ViewCollection.collection_id' => $collectionId
            ),
            'recursive' => '-1'
        ));
        
        $this->request->data['SpecimenDetail']['reception_datetime'] = $collection['ViewCollection']['collection_datetime'];
        $this->request->data['SpecimenDetail']['reception_datetime_accuracy'] = ($collection['ViewCollection']['collection_datetime_accuracy'] == 'c') ? 'h' : $collection['ViewCollection']['collection_datetime_accuracy'];
        
        $this->request->data['SampleDetail']['blood_type'] = 'EDTA';
    }
} elseif (in_array($sampleControlData['SampleControl']['sample_type'], array('plasma','serum','pbmc','buffy coat'))) {
    
    // --------------------------------------------------------------------------------
    // SERUM, PLASMA, PBMC, Buffy coat
    // --------------------------------------------------------------------------------
    
    $procureSampleTypes = array('plasma','serum','pbmc','buffy coat');
    $sampleControlIds = $this->SampleControl->find('list', array(
        'conditions' => array(
            'sample_type' => $procureSampleTypes
        )
    ));
    $collectionBoodDerivatives = $this->SampleMaster->find('first', array(
        'conditions' => array(
            'SampleMaster.collection_id' => $collectionId,
            'SampleMaster.sample_control_id' => $sampleControlIds
        ),
        'order' => array(
            'DerivativeDetail.creation_datetime DESC'
        ),
        'recursive' => '0'
    ));
    
    if ($collectionBoodDerivatives) {
        $this->request->data['SampleMaster']['cusm_cim_material_id_1'] = $collectionBoodDerivatives['SampleMaster']['cusm_cim_material_id_1'];
        $this->request->data['SampleMaster']['cusm_cim_material_id_2'] = $collectionBoodDerivatives['SampleMaster']['cusm_cim_material_id_2'];
        $this->request->data['SampleMaster']['cusm_cim_material_id_3'] = $collectionBoodDerivatives['SampleMaster']['cusm_cim_material_id_3'];
        $this->request->data['SampleMaster']['cusm_cim_material_id_4'] = $collectionBoodDerivatives['SampleMaster']['cusm_cim_material_id_4'];
        $this->request->data['SampleMaster']['cusm_cim_material_id_5'] = $collectionBoodDerivatives['SampleMaster']['cusm_cim_material_id_5'];
        $this->request->data['SampleMaster']['cusm_cim_centrifuge_duration_mn'] = $collectionBoodDerivatives['SampleMaster']['cusm_cim_centrifuge_duration_mn'];
        $this->request->data['SampleMaster']['cusm_cim_centrifuge_speed'] = $collectionBoodDerivatives['SampleMaster']['cusm_cim_centrifuge_speed'];
        $this->request->data['SampleMaster']['cusm_cim_centrifuge_speed_unit'] = $collectionBoodDerivatives['SampleMaster']['cusm_cim_centrifuge_speed_unit'];
        $this->request->data['DerivativeDetail']['creation_datetime'] = $collectionBoodDerivatives['DerivativeDetail']['creation_datetime'];
        $this->request->data['DerivativeDetail']['creation_datetime_accuracy'] = $collectionBoodDerivatives['DerivativeDetail']['creation_datetime_accuracy'];
        $this->request->data['DerivativeDetail']['creation_site'] = $collectionBoodDerivatives['DerivativeDetail']['creation_site'];
        $this->request->data['DerivativeDetail']['creation_by'] = $collectionBoodDerivatives['DerivativeDetail']['creation_by'];
    } else {
        $this->request->data['DerivativeDetail']['creation_datetime'] = $parentSampleData['SpecimenDetail']['reception_datetime'];
        $this->request->data['DerivativeDetail']['creation_datetime_accuracy'] = ($parentSampleData['SpecimenDetail']['reception_datetime_accuracy'] == 'c') ? 'h' : $parentSampleData['SpecimenDetail']['reception_datetime_accuracy'];
        $this->request->data['DerivativeDetail']['creation_by'] = $parentSampleData['SpecimenDetail']['reception_by'];
    }
}
