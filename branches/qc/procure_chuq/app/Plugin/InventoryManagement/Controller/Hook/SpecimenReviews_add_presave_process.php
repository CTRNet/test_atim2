<?php
$specimenReviewData['SpecimenReviewMaster']['procure_created_by_bank'] = Configure::read('procure_bank_id');
$this->SpecimenReviewMaster->addWritableField(array(
    'procure_created_by_bank'
));

foreach ($aliquotReviewData as &$procureNewAliquotReviewToSave) {
    $procureNewAliquotReviewToSave['AliquotReviewMaster']['procure_created_by_bank'] = Configure::read('procure_bank_id');
}
$this->AliquotReviewMaster->addWritableField(array(
    'procure_created_by_bank'
));