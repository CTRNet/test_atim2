<?php

// Manage warnings
ksort($procure_chronology_warnings);
foreach ($procure_chronology_warnings as $procure_tmp1) {
    foreach ($procure_tmp1 as $procure_tmp2) {
        AppController::addWarningMsg($procure_tmp2);
    }
}




    