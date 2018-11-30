<?php
 /**
 *
 * ATiM - Advanced Tissue Management Application
 * Copyright (c) Canadian Tissue Repository Network (http://www.ctrnet.ca)
 *
 * Licensed under GNU General Public License
 * For full copyright and license information, please see the LICENSE.txt
 * Redistributions of files must retain the above copyright notice.
 *
 * @author        Canadian Tissue Repository Network <info@ctrnet.ca>
 * @copyright     Copyright (c) Canadian Tissue Repository Network (http://www.ctrnet.ca)
 * @link          http://www.ctrnet.ca
 * @since         ATiM v 2
 * @license       http://www.gnu.org/licenses  GNU General Public License
 */

/**
 * Class Collection
 */
class Collection extends InventoryManagementAppModel
{

    public $hasMany = array(
        'SampleMaster' => array(
            'className' => 'InventoryManagement.SampleMaster',
            'foreignKey' => 'collection_id'
        )
    );

    public $belongsTo = array(
        'Participant' => array(
            'className' => 'ClinicalAnnotation.Participant',
            'foreignKey' => 'participant_id'
        ),
        'DiagnosisMaster' => array(
            'className' => 'ClinicalAnnotation.DiagnosisMaster',
            'foreignKey' => 'diagnosis_master_id'
        ),
        'ConsentMaster' => array(
            'className' => 'ClinicalAnnotation.ConsentMaster',
            'foreignKey' => 'consent_master_id'
        ),
        'TreatmentMaster' => array(
            'className' => 'ClinicalAnnotation.TreatmentMaster',
            'foreignKey' => 'treatment_master_id'
        ),
        'EventMaster' => array(
            'className' => 'ClinicalAnnotation.EventMaster',
            'foreignKey' => 'event_master_id'
        )
    );

    public $browsingSearchDropdownInfo = array(
        'browsing_filter' => array(
            1 => array(
                'lang' => 'keep entries with the most recent date per participant',
                'group by' => 'participant_id',
                'field' => 'collection_datetime',
                'attribute' => 'MAX'
            ),
            2 => array(
                'lang' => 'keep entries with the oldest date per participant',
                'group by' => 'participant_id',
                'field' => 'collection_datetime',
                'attribute' => 'MIN'
            )
        ),
        'collection_datetime' => array(
            1 => array(
                'model' => 'TreatmentMaster',
                'field' => 'start_date',
                'relation' => '>='
            ),
            2 => array(
                'model' => 'TreatmentMaster',
                'field' => 'start_date',
                'relation' => '<='
            ),
            3 => array(
                'model' => 'TreatmentMaster',
                'field' => 'finish_date',
                'relation' => '>='
            ),
            4 => array(
                'model' => 'TreatmentMaster',
                'field' => 'finish_date',
                'relation' => '<='
            ),
            5 => array(
                'model' => 'EventMaster',
                'field' => 'event_date',
                'relation' => '>='
            ),
            6 => array(
                'model' => 'EventMaster',
                'field' => 'event_date',
                'relation' => '<='
            )
        )
    );

    public $registeredView = array(
        'InventoryManagement.ViewCollection' => array(
            'Collection.id'
        ),
        'InventoryManagement.ViewSample' => array(
            'Collection.id'
        ),
        'InventoryManagement.ViewAliquot' => array(
            'Collection.id'
        )
    );

    /**
     *
     * @param array $variables
     * @return bool
     */
    public function summary($variables = array())
    {
        $return = false;
        
        return $return;
    }

    /**
     *
     * @param array $collectionIds The collection ids whom child existence will be verified
     * @return array The collection ids having a child
     */
    public function hasChild(array $collectionIds)
    {
        $sampleMaster = AppModel::getInstance("InventoryManagement", "SampleMaster", true);
        return array_unique(array_filter($sampleMaster->find('list', array(
            'fields' => array(
                "SampleMaster.collection_id"
            ),
            'conditions' => array(
                'SampleMaster.collection_id' => $collectionIds,
                'SampleMaster.parent_id IS NULL'
            )
        ))));
    }

    /**
     * Check if a collection can be deleted.
     *
     * @param $collectionId Id of the studied collection.
     *       
     * @return Return results as array:
     *         ['allow_deletion'] = true/false
     *         ['msg'] = message to display when previous field equals false
     *        
     * @author N. Luc
     * @since 2007-10-16
     */
    public function allowDeletion($collectionId)
    {
        // Check collection has no sample
        $sampleMasterModel = AppModel::getInstance("InventoryManagement", "SampleMaster", true);
        $returnedNbr = $sampleMasterModel->find('count', array(
            'conditions' => array(
                'SampleMaster.collection_id' => $collectionId
            ),
            'recursive' => - 1
        ));
        if ($returnedNbr > 0) {
            return array(
                'allow_deletion' => false,
                'msg' => 'sample exists within the deleted collection'
            );
        }
        
        // Check Collection has not been linked to a participant, consent or diagnosis
        $collData = $this->getOrRedirect($collectionId);
        if ($collData['Collection']['participant_id']) {
            return array(
                'allow_deletion' => false,
                'msg' => 'the deleted collection is linked to participant'
            );
        }
        
        return array(
            'allow_deletion' => true,
            'msg' => ''
        );
    }

    /**
     * Checks if a collection link (to a participant) can be deleted.
     *
     * @param int $collectionId
     * @return Return results as array:
     *         ['allow_deletion'] = true/false
     *         ['msg'] = message to display when previous field equals false
     */
    public function allowLinkDeletion($collectionId)
    {
        return array(
            'allow_deletion' => true,
            'msg' => ''
        );
    }

    /**
     *
     * @param array $options
     * @return bool
     */
    public function validates($options = array())
    {
        // make sure all linked model are owned by the right participant
        $tmpData = $this->data;
        $tmpValidationErrors = $this->validationErrors;
        $prevData = null;
        if ($this->id) {
            $prevData = $this->read();
            $this->data = $tmpData;
            $this->validationErrors = $tmpValidationErrors;
        }
        foreach (array(
            'ConsentMaster' => 'consent_master_id',
            'DiagnosisMaster' => 'diagnosis_master_id',
            'TreatmentMaster' => 'treatment_master_id',
            'EventMaster' => 'event_master_id'
        ) as $modelName => $modelKey) {
            if (isset($this->data['Collection'][$modelKey]) && $this->data['Collection'][$modelKey] && (! isset($prevData['Collection'][$modelKey]) || $prevData['Collection'][$modelKey] != $this->data['Collection'][$modelKey])) {
                // defined and changed, check participant
                $model = AppModel::getInstance('ClinicalAnnotation', $modelName, true);
                $modelData = $model->getOrRedirect($this->data['Collection'][$modelKey]);
                if (empty($modelData) || $modelData[$modelName]['participant_id'] != $this->data['Collection']['participant_id']) {
                    $this->validationErrors[][] = 'ERROR: data owned by another partcipant for model [' . $modelName . ']';
                }
            }
        }
        
        return parent::validates($options);
    }
}