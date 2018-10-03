<?php

// --------------------------------------------------------------------------------
// Set default value
// --------------------------------------------------------------------------------
if (isset($defaultLanguage)) {
    $finalOptions['override']['Participant.language_preferred'] = $defaultLanguage;
}
if (isset($defaultSex)) {
    $finalOptions['override']['Participant.sex'] = $defaultSex;
}