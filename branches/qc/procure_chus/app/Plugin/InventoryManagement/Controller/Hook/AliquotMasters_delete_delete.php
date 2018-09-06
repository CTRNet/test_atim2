<?php
if ($arrAllowDeletion['allow_deletion']) {
    if ($aliquotData['SampleMaster']['procure_created_by_bank'] == 's' && $aliquotData['AliquotMaster']['procure_created_by_bank'] != Configure::read('procure_bank_id')) {
        // ATiM Processing Site Data Check
        // ===================================================
        // An aliquot of a sample created by system to migrate aliquot from ATiM-Processing site and defined as created by another bank
        // than the bank of the ATiM used (aliquot previously transferred from bank to 'Processing Site' and now merged into ATiM used)
        // can only be deleted when:
        // - no other aliquot is linked to this sample.
        // - no derivative is linked to this sample.
        // - no quality control is linked to this sample.
        // - no specimen review is linked to this sample.
        
        $linkedRecrodsNbr = 0;
        $sampleMasterModel = AppModel::getInstance("InventoryManagement", "SampleMaster", true);
        $returnedNbr = $this->SampleMaster->find('count', array(
            'conditions' => array(
                'SampleMaster.parent_id' => $aliquotData['SampleMaster']['id']
            ),
            'recursive' => -1
        ));
        $linkedRecrodsNbr += $returnedNbr;
        $returnedNbr = $this->AliquotMaster->find('count', array(
            'conditions' => array(
                'AliquotMaster.sample_master_id' => $aliquotData['SampleMaster']['id'],
                "AliquotMaster.id != $aliquotMasterId"
            ),
            'recursive' => -1
        ));
        $linkedRecrodsNbr += $returnedNbr;
        $qualityCtrlModel = AppModel::getInstance("InventoryManagement", "QualityCtrl", true);
        $returnedNbr = $qualityCtrlModel->find('count', array(
            'conditions' => array(
                'QualityCtrl.sample_master_id' => $aliquotData['SampleMaster']['id']
            ),
            'recursive' => -1
        ));
        $linkedRecrodsNbr += $returnedNbr;
        $specimenReviewMasterModel = AppModel::getInstance("InventoryManagement", "SpecimenReviewMaster", true);
        $returnedNbr = $specimenReviewMasterModel->find('count', array(
            'conditions' => array(
                'SpecimenReviewMaster.sample_master_id' => $aliquotData['SampleMaster']['id']
            ),
            'recursive' => -1
        ));
        $linkedRecrodsNbr += $returnedNbr;
        if ($linkedRecrodsNbr) {
            $arrAllowDeletion['allow_deletion'] = false;
            $arrAllowDeletion['msg'] = 'at least one data (aliquot, quality control, derivative) is linked to the sample created by the sysem for the migration of aliquots from the processing site - delete all records first';
        }
    }
}