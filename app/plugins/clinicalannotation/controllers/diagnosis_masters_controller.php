<?php

class DiagnosisMastersController extends ClinicalannotationAppController {

	var $uses = array(
		'Clinicalannotation.DiagnosisMaster', 
		'Clinicalannotation.DiagnosisDetail',
		'Clinicalannotation.DiagnosisControl',
		'Clinicalannotation.Participant',
		'Clinicalannotation.TreatmentMaster',
		'Clinicalannotation.EventMaster'
	);
	var $paginate = array('DiagnosisMaster'=>array('limit'=>10,'order'=>'DiagnosisMaster.dx_date')); 
	
	function listall( $participant_id=null ) {
		if ( !$participant_id ) { $this->redirect( '/pages/err_clin-ann_no_part_id', NULL, TRUE ); }
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id));
		$this->set('diagnosis_controls_list', $this->DiagnosisControl->find('all', array('conditions' => array('DiagnosisControl.status' => 'active'))));
		$this->data = $this->paginate($this->DiagnosisMaster,	array('DiagnosisMaster.participant_id'=>$participant_id));
		
		//$storage_data = $this->DiagnosisControl->find('first', array('conditions' => array('DiagnosisControl.id' => 1)));
		//$this->set('atim_structure', $this->Structures->get('form', $storage_data['DiagnosisControl']['form_alias']));		
	}

	function detail( $participant_id=null, $diagnosis_id=null) {
		if ( !$participant_id ) { $this->redirect( '/pages/err_clin-ann_no_part_id', NULL, TRUE ); }
		if ( !$diagnosis_id ) { $this->redirect( '/pages/err_clin-ann_no_diagnosis_id', NULL, TRUE ); }
	
		
		$storage_data = $this->DiagnosisMaster->find('first',array('conditions'=>array('DiagnosisMaster.id'=>$diagnosis_id)));
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id, 'DiagnosisMaster.id'=>$diagnosis_id, 'DiagnosisMaster.diagnosis_control_id' => $storage_data['DiagnosisMaster']['diagnosis_control_id']) );

		$storage_data = $this->DiagnosisControl->find('first', array('conditions' => array('DiagnosisControl.id' => $storage_data['DiagnosisMaster']['diagnosis_control_id'])));
		$this->set('atim_structure', $this->Structures->get('form', $storage_data['DiagnosisControl']['form_alias']));
		
		$this->data = $this->DiagnosisMaster->find('first',array('conditions'=>array('DiagnosisMaster.id'=>$diagnosis_id)));
		
	}

	function add( $participant_id=null, $table_id=null ) {
		if ( !$participant_id ) { $this->redirect( '/pages/err_clin-ann_no_part_id', NULL, TRUE ); }
		if(!$table_id){ $this->redirect( '/pages/err_missing_param', NULL, TRUE ); }
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id, "tableId"=>$table_id));

		$storage_data = $this->DiagnosisControl->find('first', array('conditions' => array('DiagnosisControl.id' => $table_id)));
		$this->set('atim_structure', $this->Structures->get('form', $storage_data['DiagnosisControl']['form_alias']));

		if ( !empty($this->data) ) {
			$this->data['DiagnosisMaster']['participant_id'] = $participant_id;
			$this->data['DiagnosisMaster']['diagnosis_control_id'] = $table_id;
			$this->data['DiagnosisMaster']['type'] = $storage_data['DiagnosisControl']['controls_type']; 
			if ( $this->DiagnosisMaster->save( $this->data )) {
				$this->flash( 'Your data has been saved.', '/clinicalannotation/diagnosis_masters/detail/'.$participant_id.'/'.$this->DiagnosisMaster->id.'/' );
			}
		}
	}

	function edit( $participant_id=null, $diagnosis_id=null) {
		if ( !$participant_id ) { $this->redirect( '/pages/err_clin-ann_no_part_id', NULL, TRUE ); }
		if ( !$diagnosis_id ) { $this->redirect( '/pages/err_clin-ann_no_diagnosis_id', NULL, TRUE ); }

		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id, 'DiagnosisMaster.id'=>$diagnosis_id));
		
		$storage_data = $this->DiagnosisMaster->find('first',array('conditions'=>array('DiagnosisMaster.id'=>$diagnosis_id)));
		$storage_data = $this->DiagnosisControl->find('first', array('conditions' => array('DiagnosisControl.id' => $storage_data['DiagnosisMaster']['diagnosis_control_id'])));
		$this->set('atim_structure', $this->Structures->get('form', $storage_data['DiagnosisControl']['form_alias']));
		
		if ( !empty($this->data) ) {
			$this->DiagnosisMaster->id = $diagnosis_id;
			if ( $this->DiagnosisMaster->save($this->data) ) {
				$this->flash( 'Your data has been updated.','/clinicalannotation/diagnosis_masters/detail/'.$participant_id.'/'.$diagnosis_id );
			}
		} else {
			$this->data = $this->DiagnosisMaster->find('first',array('conditions'=>array('DiagnosisMaster.id'=>$diagnosis_id)));
		}
	}

	function delete( $participant_id=null, $diagnosis_id=null ) {
		if ( !$participant_id ) { $this->redirect( '/pages/err_clin-ann_no_part_id', NULL, TRUE ); }
		if ( !$diagnosis_id ) { $this->redirect( '/pages/err_clin-ann_no_diagnosis_id', NULL, TRUE ); }
		
		$treatment_id = $this->TreatmentMaster->find('first', array('conditions'=>array('TreatmentMaster.diagnosis_id'=>$diagnosis_id, 'TreatmentMaster.deleted'=>0),'fields'=>array('TreatmentMaster.id'))); 
		$event_id = $this->EventMaster->find('first', array('conditions'=>array('EventMaster.diagnosis_id'=>$diagnosis_id, 'EventMaster.deleted'=>0),'fields'=>array('EventMaster.id')));
		//$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id, 'DiagnosisMaster.id'=>$diagnosis_id));

		if( $treatment_id == NULL && $event_id == NULL ){
			if( $this->DiagnosisMaster->atim_delete( $diagnosis_id ) ) {
				$this->flash( 'Your data has been deleted.', '/clinicalannotation/diagnosis_masters/listall/'.$participant_id );
			} else {
				$this->flash( 'Error deleting data - Contact administrator.', '/clinicalannotation/diagnosis_masters/listall/'.$participant_id );
			}
		} else {
			$message = "Your data cannot be deleted because the following records exist: ";
			if( $treatment_id != NULL ){
				$message = $message."A treatment record exists, ";
			}
			if( $event_id != NULL ){
				$message = $message."An annotation record exists, ";
			}
			
			$message = substr($message, 0, -2);
			
			$this->flash( $message, '/clinicalannotation/diagnosis_masters/details/'.$participant_id.'/'.$diagnosis_id.'/');
		}
	}
}
?>
