<?php

class StudyEthicsBoardsController extends StudyAppController {
		
	var $uses = array('Study.StudyEthicsBoard','Study.StudySummary');
	var $paginate = array('StudyEthicsBoard'=>array('limit'=>10,'order'=>'StudyEthicsBoard.ethics_board'));
	
	function listall( $study_summary_id ) {
		// Missing or empty function variable, send to ERROR page
		if ( !$study_summary_id ) { $this->redirect( '/pages/err_study_funct_param_missing', NULL, TRUE ); }


    	// MANAGE DATA
    	$study_ethics_board_data= $this->StudySummary->find('first',array('conditions'=>array('StudySummary.id'=>$study_summary_id), 'recursive' => '-1'));
        if(empty($study_ethics_board_data)) { $this->redirect( '/pages/err_study_no_data', null, true ); }

		$this->data = $this->paginate($this->StudyEthicsBoard, array('StudyEthicsBoard.study_summary_id'=>$study_summary_id));

		// MANAGE FORM, MENU AND ACTION BUTTONS
    	$this->set( 'atim_menu_variables', array('StudySummary.id'=>$study_summary_id));


		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }
		
	}

	function detail( $study_summary_id, $study_ethics_board_id ) {
		if ( !$study_summary_id ) { $this->redirect( '/pages/err_study_funct_param_missing', NULL, TRUE ); }
		if ( !$study_ethics_board_id ) { $this->redirect( '/pages/err_study_funct_param_missing', NULL, TRUE ); }


    	// MANAGE DATA
    	$study_ethics_board_data= $this->StudyEthicsBoard->find('first',array('conditions'=>array('StudyEthicsBoard.id'=>$study_ethics_board_id, 'StudyEthicsBoard.study_summary_id'=>$study_summary_id)));
    	if(empty($study_ethics_board_data)) { $this->redirect( '/pages/err_study_no_data', null, true ); }
    	$this->data = $study_ethics_board_data;


    	// MANAGE FORM, MENU AND ACTION BUTTONS
		$this->set( 'atim_menu_variables', array('StudySummary.id'=>$study_summary_id, 'StudyEthicsBoard.id'=>$study_ethics_board_id) );
		
    	// CUSTOM CODE: FORMAT DISPLAY DATA
   		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }
		
	}


	function add( $study_summary_id ) {
		if ( !$study_summary_id ) { $this->redirect( '/pages/err_study_funct_param_missing', NULL, TRUE ); }
	
        // MANAGE DATA
        $study_ethics_board_data= $this->StudySummary->find('first',array('conditions'=>array('StudySummary.id'=>$study_summary_id), 'recursive' => '-1'));
        if(empty($study_ethics_board_data)) { $this->redirect( '/pages/err_study_no_data', null, true ); }

        // MANAGE FORM, MENU AND ACTION BUTTONS

		// $this->set('atim_structure', $this->Structures->get('form', 'familyhistories'));
		// $this->set('atim_menu', $this->Menus->get('/clinicalannotation/family_histories/listall/%%Participant.id%%'));
		$this->set( 'atim_menu_variables', array('StudySummary.id'=>$study_summary_id));
		
		
       	// CUSTOM CODE: FORMAT DISPLAY DATA

		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }
		
		if ( !empty($this->data) ) {

			// LAUNCH SAVE PROCESS
			// 1- SET ADDITIONAL DATA

			$this->data['StudyEthicsBoard']['study_summary_id'] = $study_summary_id;

			// 2- LAUNCH SPECIAL VALIDATION PROCESS
			$submitted_data_validates = true;

			// ... special validations

			// 3- CUSTOM CODE: PROCESS SUBMITTED DATA BEFORE SAVE
			$hook_link = $this->hook('presave_process');
			if( $hook_link ) { require($hook_link); }

			if($submitted_data_validates) {

				// 4- SAVE

				if ( $this->StudyEthicsBoard->save($this->data) ) {
					$this->flash( 'your data has been saved','/study/study_ethics_boards/detail/'.$study_summary_id.'/'.$this->StudyEthicsBoard->id );
					}
				}
			}
 	}


  
	function edit( $study_summary_id, $study_ethics_board_id ) {
    	if ( !$study_summary_id ) { $this->redirect( '/pages/err_study_funct_param_missing', NULL, TRUE ); }
		if ( !$study_ethics_board_id ) { $this->redirect( '/pages/err_study_funct_param_missing', NULL, TRUE ); }
		
		// MANAGE DATA
		$study_ethics_board_data= $this->StudyEthicsBoard->find('first',array('conditions'=>array('StudyEthicsBoard.id'=>$study_ethics_board_id, 'StudyEthicsBoard.study_summary_id'=>$study_summary_id)));
		if(empty($study_ethics_board_data)) { $this->redirect( '/pages/err_study_no_data', null, true ); }


		// MANAGE FORM, MENU AND ACTION BUTTONS
		$this->set( 'atim_menu_variables', array('StudySummary.id'=>$study_summary_id, 'StudyEthicsBoard.id'=>$study_ethics_board_id) );
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }
		


		if (empty($this->data) ) {
			$this->data = $study_ethics_board_data;
			} else {
				// 1- SET ADDITIONAL DATA

				//....

				// 2- LAUNCH SPECIAL VALIDATION PROCESS

				$submitted_data_validates = true;

				// ... special validations

				// 3- CUSTOM CODE: PROCESS SUBMITTED DATA BEFORE SAVE

				$hook_link = $this->hook('presave_process');
				if( $hook_link ) { require($hook_link); }

				if($submitted_data_validates) {

					// 4- SAVE

					$this->StudyEthicsBoard->id = $study_ethics_board_id;
					if ( $this->StudyEthicsBoard->save($this->data) ) {
						$this->flash( 'your data has been updated','/study/study_ethics_boards/detail/'.$study_summary_id.'/'.$study_ethics_board_id );
						}
					}
				}
	}

  
	function delete( $study_summary_id, $study_ethics_board_id ) {
		if ( !$study_summary_id ) { $this->redirect( '/pages/err_study_funct_param_missing', NULL, TRUE ); }
		if ( !$study_ethics_board_id ) { $this->redirect( '/pages/err_study_funct_param_missing', NULL, TRUE ); }
		
		// MANAGE DATA
		$study_ethics_board_data= $this->StudyEthicsBoard->find('first',array('conditions'=>array('StudyEthicsBoard.id'=>$study_ethics_board_id, 'StudyEthicsBoard.study_summary_id'=>$study_summary_id)));
		if(empty($study_ethics_board_data)) { $this->redirect( '/pages/err_study_no_data', null, true ); }

		$arr_allow_deletion = $this->allowStudyEthicsBoardDeletion($study_ethics_board_id);


		// CUSTOM CODE
		$hook_link = $this->hook('delete');
		if( $hook_link ) { require($hook_link); }


		if($arr_allow_deletion['allow_deletion']) {

			// DELETE DATA

			if( $this->StudyEthicsBoard->atim_delete( $study_ethics_board_id ) ) {
				$this->flash( 'your data has been deleted', '/study/study_ethics_boards/listall/'.$study_summary_id );
			} else {
				$this->flash( 'error deleting data - contact administrator.', '/study/study_ethics_boards/listall/'.$study_summary_id );
			}
		}else {
				$this->flash($arr_allow_deletion['msg'], '/study/study_ethics_boards/detail/'.$study_summary_id.'/'.$study_ethics_board_id);
		}
	}


/* --------------------------------------------------------------------------
* ADDITIONAL FUNCTIONS
* -------------------------------------------------------------------------- */

/**
 * Check if a record can be deleted.
 *
 * @param $family_history_id Id of the studied record.
 *
 * @return Return results as array:
 * 	['allow_deletion'] = true/false
 * 	['msg'] = message to display when previous field equals false
 *
 * @author N. Luc
 * @since 2007-10-16
 */

	function allowStudyEthicsBoardDeletion($study_ethics_board_id){
		//$returned_nbr = $this->LinkedModel->find('count', array('conditions' => array('LinkedModel.family_history_id' => $family_history_id), 'recursive' => '-1'));
		//if($returned_nbr > 0) { return array('allow_deletion' => false, 'msg' => 'a LinkedModel exists for the deleted family history'); }

		return array('allow_deletion' => true, 'msg' => '');
	}

}

?>
