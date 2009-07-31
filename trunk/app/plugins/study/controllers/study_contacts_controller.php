<?php

class StudyContactsController extends StudyAppController {
	
	var $uses = array('Study.StudyContact','Study.StudySummary');
	var $paginate = array('StudyContact'=>array('limit'=>10,'order'=>'StudyContact.last_name'));
	
	function listall( $study_summary_id=null ) {
		if ( !$study_summary_id ) { $this->redirect( '/pages/err_study_no_summary_id', NULL, TRUE ); }

		$this->set( 'atim_menu_variables', array('StudySummary.id'=>$study_summary_id));
		$this->data = $this->paginate($this->StudyContact, array('StudyContact.study_summary_id'=>$study_summary_id));
		
	}

	function add( $study_summary_id=null) {
		if ( !$study_summary_id ) { $this->redirect( '/pages/err_study_no_summary_id', NULL, TRUE ); }
	
		$this->set( 'atim_menu_variables', array('StudySummary.id'=>$study_summary_id));
		
		if ( !empty($this->data) ) {
			$this->data['StudyContact']['study_summary_id'] = $study_summary_id;
			if ( $this->StudyContact->save($this->data) ) {
				$this->flash( 'Your data has been updated.','/study/study_contacts/detail/'.$study_summary_id.'/'.$this->StudyContact->id );
			}
		}
  	}
  
	function edit( $study_summary_id=null, $study_contact_id=null ) {
    	if ( !$study_summary_id ) { $this->redirect( '/pages/err_study_no_summary_id', NULL, TRUE ); }
		if ( !$study_contact_id ) { $this->redirect( '/pages/err_study_no_contact_id', NULL, TRUE ); }
		
		$this->set( 'atim_menu_variables', array('StudySummary.id'=>$study_summary_id, 'StudyContact.id'=>$study_contact_id) );
		
		if ( !empty($this->data) ) {
			$this->StudyContact->id = $study_contact_id;
			if ( $this->StudyContact->save($this->data) ) {
				$this->flash( 'Your data has been updated.','/study/study_contacts/detail/'.$study_summary_id.'/'.$study_contact_id );
			}
		} else {
			$this->data = $this->StudyContact->find('first',array('conditions'=>array('StudyContact.id'=>$study_contact_id)));
		}
  	}
	
	function detail( $study_summary_id=null, $study_contact_id=null ) {
		if ( !$study_summary_id ) { $this->redirect( '/pages/err_study_no_summary_id', NULL, TRUE ); }
		if ( !$study_contact_id ) { $this->redirect( '/pages/err_study_no_contact_id', NULL, TRUE ); }
		
		$this->set( 'atim_menu_variables', array('StudySummary.id'=>$study_summary_id, 'StudyContact.id'=>$study_contact_id) );
		$this->data = $this->StudyContact->find('first',array('conditions'=>array('StudyContact.id'=>$study_contact_id)));
	}
  
	function delete( $study_summary_id=null, $study_contact_id=null ) {
		if ( !$study_summary_id ) { $this->redirect( '/pages/err_study_no_summary_id', NULL, TRUE ); }
		if ( !$study_contact_id ) { $this->redirect( '/pages/err_study_no_contact_id', NULL, TRUE ); }
		
		if( $this->StudyContact->del( $study_contact_id ) ) {
			$this->flash( 'Your data has been deleted.', '/study/study_contacts/listall/'.$study_summary_id );
		} else {
			$this->flash( 'Your data has been deleted.', '/study/study_contacts/listall/'.$study_summary_id );
		}
  	}
}

?>
