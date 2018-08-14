<?php
if (($collectionData && ! $collectionData['Collection']['participant_id']) || (! $collectionData && ! isset($this->request->data['Collection']['participant_id']))) {
    $submittedDataValidates = false;
    $this->Collection->validationErrors['participant_id'][] = __('a created collection should be linked to a participant');
}

$this->request->data['Collection']['procure_collected_by_bank'] = Configure::read('procure_bank_id');
$this->Collection->addWritableField(array(
    'procure_collected_by_bank'
));