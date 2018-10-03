<?php

class ParticipantCustom extends Participant
{

    var $useTable = 'participants';

    var $name = 'Participant';

    public function summary($variables = array())
    {
        $return = false;
        
        if (isset($variables['Participant.id'])) {
            $result = $this->find('first', array(
                'conditions' => array(
                    'Participant.id' => $variables['Participant.id']
                )
            ));
            
            // Add No Labs to description
            $title = __('participant identifier') . ' ' . $result['Participant']['participant_identifier'];
            
            $return = array(
                'menu' => array(
                    null,
                    $title
                ),
                'title' => array(
                    null,
                    $title
                ),
                'structure alias' => 'participants',
                'data' => $result
            );
        }
        
        return $return;
    }
}