<?php
$this->TreatmentMaster->addWritableField('procure_created_by_bank');
if (! $txControlData['TreatmentControl']['use_addgrid']) {
    $this->request->data['TreatmentMaster']['procure_created_by_bank'] = Configure::read('procure_bank_id');
} else {
    foreach ($this->request->data as &$dataUnit) {
        $dataUnit['TreatmentMaster']['procure_created_by_bank'] = Configure::read('procure_bank_id');
    }
}