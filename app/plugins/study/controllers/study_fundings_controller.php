<?php

class StudyFundingsController extends StudyAppController {
		
	var $uses = array('Study.StudyFunding','Study.StudySummary');
	var $paginate = array('StudyFunding'=>array('limit'=>10,'order'=>'StudyFunding.study_sponsor'));
	
	function listall( $study_summary_id ) {
		// Missing or empty function variable, send to ERROR page
		if ( !$study_summary_id ) { $this->redirect( '/pages/err_study_funct_param_missing', NULL, TRUE ); }


    	// MANAGE DATA
    	$study_funding_data= $this->StudySummary->find('first',array('conditions'=>array('StudySummary.id'=>$study_summary_id), 'recursive' => '-1'));
        if(empty($study_funding_data)) { $this->redirect( '/pages/err_study_no_data', null, true ); }

		$this->data = $this->paginate($this->StudyFunding, array('StudyFunding.study_summary_id'=>$study_summary_id));


    	// MANAGE FORM, MENU AND ACTION BUTTONS
		$this->set( 'atim_menu_variables', array('StudySummary.id'=>$study_summary_id));
		
    	// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }
		
		
	}


	function detail( $study_summary_id, $study_funding_id ) {
		if ( !$study_summary_id ) { $this->redirect( '/pages/err_study_funct_param_missing', NULL, TRUE ); }
		if ( !$study_funding_id ) { $this->redirect( '/pages/err_study_funct_param_missing', NULL, TRUE ); }
		
    	// MANAGE DATA
    	$study_funding_data= $this->StudyFunding->find('first',array('conditions'=>array('StudyFunding.id'=>$study_funding_id, 'StudyFunding.study_summary_id'=>$study_summary_id)));
    	if(empty($study_funding_data)) { $this->redirect( '/pages/err_study_no_data', null, true ); }
    	$this->data = $study_funding_data;

    	// MANAGE FORM, MENU AND ACTION BUTTONS
		$this->set( 'atim_menu_variables', array('StudySummary.id'=>$study_summary_id, 'StudyFunding.id'=>$study_funding_id) );
		
    	// CUSTOM CODE: FORMAT DISPLAY DATA
   		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }
		
	}


	function add( $study_summary_id ) {
		if ( !$study_summary_id ) { $this->redirect( '/pages/err_study_funct_param_missing', NULL, TRUE ); }
	

        // MANAGE DATA
        $study_funding_data= $this->StudySummary->find('first',array('conditions'=>array('StudySummary.id'=>$study_summary_id), 'recursive' => '-1'));
        if(empty($study_funding_data)) { $this->redirect( '/pages/err_study_no_data', null, true ); }

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

			$this->data['StudyFunding']['study_summary_id'] = $study_summary_id;

			// 2- LAUNCH SPECIAL VALIDATION PROCESS
			$submitted_data_validates = true;

			// ... special validations

			// 3- CUSTOM CODE: PROCESS SUBMITTED DATA BEFORE SAVE
			$hook_link = $this->hook('presave_process');
			if( $hook_link ) { require($hook_link); }

			if($submitted_data_validates) {

				// 4- SAVE

				if ( $this->StudyFunding->save($this->data) ) {
					$this->flash( 'your data has been saved.','/study/study_contacts/detail/'.$study_summary_id.'/'.$this->StudyFunding->id );
					}
				}
			}
 	}


  
	function edit( $study_summary_id, $study_funding_id ) {
    	if ( !$study_summary_id ) { $this->redirect( '/pages/err_study_funct_param_missing', NULL, TRUE ); }
		if ( !$study_funding_id ) { $this->redirect( '/pages/err_study_funct_param_missing', NULL, TRUE ); }
		
		// MANAGE DATA
		$study_funding_data= $this->StudyFunding->find('first',array('conditions'=>array('StudyFunding.id'=>$study_funding_id, 'StudyFunding.study_summary_id'=>$study_summary_id)));
		if(empty($study_funding_data)) { $this->redirect( '/pages/err_study_no_data', null, true ); }


		// MANAGE FORM, MENU AND ACTION BUTTONS
		$this->set( 'atim_menu_variables', array('StudySummary.id'=>$study_summary_id, 'StudyFunding.id'=>$study_funding_id) );
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }
		

		if (empty($this->data) ) {
			$this->data = $study_funding_data
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

					$this->StudyFunding->id = $study_funding_id;
					if ( $this->StudyFunding->save($this->data) ) {
						$this->flash( 'your data has been updated.','/study/study_fundings/detail/'.$study_summary_id.'/'.$study_funding_id );
						}
					}
				}
	}


  
	function delete( $study_summary_id, $study_funding_id ) {
		if ( !$study_summary_id ) { $this->redirect( '/pages/err_study_funct_param_missing', NULL, TRUE ); }
		if ( !$study_funding_id ) { $this->redirect( '/pages/err_study_funct_param_missing', NULL, TRUE ); }
		
		// MANAGE DATA
		$study_funding_data= $this->StudyFunding->find('first',array('conditions'=>array('StudyFunding.id'=>$study_funding_id, 'StudyFunding.study_summary_id'=>$study_summary_id)));
		if(empty($study_funding_data)) { $this->redirect( '/pages/err_study_no_data', null, true ); }

		$arr_allow_deletion = $this->allowStudyFundingDeletion($study_funding_id);


		// CUSTOM CODE
		$hook_link = $this->hook('delete');
		if( $hook_link ) { require($hook_link); }

			if($arr_allow_deletion['allow_deletion']) {

				// DELETE DATA

				if( $this->StudyFunding->atim_delete( $study_funding_id ) ) {
					$this->flash( 'your data has been deleted.', '/study/study_fundings/listall/'.$study_summary_id );
				} else {
					$this->flash( 'error deleting data - contact administrator.', '/study/study_fundings/listall/'.$study_summary_id );
				}
			}else {
					$this->flash($arr_allow_deletion['msg'], '/study/study_fundings/detail/'.$study_summary_id.'/'.$study_fundings_id);
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

	function allowStudyFundingDeletion($study_funding_id){
		//$returned_nbr = $this->LinkedModel->find('count', array('conditions' => array('LinkedModel.family_history_id' => $family_history_id), 'recursive' => '-1'));
		//if($returned_nbr > 0) { return array('allow_deletion' => false, 'msg' => 'a LinkedModel exists for the deleted family history'); }

		return array('allow_deletion' => true, 'msg' => '');
	}

}

?>