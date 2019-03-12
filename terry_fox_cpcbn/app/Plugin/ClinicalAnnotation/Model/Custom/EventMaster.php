<?php

class EventMasterCustom extends EventMaster
{

    var $useTable = 'event_masters';

    var $name = 'EventMaster';

    public function beforeSave($options = array())
    {
        $retVal = parent::beforeSave($options);
        if (isset($this->data['EventDetail']['height_m']) && isset($this->data['EventDetail']['height_m'])) {
            $heightM = $this->data['EventDetail']['height_m'];
            $weightKg = $this->data['EventDetail']['weight_kg'];
            $bmi = '';
            if (preg_match('/^(([0-9]+)|([0-9]+\.[0-9]*))$/', $heightM) && preg_match('/^(([0-9]+)|([0-9]+\.[0-9]*))$/', $weightKg)) {
                if ($heightM != '0') {
                    $bmi = $weightKg / ($heightM * $heightM);
                }
            }
            $this->data['EventDetail']['bmi'] = $bmi;
            $this->addWritableField(array(
                'bmi'
            ));
        }
        return $retVal;
    }
}