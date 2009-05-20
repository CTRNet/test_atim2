<?php

class DiagnosesController extends ClinicalannotationAppController {

	var $uses = array('Diagnosis', 'Participant');
	var $paginate = array('Diagnosis'=>array('limit'=>10,'order'=>'Diagnosis.dx_date')); 
	
	function listall( $participant_id=null ) {
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id));
		$this->data = $this->paginate($this->Diagnosis,	array('Diagnosis.participant_id'=>$participant_id));
	}

	function detail( $participant_id=null, $diagnosis_id=null ) {
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id, 'Diagnosis.id'=>$diagnosis_id) );
		$this->data = $this->Diagnosis->find('first',array('conditions'=>array('Diagnosis.id'=>$diagnosis_id)));
	}

	function add( $participant_id=null ) {
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id));
		
		if ( !empty($this->data) ) {
			$this->data['Diagnosis']['participant_id'] = $participant_id;
			if ( $this->Diagnosis->save( $this->data ) ) {
				$this->flash( 'Your data has been saved.', '/clinicalannotation/diagnoses/detail/'.$participant_id.'/'.$this->Diagnosis->id );
			}
			
		}		
	}

	function edit( $participant_id=null, $diagnosis_id=null ) {
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
		if( $this->Diagnosis->del( $diagnosis_id ) ) {
			$this->flash( 'Your data has been deleted.', '/clinicalannotation/diagnoses/listall/'.$participant_id );
		}
		else {
			$this->flash( 'Your data has been deleted.', '/clinicalannotation/diagnoses/listall/'.$participant_id );
		}
	}

}
?>

