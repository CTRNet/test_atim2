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