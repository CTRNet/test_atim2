<?php

// --------------------------------------------------------------------------------
// Generate default dose unit
// --------------------------------------------------------------------------------
if ($tx_extend_control_data['TreatmentExtendControl']['detail_form_alias'] == 'txe_chemos')
    $this->set('default_unit', 'mg');