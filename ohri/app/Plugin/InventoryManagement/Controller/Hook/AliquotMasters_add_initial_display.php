<?php

// --------------------------------------------------------------------------------
// Set Default Aliquot Data
// --------------------------------------------------------------------------------
foreach ($this->request->data as $key => $newSample) {
    $initalData = $this->AliquotMaster->getDefaultLabel($newSample['parent']['ViewSample'], $aliquotControlId);
    if (! empty($initalData)) {
        $this->request->data[$key]['children'] = $initalData;
    }
}