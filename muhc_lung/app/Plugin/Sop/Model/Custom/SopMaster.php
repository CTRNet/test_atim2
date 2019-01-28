<?php

/**
 * Class SopMaster
 */
class SopMasterCustom extends SopMaster
{

    public $name = 'SopMaster';

    public $useTable = 'sop_masters';

    /**
     *
     * @return array
     */
    public function getAllSopPermissibleValues()
    {
        $result = array();
        
        // Build tmp array to sort according translation
        foreach ($this->find('all', array(
            'order' => 'SopMaster.title'
        )) as $sop) {
            
            $result[$sop['SopMaster']['id']] = $sop['SopMaster']['code'] . ' / V - ' . (strlen($sop['SopMaster']['version']) ? $sop['SopMaster']['version'] : '?');
        }
        
        return $result;
    }
}