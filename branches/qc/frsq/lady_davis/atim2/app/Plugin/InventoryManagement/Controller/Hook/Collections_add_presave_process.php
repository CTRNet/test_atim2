<?php
if (! empty($this->request->data['Collection']['qc_lady_specimen_type_precision'])) {
    $this->Collection->addWritableField(array(
        'qc_lady_specimen_type'
    ));
    $qcLadySpecimenTypePrecision = $this->request->data['Collection']['qc_lady_specimen_type_precision'];
    $this->request->data['Collection']['qc_lady_specimen_type'] = substr($qcLadySpecimenTypePrecision, 0, strpos($qcLadySpecimenTypePrecision, '||'));
}