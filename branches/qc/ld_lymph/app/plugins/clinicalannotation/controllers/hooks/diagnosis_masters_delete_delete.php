<?php
		
	if($diagnosis_master_data['DiagnosisMaster']['dx_origin'] == 'primary') {
		$nbr_of_grp_diagnoses = $this->DiagnosisMaster->find('count', array('conditions'=>array('DiagnosisMaster.primary_number' => $diagnosis_master_data['DiagnosisMaster']['primary_number'], 'DiagnosisMaster.participant_id'=>$participant_id)));
		if($nbr_of_grp_diagnoses != 1) {
			$arr_allow_deletion['allow_deletion'] = false;
			$arr_allow_deletion['msg'] = 'all progression of the group should be deleted frist';
		}
	}
	
?>
