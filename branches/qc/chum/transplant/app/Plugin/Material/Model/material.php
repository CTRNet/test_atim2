<?php

/**
 * Class Material
 */
class Material extends AppModel
{

    public $name = 'Material';

    public $useTable = 'materials';

    /**
     *
     * @param array $variables
     * @return array|bool
     */
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
                    null,
                    $result['Material']['item_name']
                ),
                'title' => array(
                    null,
                    $result['Material']['item_name']
                ),
                'data' => $result,
                'structure alias' => 'materials'
            );
        }
        
        return $return;
    }
}