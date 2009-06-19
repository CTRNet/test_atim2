<?php

class StudyEthicsBoardsController extends StudyAppController {
		
	var $uses = array('StudyEthicsBoard','StudySummary');
	var $paginate = array('StudyEthicsBoard'=>array('limit'=>10,'order'=>'StudyEthicsBoard.ethics_board'));
	
	function listall( $study_summary_id=null ) {
		if ( !$study_summary_id ) { $this->redirect( '/pages/err_clin-ann_no_part_id', NULL, TRUE ); }

		$this->set( 'atim_menu_variables', array('StudySummary.id'=>$study_summary_id));
		$this->data = $this->paginate($this->StudyEthicsBoard, array('StudyEthicsBoard.study_summary_id'=>$study_summary_id));
		
	}

	function add( $study_summary_id=null) {
		if ( !$study_summary_id ) { $this->redirect( '/pages/err_clin-ann_no_part_id', NULL, TRUE ); }
	
		$this->set( 'atim_menu_variables', array('StudySummary.id'=>$study_summary_id));
		
		if ( !empty($this->data) ) {
			$this->data['StudyEthicsBoard']['study_summary_id'] = $study_summary_id;
			if ( $this->StudyEthicsBoard->save($this->data) ) {
				$this->flash( 'Your data has been updated.','/study/study_ethics_boards/detail/'.$study_summary_id.'/'.$this->StudyEthicsBoard->id );
			}
		}
  	}
  
	function edit( $study_summary_id=null, $study_ethics_board_id=null ) {
    	if ( !$study_summary_id ) { $this->redirect( '/pages/err_clin-ann_no_part_id', NULL, TRUE ); }
		if ( !$study_ethics_board_id ) { $this->redirect( '/pages/err_clin-ann_no_part_id', NULL, TRUE ); }
		
		$this->set( 'atim_menu_variables', array('StudySummary.id'=>$study_summary_id, 'StudyEthicsoard.id'=>$study_ethics_board_id) );
		
		if ( !empty($this->data) ) {
			$this->StudyEthicsBoard->id = $study_ethics_board_id;
			if ( $this->StudyEthicsBoard->save($this->data) ) {
				$this->flash( 'Your data has been updated.','/study/study_ethics_boards/detail/'.$study_summary_id.'/'.$study_ethics_board_id );
			}
		} else {
			$this->data = $this->StudyEthicsBoard->find('first',array('conditions'=>array('StudyEthicsBoard.id'=>$study_ethics_board_id)));
		}
  	}
	
	function detail( $study_summary_id=null, $study_ethics_board_id=null ) {
		if ( !$study_summary_id ) { $this->redirect( '/pages/err_clin-ann_no_part_id', NULL, TRUE ); }
		if ( !$study_ethics_board_id ) { $this->redirect( '/pages/err_clin-ann_no_part_id', NULL, TRUE ); }
		
		$this->set( 'atim_menu_variables', array('StudySummary.id'=>$study_summary_id, 'StudyEthicsBoard.id'=>$study_ethics_board_id) );
		$this->data = $this->StudyEthicsBoard->find('first',array('conditions'=>array('StudyEthicsBoard.id'=>$study_ethics_board_id)));
	}
  
	function delete( $study_summary_id=null, $study_ethics_board_id=null ) {
		if ( !$study_summary_id ) { $this->redirect( '/pages/err_clin-ann_no_part_id', NULL, TRUE ); }
		if ( !$study_ethics_board_id ) { $this->redirect( '/pages/err_clin-ann_no_part_id', NULL, TRUE ); }
		
		if( $this->StudyEthicsBoard->del( $study_ethics_board_id ) ) {
			$this->flash( 'Your data has been deleted.', '/study/study_ethics_boards/listall/'.$study_summary_id );
		} else {
			$this->flash( 'Your data has been deleted.', '/study/study_ethics_boards/listall/'.$study_summary_id );
		}
  	}
}

?>
