<?php

class StudyInvestigatorsController extends StudyAppController {
	
	var $uses = array('Study.StudyInvestigator','Study.StudySummary');
	var $paginate = array('StudyInvestigator'=>array('limit'=>10,'order'=>'StudyInvestigator.last_name'));
	
	function listall( $study_summary_id=null ) {
		if ( !$study_summary_id ) { $this->redirect( '/pages/err_study_no_summary_id', NULL, TRUE ); }

		$this->set( 'atim_menu_variables', array('StudySummary.id'=>$study_summary_id));
		
		$this->hook();
		
		$this->data = $this->paginate($this->StudyInvestigator, array('StudyInvestigator.study_summary_id'=>$study_summary_id));
		
	}

	function add( $study_summary_id=null) {
		if ( !$study_summary_id ) { $this->redirect( '/pages/err_study_no_summary_id', NULL, TRUE ); }
	
		$this->set( 'atim_menu_variables', array('StudySummary.id'=>$study_summary_id));
		
		$this->hook();
		
		if ( !empty($this->data) ) {
			$this->data['StudyInvestigator']['study_summary_id'] = $study_summary_id;
			if ( $this->StudyInvestigator->save($this->data) ) {
				$this->flash( 'Your data has been updated.','/study/study_investigators/detail/'.$study_summary_id.'/'.$this->StudyInvestigator->id );
			}
		}
  	}
  
	function edit( $study_summary_id=null, $study_investigator_id=null ) {
    	if ( !$study_summary_id ) { $this->redirect( '/pages/err_study_no_summary_id', NULL, TRUE ); }
		if ( !$study_investigator_id ) { $this->redirect( '/pages/err_study_no_invest_id', NULL, TRUE ); }
		
		$this->set( 'atim_menu_variables', array('StudySummary.id'=>$study_summary_id, 'StudyInvestigator.id'=>$study_investigator_id) );
		
		$this->hook();
		
		if ( !empty($this->data) ) {
			$this->StudyInvestigator->id = $study_investigator_id;
			if ( $this->StudyInvestigator->save($this->data) ) {
				$this->flash( 'Your data has been updated.','/study/study_investigators/detail/'.$study_summary_id.'/'.$study_investigator_id );
			}
		} else {
			$this->data = $this->StudyInvestigator->find('first',array('conditions'=>array('StudyInvestigator.id'=>$study_investigator_id)));
		}
  	}
	
	function detail( $study_summary_id=null, $study_investigator_id=null ) {
		if ( !$study_summary_id ) { $this->redirect( '/pages/err_study_no_summary_id', NULL, TRUE ); }
		if ( !$study_investigator_id ) { $this->redirect( '/pages/err_study_no_invest_id', NULL, TRUE ); }
		
		$this->set( 'atim_menu_variables', array('StudySummary.id'=>$study_summary_id, 'StudyInvestigator.id'=>$study_investigator_id) );
		
		$this->hook();
		
		$this->data = $this->StudyInvestigator->find('first',array('conditions'=>array('StudyInvestigator.id'=>$study_investigator_id)));
	}
  
	function delete( $study_summary_id=null, $study_investigator_id=null ) {
		if ( !$study_summary_id ) { $this->redirect( '/pages/err_study_no_summary_id', NULL, TRUE ); }
		if ( !$study_investigator_id ) { $this->redirect( '/pages/err_study_no_invest_id', NULL, TRUE ); }
		
		$this->hook();
		
		if( $this->StudyInvestigator->atim_delete( $study_investigator_id ) ) {
			$this->flash( 'Your data has been deleted.', '/study/study_investigators/listall/'.$study_summary_id );
		} else {
			$this->flash( 'Error deleting data - Contact administrator.', '/study/study_investigators/listall/'.$study_summary_id );
		}
  	}
}

?>
