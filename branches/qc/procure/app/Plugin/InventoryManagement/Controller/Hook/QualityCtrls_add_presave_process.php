<?php
foreach ($qc_data_to_save as &$procure_new_data)
    $procure_new_data['QualityCtrl']['procure_created_by_bank'] = Configure::read('procure_bank_id');
$this->QualityCtrl->addWritableField(array(
    'procure_created_by_bank'
));
	