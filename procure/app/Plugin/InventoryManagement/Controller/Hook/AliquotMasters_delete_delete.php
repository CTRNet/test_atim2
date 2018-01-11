<?php 
    
	if($arr_allow_deletion['allow_deletion']) {
        if($aliquot_data['SampleMaster']['procure_created_by_bank'] == 's' && $aliquot_data['AliquotMaster']['procure_created_by_bank'] != Configure::read('procure_bank_id')) {
			// ATiM Processing Site Data Check
            //===================================================
            // An aliquot of a sample created by system to migrate aliquot from ATiM-Processing site and defined as created by another bank 
            // than the bank of the ATiM used (aliquot previously transferred from bank to 'Processing Site' and now merged into ATiM used) 
            // can only be deleted when:
            // - no other aliquot is linked to this sample.
            // - no derivative is linked to this sample.
            // - no quality control is linked to this sample.
            // - no specimen review is linked to this sample.
            
    		$linked_recrods_nbr = 0;
			$sample_master_model = AppModel::getInstance("InventoryManagement", "SampleMaster", true);
			$returned_nbr = $this->SampleMaster->find('count', array('conditions' => array('SampleMaster.parent_id' => $aliquot_data['SampleMaster']['id']), 'recursive' => '-1'));
			$linked_recrods_nbr += $returned_nbr;
			$returned_nbr = $this->AliquotMaster->find('count', array('conditions' => array('AliquotMaster.sample_master_id' => $aliquot_data['SampleMaster']['id'], "AliquotMaster.id != $aliquot_master_id"), 'recursive' => '-1'));
			$linked_recrods_nbr += $returned_nbr;
			$quality_ctrl_model = AppModel::getInstance("InventoryManagement", "QualityCtrl", true);
			$returned_nbr = $quality_ctrl_model->find('count', array('conditions' => array('QualityCtrl.sample_master_id' => $aliquot_data['SampleMaster']['id']), 'recursive' => '-1'));
			$linked_recrods_nbr += $returned_nbr;
			$specimen_review_master_model = AppModel::getInstance("InventoryManagement", "SpecimenReviewMaster", true);
			$returned_nbr = $specimen_review_master_model->find('count', array('conditions' => array('SpecimenReviewMaster.sample_master_id' => $aliquot_data['SampleMaster']['id']), 'recursive' => '-1'));
			$linked_recrods_nbr += $returned_nbr;
			if($linked_recrods_nbr) {
				$arr_allow_deletion['allow_deletion'] = false;
				$arr_allow_deletion['msg'] = 'at least one data (aliquot, quality control, derivative) is linked to the sample created by the sysem for the migration of aliquots from the processing site - delete all records first';
			}
		}
	}
