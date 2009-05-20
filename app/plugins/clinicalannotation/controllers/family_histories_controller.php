<?php

class FamilyHistoriesController extends ClinicalAnnotationAppController {
	
	var $uses = array('FamilyHistory','Participant');
	var $paginate = array('FamilyHistory'=>array('limit'=>10,'order'=>'FamilyHistory.relation'));
	
	function listall( $participant_id=null ) {
		if ( !$participant_id ) { $this->redirect( '/pages/err_clin-ann_no_part_id', NULL, TRUE ); }

		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id));
		$this->data = $this->paginate($this->FamilyHistory, array('FamilyHistory.participant_id'=>$participant_id));
	}
	
	function detail( $participant_id=null, $family_history_id=null ) {
		if ( !$participant_id ) { $this->redirect( '/pages/err_clin-ann_no_part_id', NULL, TRUE ); }
		if ( !$family_history_id ) { $this->redirect( '/pages/err_clin-ann_no_part_id', NULL, TRUE ); }
		
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id, 'FamilyHistory.id'=>$family_history_id) );
		$this->data = $this->FamilyHistory->find('first',array('conditions'=>array('FamilyHistory.id'=>$family_history_id)));
	}
	
	function add( $participant_id=null ) {
		if ( !$participant_id ) { $this->redirect( '/pages/err_clin-ann_no_part_id', NULL, TRUE ); }
	
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id));
		
		if ( !empty($this->data) ) {
			$this->data['FamilyHistory']['participant_id'] = $participant_id;
			if ( $this->FamilyHistory->save($this->data) ) {
				$this->flash( 'Your data has been updated.','/clinicalannotation/family_histories/detail/'.$participant_id.'/'.$this->FamilyHistory->id );
			}
		}
	}
	
	function edit( $participant_id=null, $family_history_id=null) {
		if ( !$participant_id ) { $this->redirect( '/pages/err_clin-ann_no_part_id', NULL, TRUE ); }
		if ( !$family_history_id ) { $this->redirect( '/pages/err_clin-ann_no_part_id', NULL, TRUE ); }
		
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id, 'FamilyHistory.id'=>$family_history_id) );
		
		if ( !empty($this->data) ) {
			$this->FamilyHistory->id = $family_history_id;
			if ( $this->FamilyHistory->save($this->data) ) {
				$this->flash( 'Your data has been updated.','/clinicalannotation/family_histories/detail/'.$participant_id.'/'.$family_history_id );
			}
		} else {
			$this->data = $this->FamilyHistory->find('first',array('conditions'=>array('FamilyHistory.id'=>$family_history_id)));
		}
	}
	
	function delete( $participant_id=null, $family_history_id=null ) {
		if ( !$participant_id ) { $this->redirect( '/pages/err_clin-ann_no_part_id', NULL, TRUE ); }
		if ( !$family_history_id ) { $this->redirect( '/pages/err_clin-ann_no_part_id', NULL, TRUE ); }
		
		if( $this->FamilyHistory->del( $family_history_id ) ) {
			$this->flash( 'Your data has been deleted.', '/clinicalannotation/family_histories/listall/'.$participant_id );
		} else {
			$this->flash( 'Your data has been deleted.', '/clinicalannotation/family_histories/listall/'.$participant_id );
		}
	}
	
}

?>