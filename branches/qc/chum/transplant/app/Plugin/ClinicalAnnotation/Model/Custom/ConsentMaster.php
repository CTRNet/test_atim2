<?php

class ConsentMasterCustom extends ConsentMaster
{

    var $useTable = 'consent_masters';

    var $name = "ConsentMaster";

    // added validation
    public function validates($options = array())
    {
        $result = parent::validates($options);
        if (($this->data['ConsentMaster']['consent_status'] == 'obtained') && (empty($this->data['ConsentMaster']['consent_signed_date']))) {
            $result = false;
            $this->validationErrors['consent_status'][] = 'all obtained consents should have a signed date';
        }
        foreach (array(
            'biological_material_use',
            'use_of_blood',
            'additional_tumor_collection'
        ) as $newField) {
            if (array_key_exists($newField, $this->data['ConsentDetail']) && array_key_exists($newField . '_not_applicable', $this->data['ConsentDetail'])) {
                if (strlen($this->data['ConsentDetail'][$newField] && $this->data['ConsentDetail'][$newField . '_not_applicable'])) {
                    $result = false;
                    $this->validationErrors[$newField . '_not_applicable'][] = 'no value has to be completed for agreement if not applicable';
                }
            }
        }
        return $result;
    }

    public function beforeSave($options = array())
    {
        if (array_key_exists('ConsentMaster', $this->data) && array_key_exists('qc_nd_file_name', $this->data['ConsentMaster'])) {
            $this->data['ConsentMaster']['qc_nd_file_name'] = preg_replace('/[\\\]+/', '/', $this->data['ConsentMaster']['qc_nd_file_name']);
        }
        $retVal = parent::beforeSave($options);
        return $retVal;
    }
}