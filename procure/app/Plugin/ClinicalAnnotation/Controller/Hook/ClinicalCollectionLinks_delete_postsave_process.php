<?php
if (! $this->Collection->atimDelete($collectionId, true)) {
    $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
}