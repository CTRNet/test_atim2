<?php
if ($parentDxId != null) {
    $atimStructure['DiagnosisMaster'] = $this->Structures->get('form', 'qc_nd_view_progressions');
    $this->set('atimStructure', $atimStructure);
}