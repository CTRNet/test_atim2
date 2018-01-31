<?php

// --------------------------------------------------------------------------------
// Generate default default_bank_number
// --------------------------------------------------------------------------------
$lastId = $this->Participant->find('first', array(
    'recursive' => -1,
    'fields' => array(
        'MAX(participant_identifier)'
    )
));
$defaultBankNumber = empty($lastId[0]['MAX(participant_identifier)']) ? 1 : $lastId[0]['MAX(participant_identifier)'] + 1;
$this->set('defaultBankNumber', $defaultBankNumber);