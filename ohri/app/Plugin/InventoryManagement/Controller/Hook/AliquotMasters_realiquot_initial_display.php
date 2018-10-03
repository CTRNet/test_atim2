<?php

// --------------------------------------------------------------------------------
// Set Default Aliquot Data
// --------------------------------------------------------------------------------
foreach ($this->request->data as $key => $newParent) {
    $this->request->data[$key]['children'][0]['AliquotMaster']['aliquot_label'] = preg_replace('/([1-9]+)$/', '?', $newParent['parent']['AliquotMaster']['aliquot_label']);
}