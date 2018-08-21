<?php

class DiagnosisMasterCustom extends DiagnosisMaster
{

    var $useTable = 'diagnosis_masters';

    var $name = 'DiagnosisMaster';

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
            $result['Generated']['qbcf_dx_detail_for_tree_view'] = '';
            $return = array(
                'menu' => array(
                    NULL,
                    __($result['DiagnosisControl']['category'], true) . ' - ' . __($result['DiagnosisControl']['controls_type'], true)
                ),
                'title' => array(
                    NULL,
                    __($result['DiagnosisControl']['category'], true)
                ),
                'data' => $result,
                'structure alias' => $structureAlias
            );
        }
        return $return;
    }

    public function setBreastDxLaterality($participantId)
    {
        $TreatmentModel = AppModel::getInstance("ClinicalAnnotation", "TreatmentMaster", true);
        $participantBreastDx = $this->find('all', array(
            'conditions' => array(
                'DiagnosisControl.controls_type' => 'breast',
                'DiagnosisMaster.participant_id' => $participantId
            )
        ));
        $allDxToUpdate = array();
        foreach ($participantBreastDx as $newBrestDx) {
            $txJoins = array(
                'table' => 'qbcf_tx_breast_diagnostic_events',
                'alias' => 'TreatmentDetail',
                'type' => 'INNER',
                'conditions' => array(
                    'TreatmentMaster.id = TreatmentDetail.treatment_master_id'
                )
            );
            $breastDxEventLaterality = $TreatmentModel->find('all', array(
                'conditions' => array(
                    'TreatmentControl.tx_method' => 'breast diagnostic event',
                    'TreatmentMaster.diagnosis_master_id' => $newBrestDx['DiagnosisMaster']['id']
                ),
                'joins' => array(
                    $txJoins
                ),
                'fields' => array(
                    'DISTINCT TreatmentDetail.laterality'
                )
            ));
            $allDxLaterality = array(
                'laterality_left' => 'n',
                'laterality_right' => 'n',
                'laterality_bilateral' => 'n'
            );
            foreach ($breastDxEventLaterality as $newLaterality) {
                $newLaterality = $newLaterality['TreatmentDetail']['laterality'];
                if (isset($allDxLaterality['laterality_' . $newLaterality]))
                    $allDxLaterality['laterality_' . $newLaterality] = 'y';
            }
            foreach ($allDxLaterality as $field => $newValue) {
                if (! array_key_exists($field, $newBrestDx['DiagnosisDetail']) || $newBrestDx['DiagnosisDetail'][$field] == $newValue) {
                    unset($allDxLaterality[$field]);
                }
            }
            if ($allDxLaterality) {
                $allDxToUpdate[] = array(
                    'DiagnosisMaster' => array(
                        'id' => $newBrestDx['DiagnosisMaster']['id']
                    ),
                    'DiagnosisDetail' => $allDxLaterality
                );
            }
        }
        foreach ($allDxToUpdate as $newDxToUpdate) {
            $this->data = array(); // *** To guaranty no merge will be done with previous data ***
            $this->id = $newDxToUpdate['DiagnosisMaster']['id'];
            if (! $this->save($newDxToUpdate, false)) {
                $this->redirect('/Pages/err_plugin_record_err?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
            }
        }
    }
}