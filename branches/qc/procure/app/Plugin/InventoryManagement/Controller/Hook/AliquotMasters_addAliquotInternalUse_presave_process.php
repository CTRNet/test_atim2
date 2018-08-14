<?php
foreach ($uses_to_save as &$procure_new_data)
    $procure_new_data['AliquotInternalUse']['procure_created_by_bank'] = Configure::read('procure_bank_id');
$this->AliquotInternalUse->addWritableField(array(
    'procure_created_by_bank'
));
	