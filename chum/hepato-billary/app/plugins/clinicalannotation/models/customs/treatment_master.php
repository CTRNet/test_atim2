<?php

class TreatmentMasterCustom extends TreatmentMaster {
	
	var $useTable = 'treatment_masters';
	var $name = 'TreatmentMaster';

	function summary( $variables=array() ) {
		$return = false;
		
		if ( isset($variables['TreatmentMaster.id']) ) {
			
			$result = $this->find('first', array('conditions'=>array('TreatmentMaster.id'=>$variables['TreatmentMaster.id'])));
			
			$precision = isset($variables['TreatmentExtend.menu_precision'])? ' - ' . __($variables['TreatmentExtend.menu_precision'], null): '';
			
			$return = array(
				'menu'    			=> array( NULL, __($result['TreatmentControl']['disease_site'], TRUE) . ' - ' . __($result['TreatmentControl']['tx_method'], TRUE) . $precision),
				'title'	 			=> array( NULL, __($result['TreatmentControl']['disease_site'], TRUE)  . ' - ' . __($result['TreatmentControl']['tx_method'], TRUE)),
				'structure alias'	=> $result['TreatmentControl']['form_alias'],
				'data'				=> $result
			);
		}
		
		return $return;
	}
	
	function beforeSave($options) {
		
		if(array_key_exists('start_date', $this->data['TreatmentMaster'])) { 
			// User just clicked on submit button of Treatment form : Treatment is being created or updated
			
			$participant_id	= null;		
			$previous_treatment_data =  array();
			$tx_control_data = array();	
			if(array_key_exists('participant_id', $this->data['TreatmentMaster'])) {
				// Treatment is being created
				$participant_id	= $this->data['TreatmentMaster']['participant_id'];	
				$tx_control_model = AppModel::getInstance("Clinicalannotation", "TreatmentControl", true);
				$tx_control_data = $tx_control_model->find('first', array('conditions' => array ('TreatmentControl.id' => $this->data['TreatmentMaster']['treatment_control_id'])));				
			} else {
				// Treatment is being updated
				$previous_treatment_data = $this->find('first', array('conditions' => array('TreatmentMaster.id' => $this->id), 'recursive' => '0'));
				if(empty($previous_treatment_data)) AppController::getInstance()->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
				$participant_id = $previous_treatment_data['TreatmentMaster']['participant_id'];	
				$tx_control_data['TreatmentControl'] = $previous_treatment_data['TreatmentControl'];				
			}
			if(empty($tx_control_data)) AppController::getInstance()->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);	

			if($tx_control_data['TreatmentControl']['tx_method'] == 'surgery') {	
				
				// *** SET AGE AT SURGERY ***
					
				$previous_surgery_date = empty($previous_treatment_data)? null: $previous_treatment_data['TreatmentMaster']['start_date'];
				$previous_surgery_date_accuracy = empty($previous_treatment_data)? null: $previous_treatment_data['TreatmentMaster']['start_date_accuracy'];
				
				$surgery_date = $this->data['TreatmentMaster']['start_date'];
				$surgery_date_accuracy = $this->data['TreatmentMaster']['start_date_accuracy'];
				
				if(empty($previous_surgery_date) || (($surgery_date.$surgery_date_accuracy) != ($previous_surgery_date.$previous_surgery_date_accuracy))) {
					$participant_model = AppModel::getInstance("Clinicalannotation", "Participant", true);
					$participant_data = $participant_model->find('first', array('conditions' => array ('Participant.id' => $participant_id), 'recursive' => '-1'));
					if(empty($participant_data)) AppController::getInstance()->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
					
					$last_news_date = $participant_data['Participant']['last_news_date'];
					$last_news_date_accuracy = $participant_data['Participant']['last_news_date_accuracy'];
	
					$this->data['TreatmentDetail']['survival_time_in_months'] = $this->getSurvivalTimeInMonth($surgery_date, $surgery_date_accuracy, $last_news_date, $last_news_date_accuracy);
				}
			}
		}
					
		return true;
	}
	
	function updateAllSurvivalTimes($participant_id) {
		$participant_model = AppModel::getInstance("Clinicalannotation", "Participant", true);
		$participant_data = $participant_model->find('first', array('conditions' => array ('Participant.id' => $participant_id), 'recursive' => '-1'));		
		if(empty($participant_data)) AppController::getInstance()->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		$last_news_date = $participant_data['Participant']['last_news_date'];
		$last_news_date_accuracy = $participant_data['Participant']['last_news_date_accuracy'];
		
		$conditions =  array (
			'TreatmentMaster.participant_id' => $participant_id,
			'TreatmentControl.tx_method' => 'surgery',
			"TreatmentMaster.start_date != ''",
			"TreatmentMaster.start_date IS NOT NULL"		
		);
		$participant_surgeries = $this->find('all', array('conditions' => $conditions, 'recursive' => '0'));

		foreach($participant_surgeries as $new_trt) {
			$surgery_id = $new_trt['TreatmentMaster']['id'];
			$surgery_date = $new_trt['TreatmentMaster']['start_date'];
			$surgery_date_accuracy = $new_trt['TreatmentMaster']['start_date_accuracy'];

			$new_tr_data = array();
			$new_tr_data['TreatmentMaster']['id'] = $surgery_id;
			$new_tr_data['TreatmentDetail']['survival_time_in_months'] = $this->getSurvivalTimeInMonth($surgery_date, $surgery_date_accuracy, $last_news_date, $last_news_date_accuracy);
			$this->id = null;
			$this->data = array();
			if(!$this->save($new_tr_data, false)) AppController::getInstance()->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		}
	}
	
	
	function getSurvivalTimeInMonth($surgery_date, $surgery_date_accuracy, $last_news_date, $last_news_date_accuracy) {
		if(empty($surgery_date) || empty($last_news_date)) return '';
		
		if(in_array($surgery_date_accuracy, array('y','m')) || in_array($last_news_date_accuracy, array('y','m'))) {
			AppController::addWarningMsg(str_replace('%%field%%', __('survival time in months',true), __('the dates accuracy is not sufficient: the field [%%field%%] can not be generated', true)));
			return '';
		}
		
		$arr_surgery_date = array_combine(array('year','month','day'), explode('-', $surgery_date));
		$arr_last_news_date = array_combine(array('year','month','day'), explode('-', $last_news_date));
				
		$survival_time_months = ($arr_last_news_date['year'] - $arr_surgery_date['year']) * 12;
		if($survival_time_months >= 0) {
			$survival_time_months = $survival_time_months + ($arr_last_news_date['month'] - $arr_surgery_date['month']);
			if(in_array($surgery_date_accuracy, array('c')) && in_array($last_news_date_accuracy, array('c'))) {
				if($survival_time_months >= 0) {
					if($arr_surgery_date['day'] > $arr_last_news_date['day']) { $survival_time_months = $survival_time_months - 1; }
				}
			}
		}
		
		if($survival_time_months < 0) {
			AppController::addWarningMsg(str_replace('%%field%%', __('survival time in months',true), __('error in the dates definitions: the field [%%field%%] can not be generated', true)));
			$survival_time_months = '';			
		}
		
		return $survival_time_months;	
	}
	
	function allowDeletion($tx_master_id){

		if($tx_master_id != $this->id){
			//not the same, fetch
			$data = $this->findById($tx_master_id);
		}else{
			$data = $this->data;
		}
		$treatment_extend_model = new TreatmentExtend( false, $data['TreatmentControl']['extend_tablename']);
		$nbr_extends = $treatment_extend_model->find('count', array('conditions'=>array('TreatmentExtend.tx_master_id'=>$tx_master_id), 'recursive' => '-1'));
		if ($nbr_extends > 0) { 
			return array('allow_deletion' => false, 'msg' => 'at least one drug is defined as treatment component'); 
		}		
		
		if(!isset($this->EventDetail)) {
			App::import("Model", "Clinicalannotation.EventDetail");	
		}
		$this->EventDetail = new EventDetail(false, 'qc_hb_ed_hepatobilary_lab_report_biologies');
		
		$nbr = $this->EventDetail->find('count', array('conditions' => array('EventDetail.surgery_tx_master_id' => $tx_master_id)));
		if ($nbr > 0) { 
			return array('allow_deletion' => false, 'msg' => 'at least one biology lab report is linked to this treatment'); 
		}
				
		return array('allow_deletion' => true, 'msg' => '');
	}

}

?>