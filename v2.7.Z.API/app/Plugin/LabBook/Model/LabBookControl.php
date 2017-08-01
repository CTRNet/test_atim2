<?php

class LabBookControl extends LabBookAppModel
{

    public $masterFormAlias = 'labbookmasters';

    public function getLabBookTypePermissibleValuesFromId()
    {
        $result = array();
        
        $conditions = array(
            'LabBookControl.flag_active' => 1
        );
        $controls = $this->find('all', array(
            'conditions' => $conditions
        ));
        foreach ($controls as $control) {
            $result[$control['LabBookControl']['id']] = __($control['LabBookControl']['book_type']);
        }
        natcasesort($result);
        
        return $result;
    }

    public function afterFind($results, $primary = false)
    {
        return $this->applyMasterFormAlias($results, $primary);
    }
}
