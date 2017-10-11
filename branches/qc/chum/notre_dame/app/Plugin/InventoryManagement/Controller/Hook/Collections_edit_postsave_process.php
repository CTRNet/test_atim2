<?php
if ($collectionData['Collection']['bank_id'] != $this->request->data['Collection']['bank_id']) {
    $this->Collection->updateCollectionSampleLabels($collectionId);
}