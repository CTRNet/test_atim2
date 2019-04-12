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
 * Class DiagnosisMaster
 */
class DiagnosisMaster extends ClinicalAnnotationAppModel
{

    public $belongsTo = array(
        'DiagnosisControl' => array(
            'className' => 'ClinicalAnnotation.DiagnosisControl',
            'foreignKey' => 'diagnosis_control_id'
        )
    );

    public $hasMany = array(
        'Collection' => array(
            'className' => 'InventoryManagement.Collection',
            'foreignKey' => 'diagnosis_master_id'
        )
    );

    public static $joinDiagnosisControlOnDup = array(
        'table' => 'diagnosis_controls',
        'alias' => 'DiagnosisControl',
        'type' => 'LEFT',
        'conditions' => array(
            'diagnosis_masters_dup.diagnosis_control_id = DiagnosisControl.id'
        )
    );

    public $browsingSearchDropdownInfo = array(
        'browsing_filter' => array(
            1 => array(
                'lang' => 'keep entries with the most recent date per participant',
                'group by' => 'participant_id',
                'field' => 'dx_date',
                'attribute' => 'MAX'
            ),
            2 => array(
                'lang' => 'keep entries with the oldest date per participant',
                'group by' => 'participant_id',
                'field' => 'dx_date',
                'attribute' => 'MIN'
            )
        )
    );

    /**
     *
     * @param array $variables
     * @return array|bool
     */
    public function primarySummary($variables = array())
    {
        return $this->summary($variables['DiagnosisMaster.primary_id']);
    }

    /**
     *
     * @param array $variables
     * @return array|bool
     */
    public function progression1Summary($variables = array())
    {
        return $this->summary($variables['DiagnosisMaster.progression_1_id']);
    }

    /**
     *
     * @param array $variables
     * @return array|bool
     */
    public function progression2Summary($variables = array())
    {
        return $this->summary($variables['DiagnosisMaster.progression_2_id']);
    }

    /**
     *
     * @param null $diagnosisMasterId
     * @return array|bool
     */
    public function summary($diagnosisMasterId = null)
    {
        $return = false;
        if (! is_null($diagnosisMasterId)) {
            $result = $this->find('first', array(
                'conditions' => array(
                    'DiagnosisMaster.id' => $diagnosisMasterId
                ),
                'recursive' => 0
            ));
            
            $structureAlias = 'diagnosismasters';
            switch ($result['DiagnosisControl']['category']) {
                case 'primary':
                    if ($result['DiagnosisControl']['controls_type'] != 'primary diagnosis unknown')
                        $structureAlias .= ',dx_primary';
                    break;
                case 'secondary - distant':
                    $structureAlias = ',dx_secondary';
                    break;
            }
            
            $return = array(
                'menu' => array(
                    null,
                    __($result['DiagnosisControl']['category'], true) . ' - ' . __($result['DiagnosisControl']['controls_type'], true)
                ),
                'title' => array(
                    null,
                    __($result['DiagnosisControl']['category'], true)
                ),
                'data' => $result,
                'structure alias' => $structureAlias
            );
        }
        return $return;
    }

    /**
     * Replaces icd10 empty string to null values to respect foreign keys constraints
     *
     * @param $participantArray
     */
    public function patchIcd10NullValues(&$participantArray)
    {
        if (array_key_exists('icd10_code', $participantArray['DiagnosisMaster']) && strlen(trim($participantArray['DiagnosisMaster']['icd10_code'])) == 0) {
            $participantArray['DiagnosisMaster']['icd10_code'] = null;
        }
    }

    /**
     * Check if a record can be deleted.
     *
     * @param $diagnosisMasterId Id of the studied record.
     *       
     * @return Return results as array:
     *         ['allow_deletion'] = true/false
     *         ['msg'] = message to display when previous field equals false
     *        
     * @author N. Luc
     * @since 2007-10-16
     */
    public function allowDeletion($diagnosisMasterId)
    {
        $arrAllowDeletion = array(
            'allow_deletion' => true,
            'msg' => ''
        );
        
        // Check for existing records linked to the participant. If found, set error message and deny delete
        $nbrPrimary = $this->find('count', array(
            'conditions' => array(
                'DiagnosisMaster.primary_id' => $diagnosisMasterId,
                "DiagnosisMaster.id != $diagnosisMasterId"
            ),
            'recursive' => - 1
        ));
        if ($nbrPrimary > 0) {
            $arrAllowDeletion['allow_deletion'] = false;
            $arrAllowDeletion['msg'] = 'error_fk_diagnosis_primary_id';
        }
        
        // Check for existing records linked to the participant. If found, set error message and deny delete
        $nbrParent = $this->find('count', array(
            'conditions' => array(
                'DiagnosisMaster.parent_id' => $diagnosisMasterId
            ),
            'recursive' => - 1
        ));
        if ($nbrParent > 0) {
            $arrAllowDeletion['allow_deletion'] = false;
            $arrAllowDeletion['msg'] = 'error_fk_diagnosis_parent_id';
        }
        
        // Check for existing records linked to the participant. If found, set error message and deny delete
        $collectionModel = AppModel::getInstance("InventoryManagement", "Collection", true);
        $nbrLinkedCollection = $collectionModel->find('count', array(
            'conditions' => array(
                'Collection.diagnosis_master_id' => $diagnosisMasterId
            )
        ));
        if ($nbrLinkedCollection > 0) {
            $arrAllowDeletion['allow_deletion'] = false;
            $arrAllowDeletion['msg'] = 'error_fk_diagnosis_linked_collection';
        }
        
        $eventMasterModel = AppModel::getInstance("ClinicalAnnotation", "EventMaster", true);
        $nbrEvents = $eventMasterModel->find('count', array(
            'conditions' => array(
                'EventMaster.diagnosis_master_id' => $diagnosisMasterId
            )
        ));
        if ($nbrEvents > 0) {
            $arrAllowDeletion['allow_deletion'] = false;
            $arrAllowDeletion['msg'] = 'error_fk_diagnosis_linked_events';
        }
        
        $treatmentMasterModel = AppModel::getInstance("ClinicalAnnotation", "TreatmentMaster", true);
        $nbrTreatment = $treatmentMasterModel->find('count', array(
            'conditions' => array(
                'TreatmentMaster.diagnosis_master_id' => $diagnosisMasterId
            )
        ));
        if ($nbrTreatment > 0) {
            $arrAllowDeletion['allow_deletion'] = false;
            $arrAllowDeletion['msg'] = 'error_fk_diagnosis_linked_treatment';
        }
        return $arrAllowDeletion;
    }

    /**
     *
     * @param $participantId
     * @param string $currentDxId
     * @param string $currentDxPrimaryNumber
     * @return mixed
     */
    public function getExistingDx($participantId, $currentDxId = '0', $currentDxPrimaryNumber = '')
    {
        $existingDx = $this->find('all', array(
            'conditions' => array(
                'DiagnosisMaster.participant_id' => $participantId,
                'DiagnosisMaster.id != ' . $currentDxId
            )
        ));
        // sort by dx number
        if (empty($existingDx)) {
            $sortedDx[''] = array();
        } else {
            foreach ($existingDx as $dx) {
                if (isset($sortedDx[$dx['DiagnosisMaster']['primary_number']])) {
                    array_push($sortedDx[$dx['DiagnosisMaster']['primary_number']], $dx);
                } else {
                    $sortedDx[$dx['DiagnosisMaster']['primary_number']][0] = $dx;
                }
            }
            if (! isset($sortedDx[''])) {
                $sortedDx[''] = array();
            }
            if (! isset($sortedDx[$currentDxPrimaryNumber])) {
                $sortedDx[$currentDxPrimaryNumber] = array();
            }
        }
        ksort($sortedDx);
        return $sortedDx;
    }

    /**
     *
     * @param array $diagnosisMasterIds
     * @return array
     */
    public function hasChild(array $diagnosisMasterIds)
    {
        $txModel = AppModel::getInstance("ClinicalAnnotation", "TreatmentMaster", true);
        $eventMasterModel = AppModel::getInstance("ClinicalAnnotation", "EventMaster", true);
        return array_unique(array_merge($this->find('list', array(
            'fields' => array(
                'DiagnosisMaster.parent_id'
            ),
            'conditions' => array(
                'DiagnosisMaster.parent_id' => $diagnosisMasterIds
            )
        )), $txModel->find('list', array(
            'fields' => array(
                'TreatmentMaster.diagnosis_master_id'
            ),
            'conditions' => array(
                'TreatmentMaster.diagnosis_master_id' => $diagnosisMasterIds
            )
        )), $eventMasterModel->find('list', array(
            'fields' => array(
                'EventMaster.diagnosis_master_id'
            ),
            'conditions' => array(
                'EventMaster.diagnosis_master_id' => $diagnosisMasterIds
            )
        ))));
    }

    /**
     * Arranges the threaded data
     *
     * @param array $threadedDxData
     * @param $seekingDxId
     * @param $seekingModelName
     * @return bool
     */
    public function arrangeThreadedDataForView(array &$threadedDxData, $seekingDxId, $seekingModelName)
    {
        $stack = array();
        $currentArray = &$threadedDxData;
        $foundDx = false;
        foreach ($threadedDxData as &$data) {
            if ($data['DiagnosisMaster']['id'] == $seekingDxId) {
                $data[$seekingModelName]['diagnosis_master_id'] = $seekingDxId;
                $foundDx = true;
                break;
            }
            if (isset($data['children']) && ! empty($data['children'])) {
                if ($foundDx = $this->arrangeThreadedDataForView($data['children'], $seekingDxId, $seekingModelName)) {
                    break;
                }
            }
        }
        
        return $foundDx;
    }

    /**
     *
     * @param $diagnosisMasterId
     * @return array
     */
    public function getRelatedDiagnosisEvents($diagnosisMasterId)
    {
        $relatedDiagnosisData = array();
        
        if (! empty($diagnosisMasterId)) {
            $eventDiagnosisData = $this->getOrRedirect($diagnosisMasterId);
            $relatedDiagnosisData[] = array_merge(array(
                'Generated' => array(
                    'diagnosis_event_relation_type' => 'diagnosis event'
                )
            ), $eventDiagnosisData);
            
            $historyDiagnosisData = array();
            if ($eventDiagnosisData['DiagnosisMaster']['id'] != $eventDiagnosisData['DiagnosisMaster']['primary_id']) {
                $historyDiagnosisData = $this->find('all', array(
                    'conditions' => array(
                        'DiagnosisMaster.id' => array(
                            $eventDiagnosisData['DiagnosisMaster']['primary_id'],
                            $eventDiagnosisData['DiagnosisMaster']['parent_id']
                        )
                    ),
                    'order' => 'DiagnosisMaster.id DESC'
                ));
                if (empty($historyDiagnosisData)) {
                    AppController::getInstance()->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                }
                foreach ($historyDiagnosisData as $newDiag) {
                    $relatedDiagnosisData[] = array_merge(array(
                        'Generated' => array(
                            'diagnosis_event_relation_type' => 'diagnosis history'
                        )
                    ), $newDiag);
                }
            }
        }
        
        return $relatedDiagnosisData;
    }

    /**
     *
     * @param $onField
     * @return array
     */
    public static function joinOnDiagnosisDup($onField)
    {
        return array(
            'table' => 'diagnosis_masters',
            'alias' => 'diagnosis_masters_dup',
            'type' => 'LEFT',
            'conditions' => array(
                $onField . ' = diagnosis_masters_dup.id'
            )
        );
    }

    /**
     *
     * @param array $options
     * @return bool
     */
    public function beforeSave($options = array())
    {
        $retVal = parent::beforeSave($options);
        if (isset($this->data['DiagnosisMaster']['topography']) && preg_match('/^(C[0-9]{2})[0-9]$/', $this->data['DiagnosisMaster']['topography'], $matches)) {
            $this->data['DiagnosisMaster']['icd_0_3_topography_category'] = $matches[1];
            $this->addWritableField(array(
                'icd_0_3_topography_category'
            ));
        }
        return $retVal;
    }
}