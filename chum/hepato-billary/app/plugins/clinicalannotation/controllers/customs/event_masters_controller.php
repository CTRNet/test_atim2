<?php
/*
 * Created on 2009-11-26
 * Author NL
 *
 * Offer an example of code override.
 */
	 
class EventMastersControllerCustom extends EventMastersController {
 	
 	/** 
 	 * Calculate BMI value for clinical.hepatobiliary.presentation data
 	 * and add it to submitted event data.
 	 * 
 	 * @param $event_data Submitted event data
 	 * @param $event_group 
 	 * @param $disease_site 
 	 * @param $event_type 
 	 * 
 	 * @return Updated event data
 	 * */

 	function addBmiValue( $event_data, $event_group, $disease_site, $event_type ) { 
 		if(($event_group === 'clinical') 
 		&& ($disease_site === 'hepatobiliary') 
 		&& ($event_type === 'presentation') 
 		&& (isset($event_data['EventDetail']['weight'])) 
 		&& (isset($event_data['EventDetail']['height']))) {
			// Format 'numeric' value
			$event_data['EventDetail']['weight'] = str_replace(',', '.', $event_data['EventDetail']['weight']);
			$event_data['EventDetail']['height'] = str_replace(',', '.', $event_data['EventDetail']['height']);
			
			$weight = $event_data['EventDetail']['weight'];
			$height = $event_data['EventDetail']['height'];
			
			if(is_numeric($weight) && is_numeric($height) && (!empty($height))) {
				$event_data['EventDetail']['bmi'] =  pow(($weight/$height), 2);
			} 
		}
		
		return $event_data;	
 	}
 	
 	/** 
 	 * Add diseases precisions to hepatobiliary medical_past_history
 	 * */
 	function addMedicalHistDetail($event_group, $participant_id, $event_master_id, $disease_type) {
		if ((!$participant_id) || (!$event_group) || (!$event_master_id) || (!$disease_type)) { $this->redirect( '/pages/err_clin_funct_param_missing', NULL, TRUE ); }

		// MANAGE DATA

		$event_master_data = $this->EventMaster->find('first',array('conditions'=>array('EventMaster.id'=>$event_master_id, 'EventMaster.participant_id'=>$participant_id)));
		if (empty($event_master_data)) { $this->redirect( '/pages/err_clin_no_data', null, true ); }

		$event_type_title = $event_master_data['EventMaster']['disease_site'].'-'.$event_group.'-'.$event_master_data['EventMaster']['event_type'];
		$specific_event_type_list = array('hepatobiliary-clinical-medical_past_history');
		if(!in_array($event_type_title, $specific_event_type_list)) { $this->redirect( '/pages/err_clin_system_error', null, true ); }

		// load models
		App::import('Model', 'clinicalannotation.EventExtend');		
		$this->EventExtend = new EventExtend(false, 'ee_hepatobiliary_medical_past_history');
		
		App::import('Model', 'clinicalannotation.MedicalPastHistoryCtrl');		
		$this->MedicalPastHistoryCtrl = new MedicalPastHistoryCtrl();
			
		// Set data for disease type display
		$disease_types_list = array($disease_type => __($disease_type, true));
		$this->set('disease_types_list', $disease_types_list);

		// Set data for disease precision selection
		$fields = 'DISTINCT MedicalPastHistoryCtrl.disease_precision';
		$conditions = array('MedicalPastHistoryCtrl.disease_type'=>$disease_type);
		$orders = 'MedicalPastHistoryCtrl.display_order ASC';
		$tmp_disease_precisions = $this->MedicalPastHistoryCtrl->find('all', array('fields' => $fields, 'conditions'=> $conditions, 'oder'=> $orders));		
		
		$disease_precisions_list = array();
		foreach($tmp_disease_precisions as $new_precision) {
			$disease_precisions_list[$new_precision['MedicalPastHistoryCtrl']['disease_precision']] = __($new_precision['MedicalPastHistoryCtrl']['disease_precision'], true);
		}
		$this->set('disease_precisions_list', $disease_precisions_list);
					
		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		$this->set( 'atim_menu', $this->Menus->get('/'.$this->params['plugin'].'/'.$this->params['controller'].'/listall/'.$event_group) );
		
		$this->set( 'atim_menu_variables', array(
			'EventMaster.event_group'=>$event_group,
			'Participant.id'=>$participant_id,
			'EventMaster.id'=>$event_master_id,  
			'EventControl.id'=>$event_master_data['EventControl']['id'],
			'EventExtend.disease_type'=>$disease_type) );

		$this->Structures->set('ee_hepatobiliary_medical_past_history', 'event_extend_structure');
		
		if(empty($this->data)) {
			$this->data = array();
			$this->data['EventExtend']['disease_type'] = $disease_type;
			
		} else {
			// Launch save process
			$this->data['EventExtend']['event_master_id'] = $event_master_id;

			if ($this->EventExtend->save($this->data) ) {
				$this->flash( 'Your data has been saved','/clinicalannotation/event_masters/detail/'.$event_group.'/'.$participant_id.'/'.$event_master_id);
			}
		} 
 		
 	}
 	
 	/** 
 	 * Edit hepatobiliary medical_past_history disease precision.
 	 * */
 	function editMedicalHistDetail($event_group, $participant_id, $event_master_id, $event_extend_id) {
		if ((!$participant_id) || (!$event_group) || (!$event_master_id) || (!$event_extend_id)) { $this->redirect( '/pages/err_clin_funct_param_missing', NULL, TRUE ); }

		// MANAGE DATA
		
		$event_master_data = $this->EventMaster->find('first',array('conditions'=>array('EventMaster.id'=>$event_master_id, 'EventMaster.participant_id'=>$participant_id)));
		if (empty($event_master_data)) { $this->redirect( '/pages/err_clin_no_data', null, true ); }

		$event_type_title = $event_master_data['EventMaster']['disease_site'].'-'.$event_group.'-'.$event_master_data['EventMaster']['event_type'];
		$specific_event_type_list = array('hepatobiliary-clinical-medical_past_history');
		if(!in_array($event_type_title, $specific_event_type_list)) { $this->redirect( '/pages/err_clin_system_error', null, true ); }

		// load models
		App::import('Model', 'clinicalannotation.EventExtend');		
		$this->EventExtend = new EventExtend(false, 'ee_hepatobiliary_medical_past_history');
		
		App::import('Model', 'clinicalannotation.MedicalPastHistoryCtrl');		
		$this->MedicalPastHistoryCtrl = new MedicalPastHistoryCtrl();
			
		// Load data

		$disease_details = $this->EventExtend->find('first',array('conditions'=>array('EventExtend.id'=>$event_extend_id, 'EventExtend.event_master_id'=>$event_master_id)));
		if (empty($disease_details)) { $this->redirect( '/pages/err_clin_no_data', null, true ); }
		
		// Set data for disease type display
		$disease_type = $disease_details['EventExtend']['disease_type'];
		$disease_types_list = array($disease_type => __($disease_type, true));
		$this->set('disease_types_list', $disease_types_list);

		// Set data for disease precision selection
		$fields = 'DISTINCT MedicalPastHistoryCtrl.disease_precision';
		$conditions = array('MedicalPastHistoryCtrl.disease_type'=>$disease_type);
		$orders = 'MedicalPastHistoryCtrl.display_order ASC';
		$tmp_disease_precisions = $this->MedicalPastHistoryCtrl->find('all', array('fields' => $fields, 'conditions'=> $conditions, 'oder'=> $orders));		
		
		$disease_precisions_list = array();
		foreach($tmp_disease_precisions as $new_precision) {
			$disease_precisions_list[$new_precision['MedicalPastHistoryCtrl']['disease_precision']] = __($new_precision['MedicalPastHistoryCtrl']['disease_precision'], true);
		}
		$this->set('disease_precisions_list', $disease_precisions_list);
					
		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		$this->set( 'atim_menu', $this->Menus->get('/'.$this->params['plugin'].'/'.$this->params['controller'].'/listall/'.$event_group) );
		
		$this->set( 'atim_menu_variables', array(
			'EventMaster.event_group'=>$event_group,
			'Participant.id'=>$participant_id,
			'EventMaster.id'=>$event_master_id,  
			'EventControl.id'=>$event_master_data['EventControl']['id'],
			'EventExtend.id'=>$event_extend_id) );

		$this->Structures->set('ee_hepatobiliary_medical_past_history', 'event_extend_structure');
		
		if(empty($this->data)) {
			$this->data = $disease_details;
			
		} else {
			// Launch save process
			$this->EventExtend->id = $event_extend_id;
			if ($this->EventExtend->save($this->data) ) {
				$this->flash( 'Your data has been saved','/clinicalannotation/event_masters/detail/'.$event_group.'/'.$participant_id.'/'.$event_master_id);
			}
		}
 	}
 	 
 	/** 
 	 * Delete hepatobiliary medical_past_history disease precision.
 	 * */
 	function deleteMedicalHistDetail($event_group, $participant_id, $event_master_id, $event_extend_id) {
		if ((!$participant_id) || (!$event_group) || (!$event_master_id) || (!$event_extend_id)) { $this->redirect( '/pages/err_clin_funct_param_missing', NULL, TRUE ); }

		// MANAGE DATA
		
		$event_master_data = $this->EventMaster->find('first',array('conditions'=>array('EventMaster.id'=>$event_master_id, 'EventMaster.participant_id'=>$participant_id)));
		if (empty($event_master_data)) { $this->redirect( '/pages/err_clin_no_data', null, true ); }

		$event_type_title = $event_master_data['EventMaster']['disease_site'].'-'.$event_group.'-'.$event_master_data['EventMaster']['event_type'];
		$specific_event_type_list = array('hepatobiliary-clinical-medical_past_history');
		if(!in_array($event_type_title, $specific_event_type_list)) { $this->redirect( '/pages/err_clin_system_error', null, true ); }

		// load models
		App::import('Model', 'clinicalannotation.EventExtend');		
		$this->EventExtend = new EventExtend(false, 'ee_hepatobiliary_medical_past_history');

		// Load data
		$disease_details = $this->EventExtend->find('first',array('conditions'=>array('EventExtend.id'=>$event_extend_id, 'EventExtend.event_master_id'=>$event_master_id)));
		if (empty($disease_details)) { $this->redirect( '/pages/err_clin_no_data', null, true ); } 	
 		
 		// Delete data
		if ($this->EventExtend->atim_delete( $event_extend_id )) {
			$this->flash( 'your data has been deleted', '/clinicalannotation/event_masters/detail/'.$event_group.'/'.$participant_id.'/'.$event_master_id );
		} else {
			$this->flash( 'error deleting data - contact administrator', '/clinicalannotation/event_masters/detail/'.$event_group.'/'.$participant_id.'/'.$event_master_id );
		}
 	}
 	
}
	
?>
