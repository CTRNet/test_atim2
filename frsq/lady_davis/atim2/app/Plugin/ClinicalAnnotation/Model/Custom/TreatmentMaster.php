<?php

class TreatmentMasterCustom extends TreatmentMaster
{

    var $name = "TreatmentMaster";

    var $tableName = "treatment_masters";

    public function beforeSave($options = array())
    {
        if (isset($this->data['TreatmentDetail']) && array_key_exists('er_receptor_ccl', $this->data['TreatmentDetail'])) {
            $erReceptorCcl = $this->data['TreatmentDetail']['er_receptor_ccl'];
            $prReceptorCcl = $this->data['TreatmentDetail']['pr_receptor_ccl'];
            $her2ReceptorCcl = $this->data['TreatmentDetail']['her2_receptor_ccl'];
            $fishCcl = $this->data['TreatmentDetail']['fish_ccl'];
            $tripleNegativeCcl = '';
            if ($erReceptorCcl == 'negative' && $prReceptorCcl == 'negative' && ($her2ReceptorCcl == 'negative' || $fishCcl == 'negative')) {
                $tripleNegativeCcl = 'y';
            } else 
                if ((strlen($erReceptorCcl) && $erReceptorCcl != 'negative') || (strlen($prReceptorCcl) && $prReceptorCcl != 'negative') || (strlen($her2ReceptorCcl . $fishCcl) && ! preg_match('/negative/', $her2ReceptorCcl . $fishCcl))) {
                    $tripleNegativeCcl = 'n';
                }
            $this->data['TreatmentDetail']['triple_negative_ccl'] = $tripleNegativeCcl;
            $this->addWritableField(array(
                'triple_negative_ccl'
            ));
        }
        
        $retVal = parent::beforeSave($options);
        return $retVal;
    }

    public function afterSave($created, $options = Array())
    {
        $DiagnosisMaster = AppModel::getInstance("ClinicalAnnotation", "DiagnosisMaster", true);
        if (isset($this->data['TreatmentMaster']['diagnosis_master_id']) && $this->data['TreatmentMaster']['diagnosis_master_id'])
            $DiagnosisMaster->validateLaterality($this->data['TreatmentMaster']['diagnosis_master_id']);
        parent::afterSave($created);
    }
}