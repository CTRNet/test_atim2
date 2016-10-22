<?php 
	//================================================================================================================================================================
	// Diagnosis & treatment reminder :
	//  - Only one breast primary diagnosis can be created per participant.
	//  - A 'breast diagnostic event' treatment can only be created for a breast primary diagnosis.
	//  - A 'breast progression' can only be created for a breast primary diagnosis.
	//  - So all 'breast diagnostic event' and 'breast progression' of one participant will be linked to the same breast primary diagnosis.
	//================================================================================================================================================================

	switch($dx_control_data['DiagnosisControl']['controls_type']) {
		case 'breast':
			if($this->DiagnosisMaster->find('count', array('conditions' => array('DiagnosisControl.controls_type' => 'breast', 'DiagnosisMaster.participant_id' => $participant_id)))) {
				$this->flash(__('you can not create a breast diagnosis twice'), 'javascript:history.back();');
			}
			break;
		case 'breast progression':
			if(!$parent_dx)  $this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true); 
			if($parent_dx['DiagnosisControl']['controls_type'] != 'breast') {
				$this->flash(__('you can not link this type of secondary diagnosis to the selected primary'), 'javascript:history.back();');
			}
			break;
		case 'other cancer':
			break;
		case 'other cancer progression':
			if(!$parent_dx)  $this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true); 
			if($parent_dx['DiagnosisControl']['controls_type'] != 'other cancer') {
				$this->flash(__('you can not link this type of secondary diagnosis to the selected primary'), 'javascript:history.back();');
			}
			break;
		default:
			$this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
	}
