<?php

/**
 * Class Material
 */
class Material extends AppModel
{

    /**
     * @param array $variables
     * @return array|bool
     */
    public function summary($variables = array())
    {
        $return = false;
        
        if (isset($variables['Materials.id'])) {
            
            $result = $this->find('first', array(
                'conditions' => array(
                    'Materials.id' => $variables['Materials.id']
                )
            ));
            
            $return = array(
                'item_name' => $result['Materials']['item_name'],
                'item_type' => $result['Materials']['item_type'],
                'data' => $result,
                'structure alias' => 'materials'
            );
        }
        
        return $return;
    }
}