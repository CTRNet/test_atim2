<?php

// --------------------------------------------------------------------------------
// Generate default dose unit
// --------------------------------------------------------------------------------
if ($txExtendControlData['TreatmentExtendControl']['detail_form_alias'] == 'txe_chemos')
    $this->set('defaultUnit', 'mg');