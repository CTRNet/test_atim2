<?php

class ParticipantCustom extends Participant {
	var $useTable = 'participants';
	var $name = 'Participant';
	var $bank_identification = 'PS3P0';
	
	function summary($variables=array()){
		$return = false;
	
		if ( isset($variables['Participant.id']) ) {
			$result = $this->find('first', array('conditions'=>array('Participant.id'=>$variables['Participant.id'])));
			
			$MiscIdentifier = AppModel::getInstance("ClinicalAnnotation", "MiscIdentifier", true);
			$identifiers = $MiscIdentifier->find('all', array('conditions' => array('MiscIdentifier.participant_id' => $result['Participant']['id'])));
			$result[0] = array('RAMQ' => '', 'hospital_number' => '');
			foreach($identifiers as $new_id) $result['0'][str_replace(' ', '_',$new_id['MiscIdentifierControl']['misc_identifier_name'])] = $new_id['MiscIdentifier']['identifier_value'];
			
			$return = array(
					'menu'				=>	array( NULL, ($result['Participant']['participant_identifier']) ),
					'title'				=>	array( NULL, ($result['Participant']['participant_identifier']) ),
					'structure alias' 	=> 'participants,procure_miscidentifiers_for_participant_summary',
					'data'				=> $result
			);
		}
	
		return $return;
	}
	
	function beforeValidate($options = Array()) {
		$result = parent::beforeValidate($options);	
		if(isset($this->data['Participant']['participant_identifier']) && !preg_match("/^($this->bank_identification)([0-9]+)$/", $this->data['Participant']['participant_identifier'], $matches)) {
			$result = false;
			$this->validationErrors['participant_identifier'][] = "the identification format is wrong";
		}
		return $result;
	}
	
	function buildAddProcureFormsButton($participant_id) {
		$add_links = array(__('quick procure collection creation button') => array('link'=> '/ClinicalAnnotation/ClinicalCollectionLinks/add/'.$participant_id, 'icon' => 'collection'));
		
		$consent_model = AppModel::getInstance("ClinicalAnnotation", "ConsentControl", true);
		$consent_controls_list = $consent_model->find('all', array('conditions' => array('flag_active' => '1')));
		foreach ($consent_controls_list as $consent_control) {
			$add_links[__($consent_control['ConsentControl']['controls_type'])] = array('link'=> '/ClinicalAnnotation/ConsentMasters/add/'.$participant_id.'/'.$consent_control['ConsentControl']['id'].'/', 'icon' => 'participant');
		}
		
		$event_model = AppModel::getInstance("ClinicalAnnotation", "EventControl", true);
		$event_controls_list = $event_model->find('all', array('conditions' => array('flag_active' => '1')));
		foreach ($event_controls_list as $event_ctrl) {
			$add_links[__($event_ctrl['EventControl']['event_type'])] = array('link'=> '/ClinicalAnnotation/EventMasters/add/'.$participant_id.'/'.$event_ctrl['EventControl']['id'].'/', 'icon' => 'participant');
		}	
		
		$tx_model = AppModel::getInstance("ClinicalAnnotation", "TreatmentControl", true);
		$tx_controls_list = $tx_model->find('all', array('conditions' => array('flag_active' => '1')));
		foreach ($tx_controls_list as $treatment_control) {
			$add_links[__($treatment_control['TreatmentControl']['tx_method'])] = array('link'=> '/ClinicalAnnotation/TreatmentMasters/add/'.$participant_id.'/'.$treatment_control['TreatmentControl']['id'].'/', 'icon' => 'participant');
		}		

		ksort($add_links);	
		
		return $add_links;
	}
	
	function validateFormIdentification($procure_form_identification, $model, $id, $control_id = null) {
		$pattern_suffix = null;
		$main_worksheet = true;
		switch($model) {
			case 'ConsentMaster':
				$pattern_suffix = "CSF";
				break;
				
			case 'EventMaster':
				if($id) {
					$EventMaster = AppModel::getInstance("ClinicalAnnotation", "EventMaster", true);
					$studied_event = $EventMaster->find('first', array('conditions' => array('EventMaster.id' => $id), 'recursive' => '0'));
					$event_type = $studied_event['EventControl']['event_type'];
				} else if($control_id) {
					$EventControl = AppModel::getInstance("ClinicalAnnotation", "EventControl", true);
					$studied_event_control = $EventControl->find('first', array('conditions' => array('id' => $control_id), 'recursive' => '0'));
					$event_type = $studied_event_control['EventControl']['event_type'];
				}
				$pattern_suffix_suffix = '';
				switch($event_type) {
					case 'procure pathology report':
						$pattern_suffix = "PST";
						break;
					case 'procure diagnostic information worksheet':
						$pattern_suffix = "FBP";
						break;
					case 'procure questionnaire administration worksheet':
						$pattern_suffix = "QUE";
						break;
					case 'procure follow-up worksheet':
						$pattern_suffix = "FSP";
						break;
					case 'procure follow-up worksheet - aps':
					case 'procure follow-up worksheet - clinical event':
						$pattern_suffix = "FSP";
						$main_worksheet = false;
						break;
					default:
						AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
				}
				break;
				
			case 'TreatmentMaster':
				if($id) {
					$TreatmentMaster = AppModel::getInstance("ClinicalAnnotation", "TreatmentMaster", true);
					$studied_treatment = $TreatmentMaster->find('first', array('conditions' => array('TreatmentMaster.id' => $id), 'recursive' => '0'));
					$tx_method = $studied_treatment['TreatmentControl']['tx_method'];
				} else if($control_id) {
					$TreatmentControl = AppModel::getInstance("ClinicalAnnotation", "TreatmentControl", true);
					$studied_treatment_control = $TreatmentControl->find('first', array('conditions' => array('id' => $control_id), 'recursive' => '0'));
					$tx_method = $studied_treatment_control['TreatmentControl']['tx_method'];
				} else {
					AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
				}
				switch($tx_method) {
					case 'procure medication worksheet':
						$pattern_suffix = "MED";
						break;
					case 'procure follow-up worksheet - treatment':
						$pattern_suffix = "FSP";
						$main_worksheet = false;
						break;
					case 'procure medication worksheet - drug':
						$pattern_suffix = "MED";
						$main_worksheet = false;
						break;
					case 'other tumor treatment': 
						if(preg_match("/^PS[0-9]P0[0-9]+ N\/A$/", $procure_form_identification)) {
							return false;
						} else {
							return __("the identification format is wrong")." (PS0P0000 N/A)";
						}
						break;
					default:
						AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);		
				}
		}
		if(empty($pattern_suffix)) AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);		
		//Check Format
		if($main_worksheet) {
			if(!preg_match("/^PS[0-9]P0[0-9]+ V((0[1-9])|(1[0-9])) -".$pattern_suffix."[0-9]+$/", $procure_form_identification)) return __("the identification format is wrong")." (PS0P0000 V00 -".$pattern_suffix."0)";
		} else {
			if(!preg_match("/^PS[0-9]P0[0-9]+ Vx -".$pattern_suffix."x$/", $procure_form_identification)) return __("the identification format is wrong")." (PS0P0000 Vx -".$pattern_suffix."x)";
		}
		//Check Unique
		if($main_worksheet) {
			switch($model) {
				case 'EventMaster':
					$EventMaster = AppModel::getInstance("ClinicalAnnotation", "EventMaster", true);
					$conditions = array('EventMaster.procure_form_identification' => $procure_form_identification);
					if($id && $model == 'EventMaster') $conditions[] = 'EventMaster.id != '. $id;
					$dup = $EventMaster->find('count', array('conditions' => $conditions, 'recursive' => '0'));
					if($dup) return __("the identification value should be unique");;
					break;
				case 'ConsentMaster':
					$ConsentMaster = AppModel::getInstance("ClinicalAnnotation", "ConsentMaster", true);
					$conditions = array('ConsentMaster.procure_form_identification' => $procure_form_identification);
					if($id && $model == 'ConsentMaster') $conditions[] = 'ConsentMaster.id != '. $id;
					$dup = $ConsentMaster->find('count', array('conditions' => $conditions, 'recursive' => '0'));
					if($dup) return __("the identification value should be unique");
					break;
				case 'TreatmentMaster':
					$TreatmentMaster = AppModel::getInstance("ClinicalAnnotation", "TreatmentMaster", true);
					$conditions = array('TreatmentMaster.procure_form_identification' => $procure_form_identification);
					if($id && $model == 'TreatmentMaster') $conditions[] = 'TreatmentMaster.id != '. $id;
					$dup = $TreatmentMaster->find('count', array('conditions' => $conditions, 'recursive' => '0'));
					if($dup) return __("the identification value should be unique");;
					break;
				default:
					AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
			}
		}
		//All is ok
		return false;
	}
}

?>