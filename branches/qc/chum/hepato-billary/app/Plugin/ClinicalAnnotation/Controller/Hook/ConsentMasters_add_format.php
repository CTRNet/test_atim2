<?php

// --------------------------------------------------------------------------------
// Add default consent status
// --------------------------------------------------------------------------------
if (empty($this->request->data)) {
    $this->set('defaultConsentStatus', 'obtained');
}