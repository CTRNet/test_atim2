<?php

/**
 * Class DiagnosisControl
 */
class DiagnosisControl extends ClinicalAnnotationAppModel
{

    public $masterFormAlias = 'diagnosismasters';

    /**
     * Get permissible values array gathering all existing diagnosis types.
     *
     * @author N. Luc
     * @since 2010-05-26
     *        @updated N. Luc
     */
    public function getDiagnosisTypePermissibleValuesFromId()
    {
        $result = array();
        
        // Build tmp array to sort according translation
        foreach ($this->find('all', array(
            'conditions' => array(
                'flag_active = 1'
            )
        )) as $diagnosisControl) {
            $result[$diagnosisControl['DiagnosisControl']['id']] = __($diagnosisControl['DiagnosisControl']['controls_type']);
        }
        natcasesort($result);
        
        return $result;
    }

    /**
     *
     * @return array
     */
    public function getTypePermissibleValues()
    {
        $result = array();
        
        // Build tmp array to sort according translation
        foreach ($this->find('all', array(
            'conditions' => array(
                'flag_active = 1'
            )
        )) as $diagnosisControl) {
            $result[$diagnosisControl['DiagnosisControl']['controls_type']] = __($diagnosisControl['DiagnosisControl']['controls_type']);
        }
        natcasesort($result);
        
        return $result;
    }

    /**
     *
     * @return array
     */
    public function getCategoryPermissibleValues()
    {
        $result = array();
        
        // Build tmp array to sort according translation
        foreach ($this->find('all', array(
            'conditions' => array(
                'flag_active = 1'
            )
        )) as $diagnosisControl) {
            $result[$diagnosisControl['DiagnosisControl']['category']] = __($diagnosisControl['DiagnosisControl']['category']);
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