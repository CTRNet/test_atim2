<?php

class TreatmentExtendControl extends ClinicalAnnotationAppModel
{

    public $masterFormAlias = 'treatment_extend_masters';

    function getPrecisionTypeValues()
    {
        $result = array();
        
        // Build tmp array to sort according translation
        foreach ($this->find('all', array(
            'conditions' => array(
                'flag_active = 1'
            )
        )) as $txExtendCtrl) {
            $result[$txExtendCtrl['TreatmentExtendControl']['type']] = __($txExtendCtrl['TreatmentExtendControl']['type']);
        }
        natcasesort($result);
        
        return $result;
    }

    function afterFind($results, $primary = false)
    {
        return $this->applyMasterFormAlias($results, $primary);
    }
}
