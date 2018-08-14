<?php

// Additional data
$this->EventMaster->addWritableField('procure_created_by_bank');
if (! $event_control_data['EventControl']['use_addgrid']) {
    $this->request->data['EventMaster']['procure_created_by_bank'] = Configure::read('procure_bank_id');
} else {
    $row_counter = 0;
    foreach ($this->request->data as &$data_unit) {
        $data_unit['EventMaster']['procure_created_by_bank'] = Configure::read('procure_bank_id');
    }
}
	