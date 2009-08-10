<?php

class DiagnosesController extends ClinicalannotationAppController {

	var $uses = array(
		'Clinicalannotation.Diagnosis', 
		'Clinicalannotation.Participant',
		'Clinicalannotation.TreatmentMaster',
		'Clinicalannotation.EventMaster'
	);
	var $paginate = array('Diagnosis'=>array('limit'=>10,'order'=>'Diagnosis.dx_date')); 
	
	function listall( $participant_id=null ) {
		if ( !$participant_id ) { $this->redirect( '/pages/err_clin-ann_no_part_id', NULL, TRUE ); }
		
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id));
		$this->data = $this->paginate($this->Diagnosis,	array('Diagnosis.participant_id'=>$participant_id));
	}

	function detail( $participant_id=null, $diagnosis_id=null ) {
		if ( !$participant_id ) { $this->redirect( '/pages/err_clin-ann_no_part_id', NULL, TRUE ); }
		if ( !$diagnosis_id ) { $this->redirect( '/pages/err_clin-ann_no_diagnosis_id', NULL, TRUE ); }
		
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id, 'Diagnosis.id'=>$diagnosis_id) );
		$this->data = $this->Diagnosis->find('first',array('conditions'=>array('Diagnosis.id'=>$diagnosis_id)));
	}

	function add( $participant_id=null ) {
		if ( !$participant_id ) { $this->redirect( '/pages/err_clin-ann_no_part_id', NULL, TRUE ); }
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id));
		
		if ( !empty($this->data) ) {
			$this->data['Diagnosis']['participant_id'] = $participant_id;
			if ( $this->Diagnosis->save( $this->data ) ) {
				$this->flash( 'Your data has been saved.', '/clinicalannotation/diagnoses/detail/'.$participant_id.'/'.$this->Diagnosis->id );
			}
		}		
	}

	function edit( $participant_id=null, $diagnosis_id=null ) {
		if ( !$participant_id ) { $this->redirect( '/pages/err_clin-ann_no_part_id', NULL, TRUE ); }
		if ( !$diagnosis_id ) { $this->redirect( '/pages/err_clin-ann_no_diagnosis_id', NULL, TRUE ); }
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id, 'Diagnosis.id'=>$diagnosis_id));
		
		if ( !empty($this->data) ) {
			$this->Diagnosis->id = $diagnosis_id;
			if ( $this->Diagnosis->save($this->data) ) {
				$this->flash( 'Your data has been updated.','/clinicalannotation/diagnoses/detail/'.$participant_id.'/'.$diagnosis_id );
			}
		} else {
			$this->data = $this->Diagnosis->find('first',array('conditions'=>array('Diagnosis.id'=>$diagnosis_id)));
		}
	}

	function delete( $participant_id=null, $diagnosis_id=null ) {
		if ( !$participant_id ) { $this->redirect( '/pages/err_clin-ann_no_part_id', NULL, TRUE ); }
		if ( !$diagnosis_id ) { $this->redirect( '/pages/err_clin-ann_no_diagnosis_id', NULL, TRUE ); }
		
		$treatment_id = $this->TreatmentMaster->find('first', array('conditions'=>array('Treatment.diagnosis_id'=>$diagnosis_id, 'TreatmentMaster.deleted'=>0),'fields'=>array('TreatmentMaster.id'))); 
		$event_id = $this->Diagnosis->find('first', array('conditions'=>array('EventMaster.diagnosis_id'=>$diagnosis_id, 'Diagnosis.deleted'=>0),'fields'=>array('Diagnosis.id')));
		
		if( $treatment_id == NULL && $event_id == NULL ){
			if( $this->Diagnosis->del( $diagnosis_id ) ) {
				$this->flash( 'Your data has been deleted.', '/clinicalannotation/diagnoses/listall/'.$participant_id );
			} else {
				$this->flash( 'Your data has been deleted.', '/clinicalannotation/diagnoses/listall/'.$participant_id );
			}
		} else {
			$message = "Your data cannot be deleted because the following records exist: ";
			if( $treatment_id != NULL ){
				$message = $message."A treatment record exists, ";
			}
			if( $event_id != NULL ){
				$message = $message."A annotation record exists, ";
			}
			
			$message = substr($message, 0, -2);
			
			$this->flash( $message, '/clinicalannotation/diagnoses/details/'.$participant_id.'/'.$diagnosis_id.'/');
		}
	}

}
?>

