<?php

class StudySummariesController extends StudyAppController {

	var $uses = array('Study.StudySummary');
	var $paginate = array('StudySummary'=>array('limit' => pagination_amount,'order'=>'StudySummary.title'));
  
	function listall( ) {
		// MANAGE DATA
		$this->data = $this->paginate($this->StudySummary, array());
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }
	}

	function detail( $study_summary_id ) {
		if (!$study_summary_id ) { $this->redirect( '/pages/err_study_funct_param_missing', NULL, TRUE ); }
		 
		// MANAGE DATA
		$study_summary_data = $this->StudySummary->find('first',array('conditions'=>array('StudySummary.id'=>$study_summary_id)));
		if(empty($study_summary_data)) { $this->redirect( '/pages/err_study_no_data', null, true ); }		
		$this->data = $study_summary_data;
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		$this->set( 'atim_menu_variables', array('StudySummary.id'=>$study_summary_id) );
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }
	}
	
	function add() {
	
		// MANAGE FORM, MENU AND ACTION BUTTONS
		$this->set('atim_menu', $this->Menus->get('/study/study_summaries/listall'));
	
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }
	
		if ( !empty($this->data) ) {
			$submitted_data_validates = true;
			// ... special validations

			// 3- CUSTOM CODE: PROCESS SUBMITTED DATA BEFORE SAVE
			$hook_link = $this->hook('presave_process');
			if( $hook_link ) { require($hook_link); }				
		
			if($submitted_data_validates) {
				if ( $this->StudySummary->save($this->data) ) {
					$this->flash( 'your data has been saved','/study/study_summaries/detail/'.$this->StudySummary->id );
				}
			}
		}
  	}
  
	function edit( $study_summary_id ) {
		if ( !$study_summary_id ) { $this->redirect( '/pages/err_study_funct_param_missing', NULL, TRUE ); }
		
		// MANAGE DATA
		$study_summary_data = $this->StudySummary->find('first',array('conditions'=>array('StudySummary.id'=>$study_summary_id)));
		if(empty($study_summary_data)) { $this->redirect( '/pages/err_clin_no_data', null, true ); }

		// MANAGE FORM, MENU AND ACTION BUTTONS
		$this->set( 'atim_menu_variables', array('StudySummary.id'=>$study_summary_id) );
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }	
		
		
		if(empty($this->data)) {
			$this->data = $study_summary_data;
		} else {
			$submitted_data_validates = true;
			// ... special validations
			
			// 3- CUSTOM CODE: PROCESS SUBMITTED DATA BEFORE SAVE
			$hook_link = $this->hook('presave_process');
			if( $hook_link ) { require($hook_link); }

			if($submitted_data_validates) {	
				$this->StudySummary->id = $study_summary_id;
				if ( $this->StudySummary->save($this->data) ) {
					$this->flash( 'your data has been updated','/study/study_summaries/detail/'.$study_summary_id );
				}		
			}
		}
  	}
	
	function delete( $study_summary_id ) {
		if ( !$study_summary_id ) { $this->redirect( '/pages/err_study_funct_param_missing', NULL, TRUE ); }

		// MANAGE DATA
		$study_summary_data = $this->StudySummary->find('first',array('conditions'=>array('StudySummary.id'=>$study_summary_id)));
		if(empty($study_summary_data)) { $this->redirect( '/pages/err_clin_no_data', null, true ); }
		
		$arr_allow_deletion = $this->allowStudySummaryDeletion($study_summary_id);
		
		// CUSTOM CODE
		$hook_link = $this->hook('delete');
		if( $hook_link ) { require($hook_link); }	
		
		if($arr_allow_deletion['allow_deletion']) {
			// DELETE DATA
			if( $this->StudySummary->atim_delete( $study_summary_id ) ) {
				$this->flash( 'your data has been deleted', '/study/study_summaries/listall/');
			} else {
				$this->flash( 'error deleting data - contact administrator', '/study/study_summaries/listall/');
			}	
		} else {
			$this->flash($arr_allow_deletion['msg'], '/clinicalannotation/study_summaries/detail/'.$study_summary_id);
		}	
  	}
	
	/* --------------------------------------------------------------------------
	 * ADDITIONAL FUNCTIONS
	 * -------------------------------------------------------------------------- */

	/**
	 * Check if a record can be deleted.
	 * 
	 * @param $study_summary_id Id of the studied record.
	 * 
	 * @return Return results as array:
	 * 	['allow_deletion'] = true/false
	 * 	['msg'] = message to display when previous field equals false
	 * 
	 * @author N. Luc
	 * @since 2007-10-16
	 */
	 
	function allowStudySummaryDeletion($study_summary_id){
		//$returned_nbr = $this->LinkedModel->find('count', array('conditions' => array('LinkedModel.study_summary_id' => $study_summary_id), 'recursive' => '-1'));
		//if($returned_nbr > 0) { return array('allow_deletion' => false, 'msg' => 'a LinkedModel exists for the deleted study summary'); }
		
		return array('allow_deletion' => true, 'msg' => '');
	}
 
}

?>
