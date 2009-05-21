<?php

class StudyFundingsController extends StudyAppController {
		
	var $uses = array('StudyFunding','StudySummary');
	var $paginate = array('StudyFunding'=>array('limit'=>10,'order'=>'StudyFunding.study_sponsor'));
	
	function listall( $study_summary_id=null ) {
		if ( !$study_summary_id ) { $this->redirect( '/pages/err_clin-ann_no_part_id', NULL, TRUE ); }

		$this->set( 'atim_menu_variables', array('StudySummary.id'=>$study_summary_id));
		$this->data = $this->paginate($this->StudyFunding, array('StudyFunding.study_summary_id'=>$study_summary_id));
		
	}

	function add( $study_summary_id=null) {
		if ( !$study_summary_id ) { $this->redirect( '/pages/err_clin-ann_no_part_id', NULL, TRUE ); }
	
		$this->set( 'atim_menu_variables', array('StudySummary.id'=>$study_summary_id));
		
		if ( !empty($this->data) ) {
			$this->data['StudyFunding']['study_summary_id'] = $study_summary_id;
			if ( $this->StudyFunding->save($this->data) ) {
				$this->flash( 'Your data has been updated.','/study/study_fundings/detail/'.$study_summary_id.'/'.$this->StudyFunding->id );
			}
		}
  	}
  
	function edit( $study_summary_id=null, $study_funding_id=null ) {
    	if ( !$study_summary_id ) { $this->redirect( '/pages/err_clin-ann_no_part_id', NULL, TRUE ); }
		if ( !$study_funding_id ) { $this->redirect( '/pages/err_clin-ann_no_part_id', NULL, TRUE ); }
		
		$this->set( 'atim_menu_variables', array('StudySummary.id'=>$study_summary_id, 'StudyFunding.id'=>$study_funding_id) );
		
		if ( !empty($this->data) ) {
			$this->StudyFunding->id = $study_funding_id;
			if ( $this->StudyFunding->save($this->data) ) {
				$this->flash( 'Your data has been updated.','/study/study_fundings/detail/'.$study_summary_id.'/'.$study_funding_id );
			}
		} else {
			$this->data = $this->StudyFunding->find('first',array('conditions'=>array('StudyFunding.id'=>$study_funding_id)));
		}
  	}
	
	function detail( $study_summary_id=null, $study_funding_id=null ) {
		if ( !$study_summary_id ) { $this->redirect( '/pages/err_clin-ann_no_part_id', NULL, TRUE ); }
		if ( !$study_funding_id ) { $this->redirect( '/pages/err_clin-ann_no_part_id', NULL, TRUE ); }
		
		$this->set( 'atim_menu_variables', array('StudySummary.id'=>$study_summary_id, 'StudyFunding.id'=>$study_funding_id) );
		$this->data = $this->StudyFunding->find('first',array('conditions'=>array('StudyFunding.id'=>$study_funding_id)));
	}
  
	function delete( $study_summary_id=null, $study_funding_id=null ) {
		if ( !$study_summary_id ) { $this->redirect( '/pages/err_clin-ann_no_part_id', NULL, TRUE ); }
		if ( !$study_funding_id ) { $this->redirect( '/pages/err_clin-ann_no_part_id', NULL, TRUE ); }
		
		if( $this->StudyFunding->del( $study_funding_id ) ) {
			$this->flash( 'Your data has been deleted.', '/study/study_fundings/listall/'.$study_summary_id );
		} else {
			$this->flash( 'Your data has been deleted.', '/study/study_fundings/listall/'.$study_summary_id );
		}
  	}
}

?>