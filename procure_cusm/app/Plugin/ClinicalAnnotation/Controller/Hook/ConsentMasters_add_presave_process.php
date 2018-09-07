<?php
$this->request->data['ConsentMaster']['procure_created_by_bank'] = Configure::read('procure_bank_id');
$this->ConsentMaster->addWritableField(array(
    'procure_created_by_bank'
));