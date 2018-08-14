<?php

// ATiM Processing Site Data Check
// ===================================================
// A path review can only be created for a sample created by system to migrate aliquot from ATiM-Processing site when at least one aliquot
// exists for this sample into the ATiM used (this one is the aliquot previously transferred from bank different than PS3 to 'Processing Site'
// and now merged into the ATiM of PS3).
if ($sampleData['SampleMaster']['procure_created_by_bank'] == 's') {
    $tmpAliquotsCount = $this->AliquotMaster->find('count', array(
        'conditions' => array(
            'AliquotMaster.sample_master_id' => $sampleData['SampleMaster']['id']
        )
    ));
    if (! $tmpAliquotsCount) {
        $this->atimFlashError(__('no specimen review can be created from sample created by system/script to migrate data from the processing site with no aliquot'), "/InventoryManagement/SpecimenReviews/listAll/$collectionId/$sampleMasterId/", 5);
        return;
    }
}