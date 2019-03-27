<?php

/**
 * Class ParticipantMessage
 */
class ParticipantMessage extends ClinicalAnnotationAppModel
{

    /**
     *
     * @param array $variables
     * @return bool
     */
    public function summary($variables = array())
    {
        $return = false;
        
        // if (isset($variables['ParticipantContact.id'])) {
        //
        // $result = $this->find('first', array('conditions'=>array('ParticipantMessage.id'=>$variables['ParticipantMessage.id'])));
        //
        // $return = array(
        // 'title' => array(null, $result['ParticipantMessage']['title']),
        // 'type' => array(null, $result['ParticipantMessage']['type']),
        // 'data' => $result,
        // 'structure alias'=>'participantmessages'
        // );
        // }
        return $return;
    }
}