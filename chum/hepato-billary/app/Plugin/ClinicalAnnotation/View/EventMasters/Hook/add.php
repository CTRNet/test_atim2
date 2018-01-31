<?php

// --------------------------------------------------------------------------------
// hepatobiliary-lab-biology :
// Set participant surgeries list for hepatobiliary-lab-biology.
// --------------------------------------------------------------------------------
if (isset($surgeriesForLabReport))
    $finalOptions['dropdown_options']['EventDetail.surgery_tx_master_id'] = $surgeriesForLabReport;