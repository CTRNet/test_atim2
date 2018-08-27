<?php
$result = $this->StudySummary->find('first', array(
    'fields' => array(
        'StudySummary.qc_nd_code'
    ),
    'conditions' => array(
        'StudySummary.qc_nd_code REGEXP ' => date('Y') . '-[0-9]+$'
    ),
    'order' => array(
        'StudySummary.qc_nd_code DESC'
    )
));

$qcNdCodeSuffix = null;
if ($result) {
    // increment it
    $qcNdCodeSuffix = substr($result['StudySummary']['qc_nd_code'], 5) + 1;
} else {
    // first of the year
    $qcNdCodeSuffix = 1;
}
$this->StudySummary->addWritableField('qc_nd_code');
$this->request->data['StudySummary']['qc_nd_code'] = sprintf('%d-%03d', date('Y'), $qcNdCodeSuffix);