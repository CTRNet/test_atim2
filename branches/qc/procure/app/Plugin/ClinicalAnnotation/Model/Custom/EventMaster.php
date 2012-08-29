<?php

class EventMasterCustom extends EventMaster {
	var $useTable = 'event_masters';
	var $name = 'EventMaster';
	
	function summary( $variables=array() ) {
		$return = false;
	
		if ( isset($variables['EventMaster.id'])) {
				
			$result = $this->find('first', array('conditions'=>array('EventMaster.id'=>$variables['EventMaster.id'])));
				
			$return = array(
				'menu'			=>	array( NULL, __($result['EventControl']['event_type'], TRUE)),
				'title'			=>	array( NULL, __('annotation', TRUE) ),
				'data'				=> $result,
				'structure alias'	=> 'eventmasters'
			);
		}else if(isset($variables['EventControl.id'])){
			$return = array();
		}
	
		return $return;
	}
	
	function beforeValidate($options) {
		$result = parent::beforeValidate($options);	
			
		if(array_key_exists('followup_event_master_id', $this->data['EventDetail'])) {
			//F1-Followup PSA/Followup clinical event
			$tmp_res =$this->find('first', array('conditions' => array('EventMaster.id' => $this->data['EventDetail']['followup_event_master_id']), 'recursive' => '0'));
			$this->data['EventMaster']['procure_form_identification'] = empty($tmp_res)? 'n/a' : $tmp_res['EventMaster']['procure_form_identification'];
			$this->addWritableField(array('procure_form_identification'));
		
		} else if(array_key_exists('procure_form_identification', $this->data['EventMaster'])) {
			//Form identification validation
			$Participant = AppModel::getInstance("ClinicalAnnotation", "Participant", true);
			$error = $Participant->validateFormIdentification($this->data['EventMaster']['procure_form_identification'], 'EventMaster', $this->id);
			if($error) {
				$result = false;
				$this->validationErrors['procure_form_identification'][] = $error;
			}
					
		} else {
			AppController::getInstance()->redirect( '/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true );
		}
		
		return $result;
	}
	
	function afterSave($created){
			
		if(array_key_exists('tmp_launch_linked_event_update', $this->data['EventMaster']) && $this->data['EventMaster']['tmp_launch_linked_event_update']) {
			//Identification of follow-up form just has been updated
			$saved_event_master_id = $this->id;
			$saved_event_master_data = $this->data;
			$new_procure_form_identification = $this->data['EventMaster']['procure_form_identification'];		
			
			// Update identification of APS forms
			$joins = array(array(
				'alias' => 'EventDetail',
				'table' => 'procure_ed_clinical_followup_worksheet_aps',
				'conditions' => array('EventMaster.id = EventDetail.event_master_id'),
				'type' => 'INNER'
			));
			$conditions = array(
				"EventMaster.procure_form_identification <> '$new_procure_form_identification'",
				'EventMaster.deleted <> 1',
				'EventDetail.followup_event_master_id' => $saved_event_master_id
			);
			$aps_to_update = $this->find('all', array('conditions' => $conditions, 'joins' => $joins));
			foreach($aps_to_update as $new_aps) {				
				$data_to_update = array();
				$data_to_update['EventMaster']['procure_form_identification'] = "$new_procure_form_identification";
				
				$this->id = $new_aps['EventMaster']['id'];
				$this->data = null;
				$this->addWritableField(array('procure_form_identification'));
				if(!$this->save($data_to_update, false)) AppController::getInstance()->redirect( '/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true );
			}

			// Update identification of clinical event forms
			$joins = array(array(
					'alias' => 'EventDetail',
					'table' => 'procure_ed_clinical_followup_worksheet_clinical_events',
					'conditions' => array('EventMaster.id = EventDetail.event_master_id'),
					'type' => 'INNER'
			));
			$conditions = array(
					"EventMaster.procure_form_identification <> '$new_procure_form_identification'",
					'EventMaster.deleted <> 1',
					'EventDetail.followup_event_master_id' => $saved_event_master_id
			);
			$events_to_update = $this->find('all', array('conditions' => $conditions, 'joins' => $joins));
			foreach($events_to_update as $new_event) {
				$data_to_update = array();
				$data_to_update['EventMaster']['procure_form_identification'] = "$new_procure_form_identification";
			
				$this->id = $new_event['EventMaster']['id'];
				$this->data = null;
				$this->addWritableField(array('procure_form_identification'));
				if(!$this->save($data_to_update, false)) AppController::getInstance()->redirect( '/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true );
			}			
			
			// Update trt of clinical event forms
			$TreatmentMaster = AppModel::getInstance("ClinicalAnnotation", "TreatmentMaster", true);
			$joins = array(array(
					'alias' => 'TreatmentDetail',
					'table' => 'procure_txd_followup_worksheet_treatments',
					'conditions' => array('TreatmentMaster.id = TreatmentDetail.treatment_master_id'),
					'type' => 'INNER'
			));
			$conditions = array(
					"TreatmentMaster.procure_form_identification <> '$new_procure_form_identification'",
					'TreatmentMaster.deleted <> 1',
					'TreatmentDetail.followup_event_master_id' => $saved_event_master_id
			);
			$trts_to_update = $TreatmentMaster->find('all', array('conditions' => $conditions, 'joins' => $joins));
			foreach($trts_to_update as $new_trt) {
				$data_to_update = array();
				$data_to_update['TreatmentMaster']['procure_form_identification'] = "$new_procure_form_identification";
					
				$TreatmentMaster->id = $new_trt['TreatmentMaster']['id'];
				$TreatmentMaster->data = null;
				$TreatmentMaster->addWritableField(array('procure_form_identification'));
				if(!$TreatmentMaster->save($data_to_update, false)) AppController::getInstance()->redirect( '/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true );
			}			
			
			$this->id = $saved_event_master_id;
			$this->data = $saved_event_master_data;
		}
		
		parent::afterSave($created);
	}
	
	//TODO
	//after save si identification a changé, les changer tous
	//control pas de delection du suivi si lié a APS, trt, etc
	
	function getFollowupIdentificationFromId($participant_id) {
		$res = array('' => '');
		if($participant_id) {
			$tmp_res =$this->find('all', array('conditions' => array('EventControl.event_type' => 'procure follow-up worksheet', 'EventMaster.participant_id' => $participant_id), 'recursive' => '0'));
			foreach($tmp_res as $new_res) $res[$new_res['EventMaster']['id']] = $new_res['EventMaster']['procure_form_identification'].' ('.$new_res['EventMaster']['event_date'].')';
		}
		return $res;
	}
	
	
	function allowDeletion($event_master_id){
		//Linked followup-APS
		$joins = array(array(
				'alias' => 'EventDetail',
				'table' => 'procure_ed_clinical_followup_worksheet_aps',
				'conditions' => array('EventMaster.id = EventDetail.event_master_id'),
				'type' => 'INNER'
		));
		$conditions = array(
				'EventMaster.deleted <> 1',
				'EventDetail.followup_event_master_id' => $event_master_id
		);
		if($this->find('first', array('conditions' => $conditions, 'joins' => $joins))){
			return array('allow_deletion' => false, 'msg' => 'at least one APS or treatment or clinical event is linked to that followup form');
		}
		
		//Linked followup-clinical event
		$joins = array(array(
				'alias' => 'EventDetail',
				'table' => 'procure_ed_clinical_followup_worksheet_clinical_events',
				'conditions' => array('EventMaster.id = EventDetail.event_master_id'),
				'type' => 'INNER'
		));
		$conditions = array(
				'EventMaster.deleted <> 1',
				'EventDetail.followup_event_master_id' => $event_master_id
		);
		if($this->find('first', array('conditions' => $conditions, 'joins' => $joins))){
			return array('allow_deletion' => false, 'msg' => 'at least one APS or treatment or clinical event is linked to that followup form');
		}		

		//Linked followup-trt event
		$TreatmentMaster = AppModel::getInstance("ClinicalAnnotation", "TreatmentMaster", true);
		$joins = array(array(
				'alias' => 'TreatmentDetail',
				'table' => 'procure_txd_followup_worksheet_treatments',
				'conditions' => array('TreatmentMaster.id = TreatmentDetail.treatment_master_id'),
				'type' => 'INNER'
		));
		$conditions = array(
				'TreatmentMaster.deleted <> 1',
				'TreatmentDetail.followup_event_master_id' => $event_master_id
		);
		if($TreatmentMaster->find('first', array('conditions' => $conditions, 'joins' => $joins))){
			return array('allow_deletion' => false, 'msg' => 'at least one APS or treatment or clinical event is linked to that followup form');
		}
				
		return parent::allowDeletion($event_master_id);
	}
	
	
}

?>