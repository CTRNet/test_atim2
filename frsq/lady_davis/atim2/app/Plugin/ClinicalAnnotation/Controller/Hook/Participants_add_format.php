<?php
if (empty($this->request->data)) {
    $lastParticipantIdentifier = $this->Participant->find('first', array(
        'fields' => array(
            'MAX(Participant.participant_identifier) AS last_participant_identifier'
        )
    ));
    if (empty($lastParticipantIdentifier) || empty($lastParticipantIdentifier[0]['last_participant_identifier'])) {
        $lastParticipantIdentifier = 0;
    } else {
        $lastParticipantIdentifier = $lastParticipantIdentifier[0]['last_participant_identifier'];
    }
    $this->set('nextParticipantIdentifier', ($lastParticipantIdentifier + 1));
}