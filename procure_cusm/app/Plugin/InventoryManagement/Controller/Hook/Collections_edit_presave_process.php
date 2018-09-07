<?php
if ($collectionData['Collection']['procure_visit'] == 'Controls') {
    if ($this->request->data['Collection']['procure_visit'] != $collectionData['Collection']['procure_visit'] || $this->request->data['Collection']['collection_datetime']['year']) {
        $submittedDataValidates = false;
        $this->Collection->validationErrors['procure_visit'][] = 'control collection - no data can be updated';
    }
}