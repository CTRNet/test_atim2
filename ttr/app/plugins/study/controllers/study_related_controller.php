<?php

class StudyRelatedController extends StudyAppController {
			
	var $uses = array('Study.StudyRelated','Study.StudySummary');
	var $paginate = array('StudyRelated'=>array('limit' => pagination_amount,'order'=>'StudyRelated.title'));
	
	function listall( $study_summary_id ) {
		if ( !$study_summary_id ) { $this->redirect( '/pages/err_study_funct_param_missing', NULL, TRUE ); }

    	// MANAGE DATA
    	$study_related_data= $this->StudySummary->find('first',array('conditions'=>array('StudySummary.id'=>$study_summary_id), 'recursive' => '-1'));
        if(empty($study_related_data)) { $this->redirect( '/pages/err_study_no_data', null, true ); }

		$this->data = $this->paginate($this->StudyRelated, array('StudyRelated.study_summary_id'=>$study_summary_id));


    	// MANAGE FORM, MENU AND ACTION BUTTONS
		$this->set( 'atim_menu_variables', array('StudySummary.id'=>$study_summary_id));
		
    	// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }
		
		
	}

	function detail( $study_summary_id, $study_related_id ) {
		if ( !$study_summary_id ) { $this->redirect( '/pages/err_study_funct_param_missing', NULL, TRUE ); }
		if ( !$study_related_id ) { $this->redirect( '/pages/err_study_funct_param_missing', NULL, TRUE ); }
		

    	// MANAGE DATA
    	$study_related_data= $this->StudyRelated->find('first',array('conditions'=>array('StudyRelated.id'=>$study_related_id, 'StudyRelated.study_summary_id'=>$study_summary_id)));
    	if(empty($study_related_data)) { $this->redirect( '/pages/err_study_no_data', null, true ); }
    	$this->data = $study_related_data;

    	// MANAGE FORM, MENU AND ACTION BUTTONS
		$this->set( 'atim_menu_variables', array('StudySummary.id'=>$study_summary_id, 'StudyRelated.id'=>$study_related_id) );
		
    	// CUSTOM CODE: FORMAT DISPLAY DATA
   		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }
		
	}


	function add( $study_summary_id ) {
		if ( !$study_summary_id ) { $this->redirect( '/pages/err_study_funct_param_missing', NULL, TRUE ); }

        // MANAGE DATA
        $study_related_data= $this->StudySummary->find('first',array('conditions'=>array('StudySummary.id'=>$study_summary_id), 'recursive' => '-1'));
        if(empty($study_related_data)) { $this->redirect( '/pages/err_study_no_data', null, true ); }
	

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

			$this->data['StudyRelated']['study_summary_id'] = $study_summary_id;

			// 2- LAUNCH SPECIAL VALIDATION PROCESS
			$submitted_data_validates = true;

			// ... special validations

			// 3- CUSTOM CODE: PROCESS SUBMITTED DATA BEFORE SAVE
			$hook_link = $this->hook('presave_process');
			if( $hook_link ) { require($hook_link); }

			if($submitted_data_validates) {

				// 4- SAVE

				if ( $this->StudyRelated->save($this->data) ) {
					$this->atimFlash( 'your data has been saved','/study/study_related/detail/'.$study_summary_id.'/'.$this->StudyRelated->id );
					}
				}
			}
 	}



	function edit( $study_summary_id, $study_related_id ) {
    	if ( !$study_summary_id ) { $this->redirect( '/pages/err_study_funct_param_missing', NULL, TRUE ); }
		if ( !$study_related_id ) { $this->redirect( '/pages/err_study_funct_param_missing', NULL, TRUE ); }
		
		// MANAGE DATA
		$study_related_data= $this->StudyRelated->find('first',array('conditions'=>array('StudyRelated.id'=>$study_related_id, 'StudyRelated.study_summary_id'=>$study_summary_id)));
		if(empty($study_related_data)) { $this->redirect( '/pages/err_study_no_data', null, true ); }


		// MANAGE FORM, MENU AND ACTION BUTTONS
		$this->set( 'atim_menu_variables', array('StudySummary.id'=>$study_summary_id, 'StudyRelated.id'=>$study_related_id) );
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }

		
		if (empty($this->data) ) {
			$this->data = $study_related_data;
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

					$this->StudyRelated->id = $study_related_id;
					if ( $this->StudyRelated->save($this->data) ) {
						$this->atimFlash( 'your data has been updated','/study/study_related/detail/'.$study_summary_id.'/'.$study_related_id );
						}
					}
				}
	}

  
	function delete( $study_summary_id, $study_related_id ) {
		if ( !$study_summary_id ) { $this->redirect( '/pages/err_study_funct_param_missing', NULL, TRUE ); }
		if ( !$study_related_id ) { $this->redirect( '/pages/err_study_funct_param_missing', NULL, TRUE ); }
		
		// MANAGE DATA
		$study_related_data= $this->StudyRelated->find('first',array('conditions'=>array('StudyRelated.id'=>$study_related_id, 'StudyRelated.study_summary_id'=>$study_summary_id)));
		if(empty($study_related_data)) { $this->redirect( '/pages/err_study_no_data', null, true ); }

		$arr_allow_deletion = $this->allowStudyRelatedDeletion($study_related_id);


		// CUSTOM CODE
		$hook_link = $this->hook('delete');
		if( $hook_link ) { require($hook_link); }

			if($arr_allow_deletion['allow_deletion']) {

				// DELETE DATA

				if( $this->StudyRelated->atim_delete( $study_related_id ) ) {
					$this->atimFlash( 'your data has been deleted', '/study/study_related/listall/'.$study_summary_id );
				} else {
					$this->flash( 'error deleting data - contact administrator.', '/study/study_related/listall/'.$study_summary_id );
				}
			}else {
					$this->flash($arr_allow_deletion['msg'], '/study/study_related/detail/'.$study_summary_id.'/'.$study_related_id);
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

	function allowStudyRelatedDeletion($study_related_id){
		//$returned_nbr = $this->LinkedModel->find('count', array('conditions' => array('LinkedModel.family_history_id' => $family_history_id), 'recursive' => '-1'));
		//if($returned_nbr > 0) { return array('allow_deletion' => false, 'msg' => 'a LinkedModel exists for the deleted family history'); }

		return array('allow_deletion' => true, 'msg' => '');
	}
}

?>
