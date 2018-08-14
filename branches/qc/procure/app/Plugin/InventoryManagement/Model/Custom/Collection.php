<?php

class CollectionCustom extends Collection
{

    var $useTable = 'collections';

    var $name = 'Collection';

    public function allowLinkDeletion($collectionId)
    {
        $res = parent::allowLinkDeletion($collectionId);
        if ($res['allow_deletion'] == false)
            return $res;
            
            // Check no aliquot linked to the collection
        $aliquotModel = AppModel::getInstance("InventoryManagement", "AliquotMaster", true);
        $collectionAliquotsCount = $aliquotModel->find('count', array(
            'conditions' => array(
                'AliquotMaster.collection_id' => $collectionId
            ),
            'recursive' => -1
        ));
        if ($collectionAliquotsCount) {
            return array(
                'allow_deletion' => false,
                'msg' => 'the link cannot be deleted - collection contains at least one aliquot'
            );
        }
        
        $res = parent::allowLinkDeletion($collectionId);
        if ($res['allow_deletion'] == false)
            return $res;
            
            // Check no aliquot linked to the collection
        $sampleModel = AppModel::getInstance("InventoryManagement", "SampleMaster", true);
        $collectionSamplesCount = $sampleModel->find('count', array(
            'conditions' => array(
                'SampleMaster.collection_id' => $collectionId
            ),
            'recursive' => -1
        ));
        if ($collectionSamplesCount) {
            return array(
                'allow_deletion' => false,
                'msg' => 'the link cannot be deleted - collection contains at least one sample'
            );
        }
        
        return array(
            'allow_deletion' => true,
            'msg' => ''
        );
    }

    public function validates($options = array())
    {
        $res = parent::validates($options);
        if (isset($this->data['Collection']) && isset($this->data['Collection']['procure_visit'])) {
            $procureVisit = trim($this->data['Collection']['procure_visit']);
            if (preg_match('/^[Vv]{0,1}((0{0,1}[1-9])|([1-9][0-9]))([\.,]([1-9])){0,1}$/', $procureVisit, $matches)) {
                $this->data['Collection']['procure_visit'] = 'V' . sprintf("%02s", $matches[1]) . ((isset($matches[5]) && $matches[5]) ? '.' . $matches[5] : '');
            } else {
                $res = false;
                $this->validationErrors['procure_visit'][] = __('wrong procure collection visit format');
            }
        }
        return $res;
    }

    public function allowDeletion($collectionId)
    {
        if ($this->data['Collection']['procure_visit'] == 'Controls') {
            return array(
                'allow_deletion' => false,
                'msg' => 'control collection - collection can not be deleted'
            );
        }
        return parent::allowDeletion($collectionId);
    }
}