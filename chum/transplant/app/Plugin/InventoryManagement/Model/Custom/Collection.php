<?php

class CollectionCustom extends Collection
{

    var $name = "Collection";

    var $useTable = "collections";

    public function updateCollectionSampleLabels($collectionId, $bankParticipantIdentifier = null)
    {
        if (! isset($this->SampleMaster)) {
            $this->SampleMaster = AppModel::getInstance('InventoryManagement', 'SampleMaster');
        }
        
        if (! isset($this->ViewCollection)) {
            $this->ViewCollection = AppModel::getInstance('InventoryManagement', 'ViewCollection');
        }
        
        // Get bank_participant_identifier
        if (is_null($bankParticipantIdentifier)) {
            $collectionViewData = $this->ViewCollection->find('first', array(
                'conditions' => array(
                    'ViewCollection.collection_id' => $collectionId
                )
            ));
            if (empty($collectionViewData)) {
                return; // here via participant add collection
            }
            $bankParticipantIdentifier = $collectionViewData['ViewCollection']['identifier_value'];
        }
        
        // Get collection samples list
        $this->SampleMaster->unbindModel(array(
            'hasMany' => array(
                'AliquotMaster'
            ),
            'belongsTo' => array(
                'Collection'
            )
        ));
        $collectionSamplesList = $this->SampleMaster->find('all', array(
            'conditions' => array(
                'SampleMaster.collection_id' => $collectionId
            ),
            'order' => 'SampleMaster.initial_specimen_sample_id ASC, SampleControl.sample_category ASC'
        ));
        
        // Update collection samples label
        $specimensSampleLabelsFromId = array();
        foreach ($collectionSamplesList as $newCollectionSample) {
            $newSampleLabel = null;
            if ($newCollectionSample['SampleControl']['sample_category'] == 'specimen') {
                $newSampleLabel = $this->SampleMaster->createSampleLabel($collectionId, $newCollectionSample, $bankParticipantIdentifier);
                $specimensSampleLabelsFromId[$newCollectionSample['SampleMaster']['id']] = $newSampleLabel;
            } else {
                if (! isset($specimensSampleLabelsFromId[$newCollectionSample['SampleMaster']['initial_specimen_sample_id']])) {
                    pr($newCollectionSample);
                    pr($specimensSampleLabelsFromId);
                    exit();
                    AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                }
                $newSampleLabel = $this->SampleMaster->createSampleLabel($collectionId, $newCollectionSample, $bankParticipantIdentifier, $specimensSampleLabelsFromId[$newCollectionSample['SampleMaster']['initial_specimen_sample_id']]);
            }
            
            // Save new label
            $this->SampleMaster->id = $newCollectionSample['SampleMaster']['id'];
            $this->SampleMaster->addWritableField(array(
                'qc_nd_sample_label'
            ));
            if (! $this->SampleMaster->save(array(
                'SampleMaster' => array(
                    'qc_nd_sample_label' => $newSampleLabel
                )
            ), false)) {
                AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
            }
        }
    }
}