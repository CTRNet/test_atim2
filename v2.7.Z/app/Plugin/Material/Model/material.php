<?php

class Material extends AppModel
{

    public $name = 'Material';

    public $useTable = 'materials';

    public function summary($variables = array())
    {
        $return = false;
        
        if (isset($variables['Material.id'])) {
            
            $result = $this->find('first', array(
                'conditions' => array(
                    'Material.id' => $variables['Material.id']
                )
            ));
            
            $return = array(
                'menu' => array(
                    NULL,
                    $result['Material']['item_name']
                ),
                'title' => array(
                    NULL,
                    $result['Material']['item_name']
                ),
                'data' => $result,
                'structure alias' => 'materials'
            );
        }
        
        return $return;
    }
}