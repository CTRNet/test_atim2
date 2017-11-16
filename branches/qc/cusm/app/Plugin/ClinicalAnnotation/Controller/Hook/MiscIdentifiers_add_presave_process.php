<?php

/**
 * Hook :: Add hidden banks fields to the record.  
 *
 * @author Nicolas Luc
 *
 * @package ATiM CUSM
 */

// --------------------------------------------------------------------------------
// Set MiscIdentifier Bank Id Information
// --------------------------------------------------------------------------------
$this->request->data['MiscIdentifier']['cusm_bank_id'] = $controls['MiscIdentifierControl']['cusm_bank_id'];
$this->request->data['MiscIdentifier']['cusm_is_main_bank_participant_identifier'] = $controls['MiscIdentifierControl']['cusm_is_main_bank_participant_identifier'];
$this->MiscIdentifier->addWritableField(array(
    'cusm_bank_id',
    'cusm_is_main_bank_participant_identifier'
));
