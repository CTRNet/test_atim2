<?php

class MiscIdentifiersController extends ClinicalannotationAppController {

	var $uses = array('ClinicalAnnotation.MiscIdentifier','ClinicalAnnotation.Participant');
	var $paginate = array('MiscIdentifier'=>array('limit'=>10,'order'=>'MiscIdentifier.name ASC'));
	
	function listall( $participant_id=null ) {
		if ( !$participant_id ) { $this->redirect( '/pages/err_clin-ann_no_part_id', NULL, TRUE ); }

		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id));
		$this->data = $this->paginate($this->MiscIdentifier, array('MiscIdentifier.participant_id'=>$participant_id));
	}
	
	function detail( $participant_id=null, $misc_identifier_id=null ) {
		if ( !$participant_id ) { $this->redirect( '/pages/err_clin-ann_no_part_id', NULL, TRUE ); }
		if ( !$misc_identifier_id ) { $this->redirect( '/pages/err_clin-ann_no_part_id', NULL, TRUE ); }
		
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id, 'MiscIdentifier.id'=>$misc_identifier_id) );
		$this->data = $this->MiscIdentifier->find('first',array('conditions'=>array('MiscIdentifier.id'=>$misc_identifier_id)));
	}
	
	function add( $participant_id=null ) {
		if ( !$participant_id ) { $this->redirect( '/pages/err_clin-ann_no_part_id', NULL, TRUE ); }
	
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id));
		
		if ( !empty($this->data) ) {
			$this->data['MiscIdentifier']['participant_id'] = $participant_id;
			if ( $this->MiscIdentifier->save($this->data) ) {
				$this->flash( 'Your data has been updated.','/clinicalannotation/misc_identifiers/detail/'.$participant_id.'/'.$this->MiscIdentifier->id );
			}
		}
	}
	
	function edit( $participant_id=null, $misc_identifier_id=null) {
		if ( !$participant_id ) { $this->redirect( '/pages/err_clin-ann_no_part_id', NULL, TRUE ); }
		if ( !$misc_identifier_id ) { $this->redirect( '/pages/err_clin-ann_no_part_id', NULL, TRUE ); }
		
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id, 'MiscIdentifier.id'=>$misc_identifier_id) );
		
		if ( !empty($this->data) ) {
			$this->MiscIdentifier->id = $misc_identifier_id;
			if ( $this->MiscIdentifier->save($this->data) ) {
				$this->flash( 'Your data has been updated.','/clinicalannotation/misc_identifiers/detail/'.$participant_id.'/'.$misc_identifier_id );
			}
		} else {
			$this->data = $this->MiscIdentifier->find('first',array('conditions'=>array('MiscIdentifier.id'=>$misc_identifier_id)));
		}
	}

	function delete( $participant_id=null, $misc_identifier_id=null ) {
		if ( !$participant_id ) { $this->redirect( '/pages/err_clin-ann_no_part_id', NULL, TRUE ); }
		if ( !$misc_identifier_id ) { $this->redirect( '/pages/err_clin-ann_no_part_id', NULL, TRUE ); }
		
		if( $this->MiscIdentifier->del( $misc_identifier_id ) ) {
			$this->flash( 'Your data has been deleted.', '/clinicalannotation/misc_identifiers/listall/'.$participant_id );
		} else {
			$this->flash( 'Your data has been deleted.', '/clinicalannotation/misc_identifiers/listall/'.$participant_id );
		}
	}
}

?>