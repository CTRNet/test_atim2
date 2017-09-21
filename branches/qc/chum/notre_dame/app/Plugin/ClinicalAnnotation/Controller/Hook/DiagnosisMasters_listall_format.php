<?php
if ($parent_dx_id != null) {
    $atim_structure['DiagnosisMaster'] = $this->Structures->get('form', 'qc_nd_view_progressions');
    $this->set('atim_structure', $atim_structure);
}