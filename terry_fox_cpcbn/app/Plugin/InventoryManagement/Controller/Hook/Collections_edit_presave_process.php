<?php
if (isset($this->request->data['Collection']['collection_property']) && $collectionData['Collection']['collection_property'] != $this->request->data['Collection']['collection_property']) {
    $this->redirect('/Pages/err_plugin_system_error?method=Collection.edit(),line=' . __LINE__, null, true);
}