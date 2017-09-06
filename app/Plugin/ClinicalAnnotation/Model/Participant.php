<?php

class Participant extends ClinicalAnnotationAppModel
{

    public $virtualFields = array(
        'age' => 'IF(date_of_birth IS NULL, NULL, YEAR(NOW()) - YEAR(date_of_birth) - (DAYOFYEAR(NOW()) < DAYOFYEAR(date_of_birth)))'
    );

    public $registeredView = array(
        'InventoryManagement.ViewCollection' => array(
            'Participant.id'
        ),
        'InventoryManagement.ViewSample' => array(
            'Participant.id'
        ),
        'InventoryManagement.ViewAliquot' => array(
            'Participant.id'
        )
    );

    public function summary($variables = array())
    {
        $return = false;
        
        if (isset($variables['Participant.id'])) {
            $result = $this->find('first', array(
                'conditions' => array(
                    'Participant.id' => $variables['Participant.id']
                )
            ));
            
            $return = array(
                'menu' => array(
                    null,
                    ($result['Participant']['participant_identifier'])
                ),
                'title' => array(
                    null,
                    ($result['Participant']['participant_identifier'])
                ),
                'structure alias' => 'participants',
                'data' => $result
            );
        }
        
        return $return;
    }

    /**
     * Replaces icd10 empty string to null values to respect foreign keys constraints
     *
     * @param array $participantArray            
     */
    public function patchIcd10NullValues(array &$participant)
    {
        if (isset($participant['Participant']['cod_icd10_code']) && strlen(trim($participant['Participant']['cod_icd10_code'])) == 0) {
            $participant['Participant']['cod_icd10_code'] = null;
        }
        if (isset($participant['Participant']['secondary_cod_icd10_code']) && strlen(trim($participant['Participant']['secondary_cod_icd10_code'])) == 0) {
            $participant['Participant']['secondary_cod_icd10_code'] = null;
        }
    }

    /**
     * Check if a record can be deleted.
     *
     * @param $participantId ID
     *            of the studied record.
     *            
     * @return Return results as array:
     *         ['allow_deletion'] = true/false
     *         ['msg'] = message to display when previous field equals false
     *        
     * @author N. Luc
     * @since 2007-10-16
     */
    public function allowDeletion($participantId)
    {
        $arrAllowDeletion = array(
            'allow_deletion' => true,
            'msg' => ''
        );
        
        // Check for existing records linked to the participant. If found, set error message and deny delete
        $collectionModel = AppModel::getInstance("InventoryManagement", "Collection", true);
        $nbrLinkedCollection = $collectionModel->find('count', array(
            'conditions' => array(
                'Collection.participant_id' => $participantId
            )
        ));
        if ($nbrLinkedCollection > 0) {
            $arrAllowDeletion['allow_deletion'] = false;
            $arrAllowDeletion['msg'] = 'error_fk_participant_linked_collection';
        }
        
        $consentMasterModel = AppModel::getInstance("ClinicalAnnotation", "ConsentMaster", true);
        $nbrConsents = $consentMasterModel->find('count', array(
            'conditions' => array(
                'ConsentMaster.participant_id' => $participantId
            )
        ));
        if ($nbrConsents > 0) {
            $arrAllowDeletion['allow_deletion'] = false;
            $arrAllowDeletion['msg'] = 'error_fk_participant_linked_consent';
        }
        
        $diagnosisMasterModel = AppModel::getInstance("ClinicalAnnotation", "DiagnosisMaster", true);
        $nbrDiagnosis = $diagnosisMasterModel->find('count', array(
            'conditions' => array(
                'DiagnosisMaster.participant_id' => $participantId
            )
        ));
        if ($nbrDiagnosis > 0) {
            $arrAllowDeletion['allow_deletion'] = false;
            $arrAllowDeletion['msg'] = 'error_fk_participant_linked_diagnosis';
        }
        
        $treatmentMasterModel = AppModel::getInstance("ClinicalAnnotation", "TreatmentMaster", true);
        $nbrTreatment = $treatmentMasterModel->find('count', array(
            'conditions' => array(
                'TreatmentMaster.participant_id' => $participantId
            )
        ));
        if ($nbrTreatment > 0) {
            $arrAllowDeletion['allow_deletion'] = false;
            $arrAllowDeletion['msg'] = 'error_fk_participant_linked_treatment';
        }
        
        $familyHistoryModel = AppModel::getInstance("ClinicalAnnotation", "FamilyHistory", true);
        $nbrFamilyhistory = $familyHistoryModel->find('count', array(
            'conditions' => array(
                'FamilyHistory.participant_id' => $participantId
            )
        ));
        if ($nbrFamilyhistory > 0) {
            $arrAllowDeletion['allow_deletion'] = false;
            $arrAllowDeletion['msg'] = 'error_fk_participant_linked_familyhistory';
        }
        
        $reproductiveHistoryModel = AppModel::getInstance("ClinicalAnnotation", "ReproductiveHistory", true);
        $nbrReproductive = $reproductiveHistoryModel->find('count', array(
            'conditions' => array(
                'ReproductiveHistory.participant_id' => $participantId
            )
        ));
        if ($nbrReproductive > 0) {
            $arrAllowDeletion['allow_deletion'] = false;
            $arrAllowDeletion['msg'] = 'error_fk_participant_linked_reproductive';
        }
        
        $participantContactModel = AppModel::getInstance("ClinicalAnnotation", "ParticipantContact", true);
        $nbrContacts = $participantContactModel->find('count', array(
            'conditions' => array(
                'ParticipantContact.participant_id' => $participantId,
                array(
                    'OR' => array(
                        'ParticipantContact.confidential != 1',
                        'ParticipantContact.confidential = 1'
                    )
                )
            )
        ));
        if ($nbrContacts > 0) {
            $arrAllowDeletion['allow_deletion'] = false;
            $arrAllowDeletion['msg'] = 'error_fk_participant_linked_contacts';
        }
        
        $miscIdentifierModel = AppModel::getInstance("ClinicalAnnotation", "MiscIdentifier", true);
        $nbrIdentifiers = $miscIdentifierModel->find('count', array(
            'conditions' => array(
                'MiscIdentifier.participant_id' => $participantId
            )
        ));
        if ($nbrIdentifiers > 0) {
            $arrAllowDeletion['allow_deletion'] = false;
            $arrAllowDeletion['msg'] = 'error_fk_participant_linked_identifiers';
        }
        
        $participantMessageModel = AppModel::getInstance("ClinicalAnnotation", "ParticipantMessage", true);
        $nbrMessages = $participantMessageModel->find('count', array(
            'conditions' => array(
                'ParticipantMessage.participant_id' => $participantId
            )
        ));
        if ($nbrMessages > 0) {
            $arrAllowDeletion['allow_deletion'] = false;
            $arrAllowDeletion['msg'] = 'error_fk_participant_linked_messages';
        }
        
        $eventMasterModel = AppModel::getInstance("ClinicalAnnotation", "EventMaster", true);
        $nbrEvents = $eventMasterModel->find('count', array(
            'conditions' => array(
                'EventMaster.participant_id' => $participantId
            )
        ));
        if ($nbrEvents > 0) {
            $arrAllowDeletion['allow_deletion'] = false;
            $arrAllowDeletion['msg'] = 'error_fk_participant_linked_events';
        }
        
        return $arrAllowDeletion;
    }

    public function beforeSave($options = array())
    {
        if ($this->whitelist && ! in_array('last_modification', $this->whitelist))
            $this->whitelist = array_merge($this->whitelist, array(
                'last_modification',
                'last_modification_ds_id'
            ));
        $this->addWritableField(array(
            'last_modification',
            'last_modification_ds_id'
        ));
        $retVal = parent::beforeSave($options);
        $this->data['Participant']['last_modification'] = $this->data['Participant']['modified'];
        $this->data['Participant']['last_modification_ds_id'] = 4; // participant
        return $retVal;
    }
}