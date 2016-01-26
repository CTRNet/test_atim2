<?php 

	//Note there is no interest to add control for CENTRAL BANK because data will be erased
	if($arr_allow_deletion['allow_deletion']) {
		if(Configure::read('procure_atim_version') != 'BANK') {
			if($aliquot_data['AliquotMaster']['procure_created_by_bank'] != 'p' && $aliquot_data['SampleMaster']['procure_created_by_bank'] != 'p'){
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
					$arr_allow_deletion['msg'] = 'at least one data is linked to the sample of the aliquot - delete all records then delete the aliquot of the sample';
				}
			}
		}
	}
