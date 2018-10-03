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
}