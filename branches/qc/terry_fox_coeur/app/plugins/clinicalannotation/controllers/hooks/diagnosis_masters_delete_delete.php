<?php
	
	// --------------------------------------------------------------------------------
	// Delete check
	// -------------------------------------------------------------------------------- 
	if(($dx_control_data['DiagnosisControl']['controls_type'] == 'EOC') || ($dx_control_data['DiagnosisControl']['controls_type'] == 'other primary cancer')) {
		$group_records_count = $this->DiagnosisMaster->find('count',array('conditions'=>array('DiagnosisMaster.primary_number'=>$diagnosis_master_data['DiagnosisMaster']['primary_number'], 'DiagnosisMaster.participant_id'=>$participant_id)));
		if($group_records_count != 1) {
			$arr_allow_deletion['allow_deletion'] = false;
			$arr_allow_deletion['msg'] = 'progression are currently linked to this primary';
		}
	}

?>