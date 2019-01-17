<?php

/**
 * Class SopControl
 */
class SopControl extends SopAppModel
{

    public $useTable = 'sop_controls';

    public $masterFormAlias = 'sopmasters';

    /**
     *
     * @return array
     */
    public function getTypePermissibleValues()
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

    /**
     *
     * @return array
     */
    public function getGroupPermissibleValues()
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