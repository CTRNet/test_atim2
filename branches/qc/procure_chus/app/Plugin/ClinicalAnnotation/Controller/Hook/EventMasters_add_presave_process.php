<?php

// Additional data
$this->EventMaster->addWritableField('procure_created_by_bank');
if (! $eventControlData['EventControl']['use_addgrid']) {
    $this->request->data['EventMaster']['procure_created_by_bank'] = Configure::read('procure_bank_id');
} else {
    $rowCounter = 0;
    foreach ($this->request->data as &$dataUnit) {
        $dataUnit['EventMaster']['procure_created_by_bank'] = Configure::read('procure_bank_id');
    }
}