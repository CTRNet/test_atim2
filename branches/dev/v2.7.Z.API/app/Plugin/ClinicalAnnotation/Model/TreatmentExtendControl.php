<?php

/**
 * Class TreatmentExtendControl
 */
class TreatmentExtendControl extends ClinicalAnnotationAppModel
{

    public $masterFormAlias = 'treatment_extend_masters';

    /**
     *
     * @return array
     */
    public function getPrecisionTypeValues()
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

    /**
     *
     * @param mixed $results
     * @param bool $primary
     * @return mixed
     */
    public function afterFind($results, $primary = false)
    {
        return $this->applyMasterFormAlias($results, $primary);
    }
}