<?php
if ($aliquotControl['AliquotControl']['databrowser_label'] == 'pbmc|tube') {
    AppController::addWarningMsg(__('procure warning for date of pbmc initial storage'));
    AppController::addWarningMsg(__('procure warning for storage of pbmc'));
}