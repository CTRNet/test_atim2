<?php

class StudyResultsController extends StudyAppController {
	var $uses = array('Study.StudyResult','Study.StudySummary');
	var $paginate = array('StudyResult'=>array('limit'=>10,'order'=>'StudyResult.abstract'));
	
	function listall( $study_summary_id=null ) {
		if ( !$study_summary_id ) { $this->redirect( '/pages/err_study_no_summary_id', NULL, TRUE ); }

		$this->set( 'atim_menu_variables', array('StudySummary.id'=>$study_summary_id));
		
		$this->hook();
		
		$this->data = $this->paginate($this->StudyResult, array('StudyResult.study_summary_id'=>$study_summary_id));
		
	}

	function add( $study_summary_id=null) {
		if ( !$study_summary_id ) { $this->redirect( '/pages/err_study_no_summary_id', NULL, TRUE ); }
	
		$this->set( 'atim_menu_variables', array('StudySummary.id'=>$study_summary_id));
		
		$this->hook();
		
		if ( !empty($this->data) ) {
			$this->data['StudyResult']['study_summary_id'] = $study_summary_id;
			if ( $this->StudyResult->save($this->data) ) {
				$this->flash( 'Your data has been updated.','/study/study_results/detail/'.$study_summary_id.'/'.$this->StudyResult->id );
			}
		}
  	}
  
	function edit( $study_summary_id=null, $study_result_id=null ) {
    	if ( !$study_summary_id ) { $this->redirect( '/pages/err_study_no_summary_id', NULL, TRUE ); }
		if ( !$study_result_id ) { $this->redirect( '/pages/err_study_no_result_id', NULL, TRUE ); }
		
		$this->set( 'atim_menu_variables', array('StudySummary.id'=>$study_summary_id, 'StudyResult.id'=>$study_result_id) );
		
		$this->hook();
		
		if ( !empty($this->data) ) {
			$this->StudyResult->id = $study_result_id;
			if ( $this->StudyResult->save($this->data) ) {
				$this->flash( 'Your data has been updated.','/study/study_results/detail/'.$study_summary_id.'/'.$study_result_id );
			}
		} else {
			$this->data = $this->StudyResult->find('first',array('conditions'=>array('StudyResult.id'=>$study_result_id)));
		}
  	}
	
	function detail( $study_summary_id=null, $study_result_id=null ) {
		if ( !$study_summary_id ) { $this->redirect( '/pages/err_study_no_summary_id', NULL, TRUE ); }
		if ( !$study_result_id ) { $this->redirect( '/pages/err_study_no_result_id', NULL, TRUE ); }
		
		$this->set( 'atim_menu_variables', array('StudySummary.id'=>$study_summary_id, 'StudyResult.id'=>$study_result_id) );
		
		$this->hook();
		
		$this->data = $this->StudyResult->find('first',array('conditions'=>array('StudyResult.id'=>$study_result_id)));
	}
  
	function delete( $study_summary_id=null, $study_result_id=null ) {
		if ( !$study_summary_id ) { $this->redirect( '/pages/err_study_no_summary_id', NULL, TRUE ); }
		if ( !$study_result_id ) { $this->redirect( '/pages/err_study_no_result_id', NULL, TRUE ); }
		
		$this->hook();
		
		if( $this->StudyResult->atim_delete( $study_result_id ) ) {
			$this->flash( 'Your data has been deleted.', '/study/study_results/listall/'.$study_summary_id );
		} else {
			$this->flash( 'Error deleting data - Contact administrator.', '/study/study_results/listall/'.$study_summary_id );
		}
  	}
}

?>
