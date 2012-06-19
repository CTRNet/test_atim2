<?php

class EventMasterCustom extends EventMaster {
	var $useTable = 'event_masters';
	var $name = 'EventMaster';
	
	function validates($options = array()){
		$result = parent::validates($options);

		if($this->data['EventMaster']['tmp_event_detail_tablename'] == 'qc_tf_ed_psa') {
			if(!array_key_exists('first_biochemical_recurrence', $this->data['EventDetail'])) AppController::getInstance()->redirect( '/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true );
			
			if($this->data['EventDetail']['first_biochemical_recurrence'] && $this->data['EventMaster']['diagnosis_master_id']) {
				// Get all diagnoses linked to the same primary
				$diagnosis_model = AppModel::getInstance('ClinicalAnnotation', 'DiagnosisMaster', true);
				$all_linked_diagmosises_ids = $diagnosis_model->getAllTumorDiagnosesIds($this->data['EventMaster']['diagnosis_master_id']);
				
				// Search existing 	PSA linked to this cancer already flagged as first_biochemical_recurrence	
				$conditions = array(
					'EventMaster.event_control_id'=> $this->data['EventMaster']['tmp_event_control_id'],
					'EventMaster.diagnosis_master_id'=> $all_linked_diagmosises_ids, 
					'EventDetail.first_biochemical_recurrence'=> '1');
				if($this->id) $conditions[] = 'EventMaster.id != '.$this->id;			
				$joins = array(array(
				        'table' => $this->data['EventMaster']['tmp_event_detail_tablename'],
				        'alias' => 'EventDetail',
				        'type' => 'INNER',
				        'conditions'=> array('EventDetail.event_master_id = EventMaster.id')));
				$count = $this->find('count', array('conditions'=>$conditions, 'joins' => $joins));	
				
				if($count) {
					$this->validationErrors['first_biochemical_recurrence'][] = "a psa event has already been defined as first bcr for this cancer";
					$result = false;
				}
			}
		}
		
		unset($this->data['EventMaster']['tmp_event_control_id']);
		unset($this->data['EventMaster']['tmp_event_detail_tablename']);
		
		return $result;
	}

}

?>