<?php

class StudyEthicsboardsController extends StudyAppController {
		
	var $uses = array('StudyEthicsboard','StudySummary');
	var $paginate = array('StudyEthicsboard'=>array('limit'=>10,'order'=>'StudyEthicsboard.ethics_board'));
	
	function listall( $study_summary_id=null ) {
		if ( !$study_summary_id ) { $this->redirect( '/pages/err_clin-ann_no_part_id', NULL, TRUE ); }

		$this->set( 'atim_menu_variables', array('StudySummary.id'=>$study_summary_id));
		$this->data = $this->paginate($this->StudyEthicsboard, array('StudyEthicsboard.study_summary_id'=>$study_summary_id));
		
	}

	function add( $study_summary_id=null) {
		if ( !$study_summary_id ) { $this->redirect( '/pages/err_clin-ann_no_part_id', NULL, TRUE ); }
	
		$this->set( 'atim_menu_variables', array('StudySummary.id'=>$study_summary_id));
		
		if ( !empty($this->data) ) {
			$this->data['StudyEthicsboard']['study_summary_id'] = $study_summary_id;
			if ( $this->StudyEthicsboard->save($this->data) ) {
				$this->flash( 'Your data has been updated.','/study/study_ethicsboards/detail/'.$study_summary_id.'/'.$this->StudyEthicsboard->id );
			}
		}
  	}
  
	function edit( $study_summary_id=null, $study_ethicsboard_id=null ) {
    	if ( !$study_summary_id ) { $this->redirect( '/pages/err_clin-ann_no_part_id', NULL, TRUE ); }
		if ( !$study_ethicsboard_id ) { $this->redirect( '/pages/err_clin-ann_no_part_id', NULL, TRUE ); }
		
		$this->set( 'atim_menu_variables', array('StudySummary.id'=>$study_summary_id, 'StudyEthicsboard.id'=>$study_ethicsboard_id) );
		
		if ( !empty($this->data) ) {
			$this->StudyEthicsboard->id = $study_ethicsboard_id;
			if ( $this->StudyEthicsboard->save($this->data) ) {
				$this->flash( 'Your data has been updated.','/study/study_ethicsboards/detail/'.$study_summary_id.'/'.$study_ethicsboard_id );
			}
		} else {
			$this->data = $this->StudyEthicsboard->find('first',array('conditions'=>array('StudyEthicsboard.id'=>$study_ethicsboard_id)));
		}
  	}
	
	function detail( $study_summary_id=null, $study_ethicsboard_id=null ) {
		if ( !$study_summary_id ) { $this->redirect( '/pages/err_clin-ann_no_part_id', NULL, TRUE ); }
		if ( !$study_ethicsboard_id ) { $this->redirect( '/pages/err_clin-ann_no_part_id', NULL, TRUE ); }
		
		$this->set( 'atim_menu_variables', array('StudySummary.id'=>$study_summary_id, 'StudyEthicsboard.id'=>$study_ethicsboard_id) );
		$this->data = $this->StudyEthicsboard->find('first',array('conditions'=>array('StudyEthicsboard.id'=>$study_ethicsboard_id)));
	}
  
	function delete( $study_summary_id=null, $study_ethicsboard_id=null ) {
		if ( !$study_summary_id ) { $this->redirect( '/pages/err_clin-ann_no_part_id', NULL, TRUE ); }
		if ( !$study_ethicsboard_id ) { $this->redirect( '/pages/err_clin-ann_no_part_id', NULL, TRUE ); }
		
		if( $this->StudyEthicsboard->del( $study_ethicsboard_id ) ) {
			$this->flash( 'Your data has been deleted.', '/study/study_ethicsboards/listall/'.$study_summary_id );
		} else {
			$this->flash( 'Your data has been deleted.', '/study/study_ethicsboards/listall/'.$study_summary_id );
		}
  	}
}

?>
