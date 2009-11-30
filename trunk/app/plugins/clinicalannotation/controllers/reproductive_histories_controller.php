<?php

class ReproductiveHistoriesController extends ClinicalAnnotationAppController {
	
	var $uses = array(
		'Clinicalannotation.ReproductiveHistory',
		'Clinicalannotation.Participant'
	);
	var $paginate = array('ReproductiveHistory'=>array('limit'=>10,'order'=>'ReproductiveHistory.date_captured'));
	
	function listall( $participant_id ) {
		if ( !$participant_id ) { $this->redirect( 'err_clin_funct_param_missing', NULL, TRUE ); }

		// MANAGE DATA
		$participant_data = $this->Participant->find('first', array('conditions'=>array('Participant.id'=>$participant_id), 'recursive' => '-1'));		
		if(empty($participant_data)) { $this->redirect( '/pages/err_clin_no_data', null, true ); }
	
		$this->data = $this->paginate($this->ReproductiveHistory, array('ReproductiveHistory.participant_id'=>$participant_id));
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id));
				
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }
	}
	
	function detail( $participant_id, $reproductive_history_id ) {
		if ( !$participant_id && !$reproductive_history_id ) { $this->redirect( '/pages/err_clin_funct_param_missing', NULL, TRUE ); }
		
		// MANAGE DATA
		$misc_identifier_data = $this->MiscIdentifier->find('first', array('conditions'=>array('MiscIdentifier.id'=>$misc_identifier_id, 'MiscIdentifier.participant_id'=>$participant_id), 'recursive' => '-1'));		
		if(empty($misc_identifier_data)) { $this->redirect( '/pages/err_clin_no_data', null, true ); }
		$this->data = $misc_identifier_data;
		
		$this->data = $this->ReproductiveHistory->find('first',array('conditions'=>array('ReproductiveHistory.id'=>$reproductive_history_id)));
		// MANAGE FORM, MENU AND ACTION BUTTONS
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id, 'ReproductiveHistory.id'=>$reproductive_history_id) );
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }	
	}
	
	function add( $participant_id ) {
		if ( !$participant_id ) { $this->redirect( '/pages/err_clin-ann_no_part_id', NULL, TRUE ); }
	
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id));
		
		$this->hook();
		
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
		
		$this->hook();
		
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
		
		$this->hook();
		
		if( $this->ReproductiveHistory->del( $reproductive_history_id ) ) {
			$this->flash( 'Your data has been deleted.', '/clinicalannotation/reproductive_histories/listall/'.$participant_id );
		} else {
			$this->flash( 'Error deleting data - Contact administrator.', '/clinicalannotation/reproductive_histories/listall/'.$participant_id );
		}
	}

}

?>