<?php

// --------------------------------------------------------------------------------
// Add default consent status
// --------------------------------------------------------------------------------
if (isset($defaultConsentStatus)) {
    $finalOptions['override']['ConsentMaster.consent_status'] = $defaultConsentStatus;
}