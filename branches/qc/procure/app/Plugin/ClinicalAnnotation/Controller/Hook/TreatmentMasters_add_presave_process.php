<?php
$this->TreatmentMaster->addWritableField('procure_created_by_bank');
if (! $tx_control_data['TreatmentControl']['use_addgrid']) {
    $this->request->data['TreatmentMaster']['procure_created_by_bank'] = Configure::read('procure_bank_id');
} else {
    foreach ($this->request->data as &$data_unit) {
        $data_unit['TreatmentMaster']['procure_created_by_bank'] = Configure::read('procure_bank_id');
    }
}
	