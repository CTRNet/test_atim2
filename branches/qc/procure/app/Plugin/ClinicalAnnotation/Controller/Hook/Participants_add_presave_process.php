<?php
$this->request->data['Participant']['procure_last_modification_by_bank'] = Configure::read('procure_bank_id');
$this->Participant->addWritableField(array(
    'procure_last_modification_by_bank'
));