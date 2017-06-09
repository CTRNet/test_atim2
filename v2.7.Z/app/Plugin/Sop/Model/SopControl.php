<?php

class SopControl extends SopAppModel
{

    public $useTable = 'sop_controls';

    public $masterFormAlias = 'sopmasters';

    function getTypePermissibleValues()
    {
        $result = array();
        
        // Build tmp array to sort according to translated value
        foreach ($this->find('all', array(
            'conditions' => array(
                'flag_active = 1'
            )
        )) as $sopControl) {
            $result[$sopControl['SopControl']['type']] = __($sopControl['SopControl']['type']);
        }
        natcasesort($result);
        
        return $result;
    }

    function getGroupPermissibleValues()
    {
        $result = array();
        
        // Build tmp array to sort according to translated value
        foreach ($this->find('all', array(
            'conditions' => array(
                'flag_active = 1'
            )
        )) as $sopControl) {
            $result[$sopControl['SopControl']['sop_group']] = __($sopControl['SopControl']['sop_group']);
        }
        natcasesort($result);
        
        return $result;
    }

    function afterFind($results, $primary = false)
    {
        return $this->applyMasterFormAlias($results, $primary);
    }
}
