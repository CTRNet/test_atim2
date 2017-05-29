<?php

class DiagnosisControl extends ClinicalAnnotationAppModel
{

    public $master_form_alias = 'diagnosismasters';

    /**
     * Get permissible values array gathering all existing diagnosis types.
     *
     * @author N. Luc
     * @since 2010-05-26
     *        @updated N. Luc
     */
    function getDiagnosisTypePermissibleValuesFromId()
    {
        $result = array();
        
        // Build tmp array to sort according translation
        foreach ($this->find('all', array(
            'conditions' => array(
                'flag_active = 1'
            )
        )) as $diagnosis_control) {
            $result[$diagnosis_control['DiagnosisControl']['id']] = __($diagnosis_control['DiagnosisControl']['controls_type']);
        }
        natcasesort($result);
        
        return $result;
    }

    function getTypePermissibleValues()
    {
        $result = array();
        
        // Build tmp array to sort according translation
        foreach ($this->find('all', array(
            'conditions' => array(
                'flag_active = 1'
            )
        )) as $diagnosis_control) {
            $result[$diagnosis_control['DiagnosisControl']['controls_type']] = __($diagnosis_control['DiagnosisControl']['controls_type']);
        }
        natcasesort($result);
        
        return $result;
    }

    function getCategoryPermissibleValues()
    {
        $result = array();
        
        // Build tmp array to sort according translation
        foreach ($this->find('all', array(
            'conditions' => array(
                'flag_active = 1'
            )
        )) as $diagnosis_control) {
            $result[$diagnosis_control['DiagnosisControl']['category']] = __($diagnosis_control['DiagnosisControl']['category']);
        }
        natcasesort($result);
        
        return $result;
    }

    function afterFind($results, $primary = false)
    {
        return $this->applyMasterFormAlias($results, $primary);
    }
}