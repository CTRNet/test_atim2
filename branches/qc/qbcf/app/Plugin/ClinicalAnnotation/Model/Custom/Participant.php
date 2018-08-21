<?php

class ParticipantCustom extends Participant
{

    var $useTable = 'participants';

    var $name = 'Participant';

    public function summary($variables = array())
    {
        $return = false;
        
        if (isset($variables['Participant.id'])) {
            $result = $this->find('first', array(
                'conditions' => array(
                    'Participant.id' => $variables['Participant.id']
                )
            ));
            
            $bankIdentfiers = CONFIDENTIAL_MARKER;
            if ($result['Participant']['qbcf_bank_participant_identifier'] != CONFIDENTIAL_MARKER) {
                $bankModel = AppModel::getInstance('Administrate', 'Bank', true);
                $bank = $bankModel->find('first', array(
                    'conditions' => array(
                        'Bank.id' => $result['Participant']['qbcf_bank_id']
                    )
                ));
                $bankIdentfiers = (empty($bank['Bank']['name']) ? '?' : $bank['Bank']['name']) . ' : ' . $result['Participant']['qbcf_bank_participant_identifier'];
            }
            
            $label = $bankIdentfiers . ' [' . $result['Participant']['participant_identifier'] . ']';
            $return = array(
                'menu' => array(
                    NULL,
                    $label
                ),
                'title' => array(
                    NULL,
                    $label
                ),
                'structure alias' => 'participants',
                'data' => $result
            );
        }
        
        return $return;
    }

    public function validates($options = array())
    {
        $result = parent::validates($options);
        
        if (array_key_exists('qbcf_bank_id', $this->data['Participant'])) {
            $conditions = array(
                'Participant.qbcf_bank_id' => $this->data['Participant']['qbcf_bank_id'],
                'Participant.qbcf_bank_participant_identifier' => $this->data['Participant']['qbcf_bank_participant_identifier']
            );
            if ($this->id)
                $conditions[] = 'Participant.id != ' . $this->id;
            
            $count = $this->find('count', array(
                'conditions' => $conditions
            ));
            if ($count) {
                $this->validationErrors['qbcf_bank_participant_identifier'][] = 'this bank participant identifier has already been assigned to a patient of this bank';
                $result = false;
            }
        }
        
        return $result;
    }

    public function beforeFind($queryData)
    {
        if (($_SESSION['Auth']['User']['group_id'] != '1') && is_array($queryData['conditions']) && AppModel::isFieldUsedAsCondition("Participant.qbcf_bank_participant_identifier", $queryData['conditions'])) {
            AppController::addWarningMsg(__('your search will be limited to your bank'));
            $GroupModel = AppModel::getInstance("", "Group", true);
            $groupData = $GroupModel->findById($_SESSION['Auth']['User']['group_id']);
            $userBankId = $groupData['Group']['bank_id'];
            $queryData['conditions'][] = array(
                "Participant.qbcf_bank_id" => $userBankId
            );
        }
        return $queryData;
    }

    public function afterFind($results, $primary = false)
    {
        $results = parent::afterFind($results);
        if ($_SESSION['Auth']['User']['group_id'] != '1') {
            $GroupModel = AppModel::getInstance("", "Group", true);
            $groupData = $GroupModel->findById($_SESSION['Auth']['User']['group_id']);
            $userBankId = $groupData['Group']['bank_id'];
            if (isset($results[0]['Participant']['qbcf_bank_id']) || isset($results[0]['Participant']['qbcf_bank_participant_identifier'])) {
                foreach ($results as &$result) {
                    if ((! isset($result['Participant']['qbcf_bank_id'])) || $result['Participant']['qbcf_bank_id'] != $userBankId) {
                        $result['Participant']['qbcf_bank_id'] = CONFIDENTIAL_MARKER;
                        $result['Participant']['qbcf_bank_participant_identifier'] = CONFIDENTIAL_MARKER;
                    }
                }
            } elseif (isset($results['Participant'])) {
                pr('TODO afterFind participants');
                pr($results);
                exit();
            }
        }
        
        return $results;
    }
}