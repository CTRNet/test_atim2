<?php

// Manage warnings
ksort($procureChronologyWarnings);
foreach ($procureChronologyWarnings as $procureTmp1) {
    foreach ($procureTmp1 as $procureTmp2) {
        AppController::addWarningMsg($procureTmp2);
    }
}