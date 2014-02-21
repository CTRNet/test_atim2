<?php

class TreatmentMasterCustom extends TreatmentMaster {
	
	var $useTable = 'treatment_masters';
	var $name = 'TreatmentMaster';

	function summary( $variables=array() ) {
		$return = false;
		
		if ( isset($variables['TreatmentMaster.id']) ) {
			$result = $this->find('first', array('conditions'=>array('TreatmentMaster.id'=>$variables['TreatmentMaster.id'])));
			$return = array(
				'menu'    			=> array( NULL, __($result['TreatmentControl']['disease_site'], TRUE) . ' - ' . __($result['TreatmentControl']['tx_method'], TRUE)),
				'title'	 			=> array( NULL, __($result['TreatmentControl']['disease_site'], TRUE)  . ' - ' . __($result['TreatmentControl']['tx_method'], TRUE)),
				'structure alias'	=> $result['TreatmentControl']['form_alias'],
				'data'				=> $result
			);
		}
		
		return $return;
	}
	
	function updateAllSurvivalTimes($participant_id, $treatment_master_id = null) {
		
		//Get Participant Data
		$participant_model = AppModel::getInstance("ClinicalAnnotation", "Participant", true);
		$participant_data = $participant_model->find('first', array('conditions' => array ('Participant.id' => $participant_id), 'recursive' => '-1'));		
		if(empty($participant_data)) AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		
		//Get Surgeries
		$conditions =  array (
			'TreatmentMaster.participant_id' => $participant_id,
			'TreatmentControl.tx_method' => 'surgery'
		);
		if($treatment_master_id) $conditions['TreatmentMaster.id'] = $treatment_master_id;
		$participant_surgeries = $this->find('all', array('conditions' => $conditions, 'recursive' => '0'));		
		
		//Update Survival Times
		foreach($participant_surgeries as $new_surgery) {
			if(array_key_exists('survival_time_in_months', $new_surgery['TreatmentDetail'])) {
				$last_news_date = $participant_data['Participant']['last_news_date'];
				$last_news_date_accuracy = $participant_data['Participant']['last_news_date_accuracy'];
				$surgery_id = $new_surgery['TreatmentMaster']['id'];
				$surgery_date = $new_surgery['TreatmentMaster']['start_date'];
				$surgery_date_accuracy = $new_surgery['TreatmentMaster']['start_date_accuracy'];
				$old_survival_time_in_months = $new_surgery['TreatmentDetail']['survival_time_in_months'];
				$new_survival_time_in_months = '';
				if($surgery_date && $last_news_date) {
					if(in_array($surgery_date_accuracy, array('y','m')) || in_array($last_news_date_accuracy, array('y','m'))) {
						AppController::addWarningMsg(str_replace('%field%', __('survival time in months',true), __('the dates accuracy is not sufficient: the field [%%field%%] can not be generated', true)));
					} else {
						$SurgeryDateObj = new DateTime($surgery_date);
						$LastNewsDateObj = new DateTime($last_news_date);
						$interval = $SurgeryDateObj->diff($LastNewsDateObj);
						if($interval->invert) {
							AppController::addWarningMsg(str_replace('%field%', __('survival time in months',true), __('error in the dates definitions: the field [%%field%%] can not be generated', true)));
						} else {
							$new_survival_time_in_months = $interval->y*12 + $interval->m;
						}
					}
				}				
				if((is_null($old_survival_time_in_months) && !is_null($new_survival_time_in_months)) || ($old_survival_time_in_months != $new_survival_time_in_months)) {					
					$new_tr_data = array();
					$new_tr_data['TreatmentMaster']['id'] = $surgery_id;
					$new_tr_data['TreatmentDetail']['survival_time_in_months'] = $new_survival_time_in_months;
					$this->data = array();
					$this->id = $surgery_id;
					$this->addWritableField(array('survival_time_in_months'));
					if(!$this->save($new_tr_data, false)) AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);	
				}
			}
		}
	}
	
	function inactivatePreOperativeDataMenu($atim_menu, $detail_tablename) {
		if(!in_array($detail_tablename, array('qc_hb_txd_surgery_livers','qc_hb_txd_surgery_pancreas'))) {
			foreach($atim_menu as $menu_group_id => $menu_group) {
				foreach($menu_group as $menu_id => $menu_data) {
					if(strpos($menu_data['Menu']['use_link'], '/ClinicalAnnotation/TreatmentMasters/preOperativeDetail') !== false) {
						$atim_menu[$menu_group_id][$menu_id]['Menu']['allowed'] = 0;
						return $atim_menu;
					}
				}
			}
			
		}
		return $atim_menu;
	}
	
	function allowDeletion($tx_master_id){
		$res = parent::allowDeletion($tx_master_id);
		if($res['allow_deletion']){
			if($tx_master_id != $this->id){
				//not the same, fetch
				$data = $this->findById($tx_master_id);
			}else{
				$data = $this->data;
			}
			$participant_id = $data['TreatmentMaster']['participant_id'];
			if(!$participant_id) AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
			$EventControl = AppModel::getInstance('ClinicalAnnotation', 'EventControl', true);
			$studied_event_control_ids = $EventControl->find('list', array('conditions' => array('EventControl.detail_tablename' => 'qc_hb_ed_hepatobilary_lab_report_biologies', 'EventControl.flag_active' => '1'), 'fields' => array('EventControl.id')));
			$EventMaster = AppModel::getInstance('ClinicalAnnotation', 'EventMaster', true);
			$linked_lab_report_biologies = $EventMaster->find('all', array('conditions' => array('EventMaster.event_control_id' => $studied_event_control_ids, 'EventMaster.participant_id' => $participant_id)));
			$linked_to_event = false;
			foreach($linked_lab_report_biologies as $new_one) {
				if($new_one['EventDetail']['surgery_tx_master_id'] == $tx_master_id) $linked_to_event = true;
			}
			if($linked_to_event) $res = array('allow_deletion' => false, 'msg' => 'at least one biology lab report is linked to this treatment');		
		} 
		return $res;
	}

}

?>