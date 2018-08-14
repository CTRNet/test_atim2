<?php
foreach ($qcDataToSave as &$procureNewData)
    $procureNewData['QualityCtrl']['procure_created_by_bank'] = Configure::read('procure_bank_id');
$this->QualityCtrl->addWritableField(array(
    'procure_created_by_bank'
));