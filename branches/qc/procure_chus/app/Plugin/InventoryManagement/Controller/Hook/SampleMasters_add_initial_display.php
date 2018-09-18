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
        $this->atimFlashError(__('no derivative can be created from sample created by system/script to migrate data from the processing site with no aliquot'), "javascript:history.back();");
        return;
    }
}

// # 2 # Default Values
// ===================================================

$defaultStructureOverride = array();

if ($sampleControlData['SampleControl']['sample_type'] == 'tissue') {
    $this->ViewCollection = AppModel::getInstance("InventoryManagement", "ViewCollection", true);
    $collection = $this->ViewCollection->find('first', array(
        'conditions' => array(
            'ViewCollection.collection_id' => $collectionId
        ),
        'recursive' => - 1
    ));
    $participantIdentifier = empty($collection['ViewCollection']['participant_identifier']) ? '?' : $collection['ViewCollection']['participant_identifier'];
    $defaultStructureOverride['SampleDetail.procure_tissue_identification'] = $participantIdentifier . ' ' . $collection['ViewCollection']['procure_visit'] . ' -PST1';
}

if ($sampleControlData['SampleControl']['sample_type'] == 'serum') {
    if (isset(AppController::getInstance()->passedArgs['templateInitId'])) {
        $templateInitDefaultValues = Set::flatten(AppController::getInstance()->Session->read('Template.init_data.' . AppController::getInstance()->passedArgs['templateInitId']));
        $tmpDateTimeArray = array();
        foreach (array ('year', 'month', 'day', 'hour', 'min') as $key) {
            if(isset($templateInitDefaultValues['0.procure_serum_creation_datetime.' . $key])) {
                $tmpDateTimeArray[$key] = $templateInitDefaultValues['0.procure_serum_creation_datetime.' . $key];
                $isDateTimeArrayEmpty = false;
            }
        }
        if(!$isDateTimeArrayEmpty) {
            $this->request->data['DerivativeDetail']['creation_datetime'] = $tmpDateTimeArray;
        }
    }
}

$this->set('defaultStructureOverride', $defaultStructureOverride);