<?php

// --------------------------------------------------------------------------------
// Generate default sequence number based on collection visit label
// --------------------------------------------------------------------------------
if (isset($defaultSequenceNumber)) {
    $finalOptions['override']['SpecimenDetail.sequence_number'] = $defaultSequenceNumber;
}