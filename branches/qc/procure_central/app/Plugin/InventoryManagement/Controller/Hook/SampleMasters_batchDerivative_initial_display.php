<?php

// ATiM Processing Site Data Check
// ===================================================
// Sample created by system to migrate aliquot from ATiM-Processing site can be used as parent sample when at least one aliquot exists for this sample into the ATiM
// used (this one is the aliquot previously transferred from bank different than PS3 to 'Processing Site' and now merged into the ATiM of PS3).
if (isset($this->request->data[0]['parent']['AliquotMaster'])) {
    // All samples are linked to aliquot
} else {
    // Check
    $dataSetNbrInError = array();
    $tmpRecordCounter = 0;
    foreach ($this->request->data as $tmpProcureNewDataSet) {
        $tmpRecordCounter ++;
        if ($tmpProcureNewDataSet['parent']['ViewSample']['procure_created_by_bank'] == 's') {
            $tmpAliquotsCount = $this->AliquotMaster->find('count', array(
                'conditions' => array(
                    'AliquotMaster.sample_master_id' => $tmpProcureNewDataSet['parent']['ViewSample']['sample_master_id']
                )
            ));
            if (! $tmpAliquotsCount) {
                $dataSetNbrInError[] = $tmpRecordCounter;
            }
        }
    }
    if ($dataSetNbrInError) {
        $this->atimFlashError(__('no derivative can be created from sample created by system/script to migrate data from the processing site with no aliquot') . ' ' . str_replace('%s', '[' . implode('] ,[', $dataSetNbrInError) . ']', __('see # %s')), $urlToCancel);
        return;
    }
}