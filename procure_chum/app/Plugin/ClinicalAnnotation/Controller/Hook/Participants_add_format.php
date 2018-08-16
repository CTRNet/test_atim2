<?php

// Set default values
$bankIdentification = $this->Participant->getBankParticipantIdentification();
$lastId = $this->Participant->find('first', array(
    'conditions' => array(
        "participant_identifier LIKE '$bankIdentification%'"
    ),
    'fields' => array(
        " MAX(CAST(REPLACE(`participant_identifier`, '$bankIdentification', '') AS UNSIGNED)) AS max_val"
    ),
    'recursive' => -1
));
$newId = empty($lastId[0]['max_val']) ? '001' : $lastId[0]['max_val'] + 1;
$zeroToAdd = 3 - strlen($newId);
if ($zeroToAdd > 0) {
    for ($i = 0; $i < $zeroToAdd; $i ++)
        $newId = '0' . $newId;
}
$defaultParticipantIdentifier = $bankIdentification . $newId;
$this->set('defaultParticipantIdentifier', $defaultParticipantIdentifier);

$this->set('defaultProcureTransferredParticipant', 'n');