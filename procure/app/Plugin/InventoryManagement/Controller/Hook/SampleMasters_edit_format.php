<?php
// Sample From ATiM Processing Site Check
// ===================================================
// Sample created by system to migrate aliquot from ATiM-Processing site can not be be edited.
if ($sampleData['SampleMaster']['procure_created_by_bank'] == 's') {
    $this->atimFlashError(__('a sample created by system/script to migrate data from the processing site can not be edited'), "/InventoryManagement/SampleMasters/detail/$collectionId/$sampleMasterId", 5);
    return;
}