<?php

class TreatmentMasterCustom extends TreatmentMaster
{

    var $useTable = 'treatment_masters';

    var $name = 'TreatmentMaster';

    public function summary($variables = array())
    {
        $return = false;
        
        if (isset($variables['TreatmentMaster.id'])) {
            
            $result = $this->find('first', array(
                'conditions' => array(
                    'TreatmentMaster.id' => $variables['TreatmentMaster.id']
                )
            ));
            
            $return = array(
                'menu' => array(
                    null,
                    __($result['TreatmentControl']['tx_method'], true)
                ),
                'title' => array(
                    null,
                    __($result['TreatmentControl']['tx_method'], true)
                ),
                'data' => $result,
                'structure alias' => 'treatmentmasters'
            );
        }
        
        return $return;
    }
}