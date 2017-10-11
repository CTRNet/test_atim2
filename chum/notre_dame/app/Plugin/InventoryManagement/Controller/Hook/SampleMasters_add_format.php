<?php

// --------------------------------------------------------------------------------
// Generate default sequence number based on collection visit label
// --------------------------------------------------------------------------------
if (empty($this->data) && (strcmp($sampleControlData['SampleControl']['sample_category'], 'specimen') == 0)) {
    $tmpCollectionData = $this->Collection->find('first', array(
        'conditions' => array(
            'Collection.id' => $collectionId
        ),
        'recursive' => -1
    ));
    if (empty($tmpCollectionData))
        $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
    
    if (preg_match('/^V[0]([0-9]*)$/', $tmpCollectionData['Collection']['visit_label'], $res)) {
        $this->set('defaultSequenceNumber', $res[1]);
    }
}