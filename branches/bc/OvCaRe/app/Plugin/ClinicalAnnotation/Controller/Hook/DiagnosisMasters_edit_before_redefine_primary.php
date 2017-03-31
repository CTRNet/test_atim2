<?php
//***********************************************************************************************************************
//TODO Ying Request To Validate
//***********************************************************************************************************************
// When user is changing the unknown diagnosis to a defined diagnosis, the system cheks the types of the 
// path reports linked to this unknown diagnosis to be compatible with the new diagnosis type selected.
//***********************************************************************************************************************
// if($redefined_primary_control_id) {
// 	$new_primary_ctrl = $this->DiagnosisControl->find('first', array('conditions' => array('DiagnosisControl.id' => $redefined_primary_control_id)));
// 	if(!(empty($new_primary_ctrl) 
// 	|| ($dx_master_data['DiagnosisControl']['category'] != 'primary')
// 	|| ($dx_master_data['DiagnosisControl']['controls_type'] != 'primary diagnosis unknown')
// 	|| ($new_primary_ctrl['DiagnosisControl']['category'] != 'primary')
// 	|| ($new_primary_ctrl['DiagnosisControl']['controls_type'] == 'primary diagnosis unknown'))) {
// 		$ovcare_uncompatible_path_report = '';
// 		switch($new_primary_ctrl['DiagnosisControl']['controls_type']) {
// 			case 'ovary or endometrium tumor':
// 				$ovcare_uncompatible_path_report = 'other path report';
// 				break;
// 			case 'other':
// 				$ovcare_uncompatible_path_report = 'ovary or endometrium path report';
// 				break;
// 			default:
// 				$this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
// 		}
// 		$ovcare_uncompatible_path_report_nbr = $this->EventMaster->find('count',array('conditions'=>array('EventMaster.diagnosis_master_id'=>$diagnosis_master_id, 'EventControl.event_group' => 'clinical', 'EventControl.event_type' => $ovcare_uncompatible_path_report), 'fields' => array()));
// 		if($ovcare_uncompatible_path_report_nbr) {
// 			$this->flash(str_replace('%s', __($ovcare_uncompatible_path_report), __("at least one '%s' path report is linked to this unknown diagnosis and can not be linked to this new type of diagnosis")), 'javascript:history.back();');
// 			$redefined_primary_control_id = null;
// 		}
// 	}
// 	$new_primary_ctrl = null;
// }
//***********************************************************************************************************************
//TODO END Ying Request To Validate
//***********************************************************************************************************************
?>