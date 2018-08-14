<?php
foreach ($usesToSave as &$procureNewData)
    $procureNewData['AliquotInternalUse']['procure_created_by_bank'] = Configure::read('procure_bank_id');
$this->AliquotInternalUse->addWritableField(array(
    'procure_created_by_bank'
));