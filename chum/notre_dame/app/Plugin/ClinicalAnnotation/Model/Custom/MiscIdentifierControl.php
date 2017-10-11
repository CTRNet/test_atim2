<?php

class MiscIdentifierControlCustom extends MiscIdentifierControl
{

    var $useTable = 'misc_identifier_controls';

    var $name = "MiscIdentifierControl";

    public function getIcmBankIdentifierNamesFromId()
    {
        $result = array();
        
        $conditions = array(
            'flag_active = 1',
            "misc_identifier_name LIKE '%bank no lab'"
        );
        foreach ($this->find('all', array(
            'conditions' => $conditions
        )) as $identCtrl) {
            $result[$identCtrl['MiscIdentifierControl']['id']] = __($identCtrl['MiscIdentifierControl']['misc_identifier_name'], true);
        }
        asort($result);
        
        return $result;
    }
}