<?php

// --------------------------------------------------------------------------------
// Set default value
// --------------------------------------------------------------------------------
if (isset($defaultBank)) {
    $finalOptions['override']['Collection.bank_id'] = $defaultBank;
}