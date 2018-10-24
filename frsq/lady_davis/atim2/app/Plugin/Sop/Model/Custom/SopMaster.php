<?php

/**
 * Class SopMaster
 */
class SopMasterCustom extends SopMaster
{

    public $name = 'SopMaster';

    public $useTable = 'sop_masters';

    public function getAllActiveSopPermissibleValues()
    {
        $sops = parent::getAllSopPermissibleValues();
        $activatedSopMasterId = $this->find('list', array(
            'conditions' => array(
                'SopMaster.status' => 'activated'
            )
        ));
        foreach ($sops as $key => $tmpData) {
            if (! array_key_exists($key, $activatedSopMasterId)) {
                unset($sops[$key]);
            }
        }
        return $sops;
    }

    public function getActiveCollectionSopPermissibleValues()
    {
        return $this->getAllActiveSopPermissibleValues();
    }

    public function getAciveSampleSopPermissibleValues()
    {
        return $this->getAllActiveSopPermissibleValues();
    }
}