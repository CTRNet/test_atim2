<?php

class StudyReviewsController extends StudyAppController {
	var $uses = array('Study.StudyReview','Study.StudySummary');
	var $paginate = array('StudyReview'=>array('limit'=>10,'order'=>'StudyReview.last_name'));
	
	function listall( $study_summary_id=null ) {
		if ( !$study_summary_id ) { $this->redirect( '/pages/err_study_no_summary_id', NULL, TRUE ); }

		$this->set( 'atim_menu_variables', array('StudySummary.id'=>$study_summary_id));
		
		$this->hook();
		
		$this->data = $this->paginate($this->StudyReview, array('StudyReview.study_summary_id'=>$study_summary_id));
		
	}

	function add( $study_summary_id=null) {
		if ( !$study_summary_id ) { $this->redirect( '/pages/err_study_no_summary_id', NULL, TRUE ); }
	
		$this->set( 'atim_menu_variables', array('StudySummary.id'=>$study_summary_id));
		
		$this->hook();
		
		if ( !empty($this->data) ) {
			$this->data['StudyReview']['study_summary_id'] = $study_summary_id;
			if ( $this->StudyReview->save($this->data) ) {
				$this->flash( 'Your data has been updated.','/study/study_reviews/detail/'.$study_summary_id.'/'.$this->StudyReview->id );
			}
		}
  	}
  
	function edit( $study_summary_id=null, $study_review_id=null ) {
    	if ( !$study_summary_id ) { $this->redirect( '/pages/err_study_no_summary_id', NULL, TRUE ); }
		if ( !$study_review_id ) { $this->redirect( '/pages/err_study_no_review_id', NULL, TRUE ); }
		
		$this->set( 'atim_menu_variables', array('StudySummary.id'=>$study_summary_id, 'StudyReview.id'=>$study_review_id) );
		
		$this->hook();
		
		if ( !empty($this->data) ) {
			$this->StudyReview->id = $study_review_id;
			if ( $this->StudyReview->save($this->data) ) {
				$this->flash( 'Your data has been updated.','/study/study_reviews/detail/'.$study_summary_id.'/'.$study_review_id );
			}
		} else {
			$this->data = $this->StudyReview->find('first',array('conditions'=>array('StudyReview.id'=>$study_review_id)));
		}
  	}
	
	function detail( $study_summary_id=null, $study_review_id=null ) {
		if ( !$study_summary_id ) { $this->redirect( '/pages/err_study_no_summary_id', NULL, TRUE ); }
		if ( !$study_review_id ) { $this->redirect( '/pages/err_study_no_review_id', NULL, TRUE ); }
		
		$this->set( 'atim_menu_variables', array('StudySummary.id'=>$study_summary_id, 'StudyReview.id'=>$study_review_id) );
		
		$this->hook();
		
		$this->data = $this->StudyReview->find('first',array('conditions'=>array('StudyReview.id'=>$study_review_id)));
	}
  
	function delete( $study_summary_id=null, $study_review_id=null ) {
		if ( !$study_summary_id ) { $this->redirect( '/pages/err_study_no_summary_id', NULL, TRUE ); }
		if ( !$study_review_id ) { $this->redirect( '/pages/err_study_no_review_id', NULL, TRUE ); }
		
		$this->hook();
		
		if( $this->StudyReview->atim_delete( $study_review_id ) ) {
			$this->flash( 'Your data has been deleted.', '/study/study_reviews/listall/'.$study_summary_id );
		} else {
			$this->flash( 'Error deleting data - Contact administrator.', '/study/study_reviews/listall/'.$study_summary_id );
		}
  	}
}

?>
