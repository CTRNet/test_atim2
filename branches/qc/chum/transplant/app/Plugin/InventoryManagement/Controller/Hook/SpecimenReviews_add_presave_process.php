<?php
if ($submittedDataValidates && $isAliquotReviewDefined) {
    // --------------------------------------------------------------------------------
    // Generate Reveiw Code
    // --------------------------------------------------------------------------------
    foreach ($aliquotReviewData as &$tmpNnewAliquotReviewToSave) {
        $tmpNnewAliquotReviewToSave['AliquotReviewMaster']['review_code'] = '-';
    }
    $this->AliquotReviewMaster->addWritableField('review_code');
}
