<?php
$result = $this->StudySummary->find('first', array(
    'fields' => array(
        'StudySummary.qc_hb_code'
    ),
    'conditions' => array(
        'StudySummary.qc_hb_code REGEXP ' => '^'.date('Y') . '\-[0-9]+\-HBP$'
    ),
    'order' => array(
        'StudySummary.qc_hb_code DESC'
    )
));
$qcNdCodeSuffix = null;
if ($result) {
    // increment it
    $qcNdCodeSuffix = substr($result['StudySummary']['qc_hb_code'], 5, 3) + 1;
} else {
    // first of the year
    $qcNdCodeSuffix = 1;
}
$this->StudySummary->addWritableField('qc_hb_code');
$this->request->data['StudySummary']['qc_hb_code'] = sprintf('%d-%03d', date('Y'), $qcNdCodeSuffix).'-HBP';