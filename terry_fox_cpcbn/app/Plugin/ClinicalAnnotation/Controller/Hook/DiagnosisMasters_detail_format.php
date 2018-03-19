<?php
if ($dxMasterData['DiagnosisControl']['controls_type'] == 'prostate' && $dxMasterData['DiagnosisControl']['category'] == 'primary') {
    $diseaseFreeStartTrt = $this->TreatmentMaster->find('first', array(
        'conditions' => array(
            'TreatmentMaster.participant_id' => $participantId,
            'TreatmentMaster.diagnosis_master_id' => $diagnosisMasterId,
            'TreatmentMaster.qc_tf_disease_free_survival_start_events' => '1'
        ),
        'recursive' => -1
    ));
    $this->set('diseaseFreeStartTrtId', empty($diseaseFreeStartTrt) ? '-1' : $diseaseFreeStartTrt['TreatmentMaster']['id']);
    
    $conditions = array(
        'DiagnosisMaster.primary_id ' => $diagnosisMasterId,
        'DiagnosisDetail.first_biochemical_recurrence' => '1'
    );
    $joins = array(
        array(
            'table' => 'qc_tf_dxd_recurrence_bio',
            'alias' => 'DiagnosisDetail',
            'type' => 'INNER',
            'conditions' => array(
                'DiagnosisDetail.diagnosis_master_id = DiagnosisMaster.id'
            )
        )
    );
    $diseaseFreeEndBcr = $this->DiagnosisMaster->find('first', array(
        'conditions' => $conditions,
        'joins' => $joins
    ));
    $this->set('diseaseFreeEndBcrId', empty($diseaseFreeEndBcr) ? '-1' : $diseaseFreeEndBcr['DiagnosisMaster']['id']);
}