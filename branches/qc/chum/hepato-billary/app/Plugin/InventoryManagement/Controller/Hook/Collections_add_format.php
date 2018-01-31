<?php

// --------------------------------------------------------------------------------
// Set default value
// --------------------------------------------------------------------------------
if (! $needToSave && ! isset($this->request->data['Collection']['bank_id'])) {
    $this->request->data['Collection']['bank_id'] = 1;
    $this->request->data['Collection']['acquisition_label'] = (empty($collectionData) ? '??' : $collectionData['Participant']['participant_identifier']);
    $this->request->data['Collection']['collection_site'] = "saint-luc hospital";
}