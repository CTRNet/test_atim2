<?php

class ReproductiveHistoriesController extends ClinicalAnnotationAppController {
	
	var $uses = array('Clinicalannotation.ReproductiveHistory','Clinicalannotation.Participant');
	var $paginate = array('ReproductiveHistory'=>array('limit'=>10,'order'=>'ReproductiveHistory.date_captured'));
	
	function listall( $participant_id ) {
		if ( !$participant_id ) { $this->redirect( '/pages/err_clin-ann_no_part_id', NULL, TRUE ); }

		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id));
		$this->data = $this->paginate($this->ReproductiveHistory, array('ReproductiveHistory.participant_id'=>$participant_id));
	}
	
	function detail( $participant_id, $reproductive_history_id ) {
		if ( !$participant_id ) { $this->redirect( '/pages/err_clin-ann_no_part_id', NULL, TRUE ); }
		if ( !$reproductive_history_id ) { $this->redirect( '/pages/err_clin-ann_no_reprod_id', NULL, TRUE ); }
		
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id, 'ReproductiveHistory.id'=>$reproductive_history_id) );
		$this->data = $this->ReproductiveHistory->find('first',array('conditions'=>array('ReproductiveHistory.id'=>$reproductive_history_id)));
	}
	
	function add( $participant_id ) {
		if ( !$participant_id ) { $this->redirect( '/pages/err_clin-ann_no_part_id', NULL, TRUE ); }
	
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id));
		
		if ( !empty($this->data) ) {
			$this->data['ReproductiveHistory']['participant_id'] = $participant_id;
			if ( $this->ReproductiveHistory->save($this->data) ) {
				$this->flash( 'Your data has been updated.','/clinicalannotation/reproductive_histories/detail/'.$participant_id.'/'.$this->ReproductiveHistory->id );
			}
		}
	}
	
	function edit( $participant_id, $reproductive_history_id) {
		if ( !$participant_id ) { $this->redirect( '/pages/err_clin-ann_no_part_id', NULL, TRUE ); }
		if ( !$reproductive_history_id ) { $this->redirect( '/pages/err_clin-ann_no_reprod_id', NULL, TRUE ); }
		
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id, 'ReproductiveHistory.id'=>$reproductive_history_id) );
		
		if ( !empty($this->data) ) {
			$this->ReproductiveHistory->id = $reproductive_history_id;
			if ( $this->ReproductiveHistory->save($this->data) ) {
				$this->flash( 'Your data has been updated.','/clinicalannotation/reproductive_histories/detail/'.$participant_id.'/'.$reproductive_history_id );
			}
		} else {
			$this->data = $this->ReproductiveHistory->find('first',array('conditions'=>array('ReproductiveHistory.id'=>$reproductive_history_id)));
		}
	}

	function delete( $participant_id=null, $reproductive_history_id=null ) {
		if ( !$participant_id ) { $this->redirect( '/pages/err_clin-ann_no_part_id', NULL, TRUE ); }
		if ( !$reproductive_history_id ) { $this->redirect( '/pages/err_clin-ann_no_reprod_id', NULL, TRUE ); }
		
		if( $this->ReproductiveHistory->del( $reproductive_history_id ) ) {
			$this->flash( 'Your data has been deleted.', '/clinicalannotation/reproductive_histories/listall/'.$participant_id );
		} else {
			$this->flash( 'Your data has been deleted.', '/clinicalannotation/reproductive_histories/listall/'.$participant_id );
		}
	}

}

?>