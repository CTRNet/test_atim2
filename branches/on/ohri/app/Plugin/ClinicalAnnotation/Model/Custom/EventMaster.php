<?php

class EventMasterCustom extends EventMaster
{

    var $useTable = 'event_masters';

    var $name = 'EventMaster';

    public function summary($variables = array())
    {
        $return = false;
        
        if (isset($variables['EventMaster.id'])) {
            
            $result = $this->find('first', array(
                'conditions' => array(
                    'EventMaster.id' => $variables['EventMaster.id']
                )
            ));
            
            $return = array(
                'menu' => array(
                    null,
                    __($result['EventControl']['event_type'], true)
                ),
                'title' => array(
                    null,
                    __('annotation', true)
                ),
                'data' => $result,
                'structure alias' => 'eventmasters'
            );
        } elseif (isset($variables['EventControl.id'])) {
            $return = array();
        }
        
        return $return;
    }
}