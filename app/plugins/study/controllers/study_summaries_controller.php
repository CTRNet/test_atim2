<?php

class StudySummariesController extends StudyAppController {

	var $uses = array('Study.StudySummary');
	var $paginate = array('StudySummary'=>array('limit'=>10,'order'=>'StudySummary.title'));
  
	function listall( ) {
		$this->data = $this->paginate($this->StudySummary, array());
	}

	function add() {	
		$this->set('atim_menu', $this->Menus->get('/study/study_summaries/listall'));
	
		if ( !empty($this->data) ) {
			if ( $this->StudySummary->save($this->data) ) {
				$this->flash( 'Your data has been updated.','/study/study_summaries/detail/'.$this->StudySummary->id );
			}
		}
  	}
  
	function edit( $study_summary_id=null ) {
		if ( !$study_summary_id ) { $this->redirect( '/pages/err_clin-ann_no_part_id', NULL, TRUE ); }
		
		$this->set( 'atim_menu_variables', array('StudySummary.id'=>$study_summary_id) );
		
		if ( !empty($this->data) ) {
			$this->StudySummary->id = $study_summary_id;
			if ( $this->StudySummary->save($this->data) ) {
				$this->flash( 'Your data has been updated.','/study/study_summaries/detail/'.$study_summary_id );
			}
		} else {
			$this->data = $this->StudySummary->find('first',array('conditions'=>array('StudySummary.id'=>$study_summary_id)));
		}
  	}
	
	function detail( $study_summary_id=null ) {
		
		
		if ( !$study_summary_id ) { $this->redirect( '/pages/err_clin-ann_no_part_id', NULL, TRUE ); }
		
		$this->set( 'atim_menu_variables', array('StudySummary.id'=>$study_summary_id) );
		$this->data = $this->StudySummary->find('first',array('conditions'=>array('StudySummary.id'=>$study_summary_id)));
	}
  
	function delete( $study_summary_id=null ) {
    
		if ( !$study_summary_id ) { $this->redirect( '/pages/err_clin-ann_no_part_id', NULL, TRUE ); }
		
		if( $this->StudySummary->del( $study_summary_id ) ) {
			$this->flash( 'Your data has been deleted.', '/study/study_summaries/listall/');
		} else {
			$this->flash( 'Your data has been deleted.', '/study/study_summaries/listall/');
		}
  	}
 
}

?>
