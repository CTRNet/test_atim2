<?php

// Set default values
$controlParticipantIdentifiers = $this->Participant->find('list', array(
    'fields' => array(
        "Participant.participant_identifier"
    ),
    'conditions' => array(
        'Participant.qc_tf_is_control' => 'y'
    ),
    'recursive' => -1
));
$lastId = $this->Participant->find('first', array(
    'fields' => array(
        " MAX(participant_identifier) AS max_val"
    ),
    'conditions' => array(
        'Participant.qc_tf_is_control' => 'n'
    ),
    'recursive' => -1
));
$nextParticipantIdentifier = empty($lastId[0]['max_val']) ? '1' : $lastId[0]['max_val'] + 1;
while (in_array($nextParticipantIdentifier, $controlParticipantIdentifiers)) {
    $nextParticipantIdentifier ++;
}
$this->set('defaultParticipantIdentifier', $nextParticipantIdentifier);