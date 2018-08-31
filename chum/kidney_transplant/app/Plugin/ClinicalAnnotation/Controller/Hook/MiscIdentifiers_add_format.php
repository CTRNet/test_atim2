<?php
// --------------------------------------------------------------------------------
// Set next kidney bank identifier
// --------------------------------------------------------------------------------
if (empty($this->request->data) && $displayAddForm) {
    if (in_array($controls['MiscIdentifierControl']['misc_identifier_name'], array(
        'kidney transplant bank no lab',
        'other kidney transplant bank no lab'
    ))) {
        $controls['MiscIdentifier']['identifier_value'] = $this->MiscIdentifier->getNextKidneyMiscIdentifierNumber();
    }
}