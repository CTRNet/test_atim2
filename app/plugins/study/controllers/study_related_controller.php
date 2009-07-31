<?php

class StudyRelatedController extends StudyAppController {
			
	var $uses = array('Study.StudyRelated','Study.StudySummary');
	var $paginate = array('StudyRelated'=>array('limit'=>10,'order'=>'StudyRelated.title'));
	
	function listall( $study_summary_id=null ) {
		if ( !$study_summary_id ) { $this->redirect( '/pages/err_study_no_summary_id', NULL, TRUE ); }

		$this->set( 'atim_menu_variables', array('StudySummary.id'=>$study_summary_id));
		$this->data = $this->paginate($this->StudyRelated, array('StudyRelated.study_summary_id'=>$study_summary_id));
		
	}

	function add( $study_summary_id=null) {
		if ( !$study_summary_id ) { $this->redirect( '/pages/err_study_no_summary_id', NULL, TRUE ); }
	
		$this->set( 'atim_menu_variables', array('StudySummary.id'=>$study_summary_id));
		
		if ( !empty($this->data) ) {
			$this->data['StudyRelated']['study_summary_id'] = $study_summary_id;
			if ( $this->StudyRelated->save($this->data) ) {
				$this->flash( 'Your data has been updated.','/study/study_related/detail/'.$study_summary_id.'/'.$this->StudyRelated->id );
			}
		}
  	}
  
	function edit( $study_summary_id=null, $study_related_id=null ) {
    	if ( !$study_summary_id ) { $this->redirect( '/pages/err_study_no_summary_id', NULL, TRUE ); }
		if ( !$study_related_id ) { $this->redirect( '/pages/err_study_no_related_id', NULL, TRUE ); }
		
		$this->set( 'atim_menu_variables', array('StudySummary.id'=>$study_summary_id, 'StudyRelated.id'=>$study_related_id) );
		
		if ( !empty($this->data) ) {
			$this->StudyRelated->id = $study_related_id;
			if ( $this->StudyRelated->save($this->data) ) {
				$this->flash( 'Your data has been updated.','/study/study_related/detail/'.$study_summary_id.'/'.$study_related_id );
			}
		} else {
			$this->data = $this->StudyRelated->find('first',array('conditions'=>array('StudyRelated.id'=>$study_related_id)));
		}
  	}
	
	function detail( $study_summary_id=null, $study_related_id=null ) {
		if ( !$study_summary_id ) { $this->redirect( '/pages/err_study_no_summary_id', NULL, TRUE ); }
		if ( !$study_related_id ) { $this->redirect( '/pages/err_study_no_related_id', NULL, TRUE ); }
		
		$this->set( 'atim_menu_variables', array('StudySummary.id'=>$study_summary_id, 'StudyRelated.id'=>$study_related_id) );
		$this->data = $this->StudyRelated->find('first',array('conditions'=>array('StudyRelated.id'=>$study_related_id)));
	}
  
	function delete( $study_summary_id=null, $study_related_id=null ) {
		if ( !$study_summary_id ) { $this->redirect( '/pages/err_study_no_summary_id', NULL, TRUE ); }
		if ( !$study_related_id ) { $this->redirect( '/pages/err_study_no_related_id', NULL, TRUE ); }
		
		if( $this->StudyRelated->del( $study_related_id ) ) {
			$this->flash( 'Your data has been deleted.', '/study/study_related/listall/'.$study_summary_id );
		} else {
			$this->flash( 'Your data has been deleted.', '/study/study_related/listall/'.$study_summary_id );
		}
  	}
}

?>
