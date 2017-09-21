<?php

class BankCustom extends Bank
{

    var $useTable = 'banks';

    var $name = "Bank";

    public function allowDeletion($bankId)
    {
        $res = parent::allowDeletion($bankId);
        if (! $res['allow_deletion'])
            return $res;
        
        $ParticipantModel = AppModel::getInstance('ClinicalAnnotation', 'Participant', true);
        $data = $ParticipantModel->find('first', array(
            'conditions' => array(
                'Participant.qc_tf_bank_id' => $bankId
            )
        ));
        if ($data) {
            return array(
                'allow_deletion' => false,
                'msg' => 'at least one participant is linked to that bank'
            );
        }
        
        return array(
            'allow_deletion' => true,
            'msg' => ''
        );
    }
}