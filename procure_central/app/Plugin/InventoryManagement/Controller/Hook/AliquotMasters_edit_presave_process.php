<?php
if ($aliquotData['AliquotMaster']['barcode'] != $this->request->data['AliquotMaster']['barcode'] || (isset($this->request->data['AliquotMaster']['aliquot_label']) && $aliquotData['AliquotMaster']['aliquot_label'] != $this->request->data['AliquotMaster']['aliquot_label'])) {
    $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
}