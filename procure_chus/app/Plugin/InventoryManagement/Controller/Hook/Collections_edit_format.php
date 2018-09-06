<?php
if ($collectionData['Collection']['procure_visit'] == 'Controls') {
    AppController::addWarningMsg(__('control collection - no data can be updated'));
}