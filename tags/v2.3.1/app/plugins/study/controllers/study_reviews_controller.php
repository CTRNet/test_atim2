<?php

class StudyReviewsController extends StudyAppController {
			
	var $uses = array('Study.StudyReview','Study.StudySummary');
	var $paginate = array('StudyReview'=>array('limit' => pagination_amount,'order'=>'StudyReview.last_name'));
	
	function listall( $study_summary_id ) {
pr('Has to be reviewed before to be used in prod.');
$this->redirect( '/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true );
exit;
		if ( !$study_summary_id ) { $this->redirect( '/pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, NULL, TRUE ); }

    	// MANAGE DATA
    	$study_reviews_data= $this->StudySummary->find('first',array('conditions'=>array('StudySummary.id'=>$study_summary_id), 'recursive' => '-1'));
        if(empty($study_reviews_data)) { $this->redirect( '/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); }

		$this->data = $this->paginate($this->StudyReview, array('StudyReview.study_summary_id'=>$study_summary_id));


    	// MANAGE FORM, MENU AND ACTION BUTTONS
		$this->set( 'atim_menu_variables', array('StudySummary.id'=>$study_summary_id));
		
    	// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }
		
		
	}

	function detail( $study_summary_id, $study_reviews_id ) {
pr('Has to be reviewed before to be used in prod.');
$this->redirect( '/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true );
exit;
		if ( !$study_summary_id ) { $this->redirect( '/pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, NULL, TRUE ); }
		if ( !$study_reviews_id ) { $this->redirect( '/pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, NULL, TRUE ); }
		

    	// MANAGE DATA
    	$study_reviews_data= $this->StudyReview->find('first',array('conditions'=>array('StudyReview.id'=>$study_reviews_id, 'StudyReview.study_summary_id'=>$study_summary_id)));
    	if(empty($study_reviews_data)) { $this->redirect( '/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); }
    	$this->data = $study_reviews_data;

    	// MANAGE FORM, MENU AND ACTION BUTTONS
		$this->set( 'atim_menu_variables', array('StudySummary.id'=>$study_summary_id, 'StudyReview.id'=>$study_reviews_id) );
		
    	// CUSTOM CODE: FORMAT DISPLAY DATA
   		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }
		
	}


	function add( $study_summary_id ) {
pr('Has to be reviewed before to be used in prod.');
$this->redirect( '/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true );
exit;
		if ( !$study_summary_id ) { $this->redirect( '/pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, NULL, TRUE ); }

        // MANAGE DATA
        $study_reviews_data= $this->StudySummary->find('first',array('conditions'=>array('StudySummary.id'=>$study_summary_id), 'recursive' => '-1'));
        if(empty($study_reviews_data)) { $this->redirect( '/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); }
	

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

			$this->data['StudyReview']['study_summary_id'] = $study_summary_id;

			// 2- LAUNCH SPECIAL VALIDATION PROCESS
			$submitted_data_validates = true;

			// ... special validations

			// 3- CUSTOM CODE: PROCESS SUBMITTED DATA BEFORE SAVE
			$hook_link = $this->hook('presave_process');
			if( $hook_link ) { 
				require($hook_link); 
			}

			if($submitted_data_validates) {

				// 4- SAVE
				if ( $this->StudyReview->save($this->data) ) {
					$hook_link = $this->hook('postsave_process');
					if( $hook_link ) {
						require($hook_link);
					}
					$this->atimFlash( 'your data has been saved','/study/study_reviews/detail/'.$study_summary_id.'/'.$this->StudyReview->id );
					}
				}
			}
 	}



	function edit( $study_summary_id, $study_reviews_id ) {
pr('Has to be reviewed before to be used in prod.');
$this->redirect( '/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true );
exit;
		if ( !$study_summary_id ) { $this->redirect( '/pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, NULL, TRUE ); }
		if ( !$study_reviews_id ) { $this->redirect( '/pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, NULL, TRUE ); }
		
		// MANAGE DATA
		$study_reviews_data= $this->StudyReview->find('first',array('conditions'=>array('StudyReview.id'=>$study_reviews_id, 'StudyReview.study_summary_id'=>$study_summary_id)));
		if(empty($study_reviews_data)) { $this->redirect( '/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); }


		// MANAGE FORM, MENU AND ACTION BUTTONS
		$this->set( 'atim_menu_variables', array('StudySummary.id'=>$study_summary_id, 'StudyReview.id'=>$study_reviews_id) );
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }

		
		if (empty($this->data) ) {
			$this->data = $study_reviews_data;
			} else {
				// 1- SET ADDITIONAL DATA

				//....

				// 2- LAUNCH SPECIAL VALIDATION PROCESS

				$submitted_data_validates = true;

				// ... special validations

				// 3- CUSTOM CODE: PROCESS SUBMITTED DATA BEFORE SAVE

				$hook_link = $this->hook('presave_process');
				if( $hook_link ) { 
					require($hook_link); 
				}

				if($submitted_data_validates) {

					// 4- SAVE
					$this->StudyReview->id = $study_reviews_id;
					if ( $this->StudyReview->save($this->data) ) {
						$hook_link = $this->hook('postsave_process');
						if( $hook_link ) {
							require($hook_link);
						}
						$this->atimFlash( 'your data has been updated','/study/study_reviews/detail/'.$study_summary_id.'/'.$study_reviews_id );
						}
					}
				}
	}

  
	function delete( $study_summary_id, $study_reviews_id ) {
pr('Has to be reviewed before to be used in prod.');
$this->redirect( '/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true );
exit;
		if ( !$study_summary_id ) { $this->redirect( '/pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, NULL, TRUE ); }
		if ( !$study_reviews_id ) { $this->redirect( '/pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, NULL, TRUE ); }
		
		// MANAGE DATA
		$study_reviews_data= $this->StudyReview->find('first',array('conditions'=>array('StudyReview.id'=>$study_reviews_id, 'StudyReview.study_summary_id'=>$study_summary_id)));
		if(empty($study_reviews_data)) { $this->redirect( '/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); }

		$arr_allow_deletion = $this->StudyReview->allowDeletion($study_reviews_id);


		// CUSTOM CODE
		$hook_link = $this->hook('delete');
		if( $hook_link ) { require($hook_link); }

			if($arr_allow_deletion['allow_deletion']) {

				// DELETE DATA

				if( $this->StudyReview->atim_delete( $study_reviews_id ) ) {
					$this->atimFlash( 'your data has been deleted', '/study/study_reviews/listall/'.$study_summary_id );
				} else {
					$this->flash( 'error deleting data - contact administrator.', '/study/study_reviews/listall/'.$study_summary_id );
				}
			}else {
					$this->flash($arr_allow_deletion['msg'], '/study/study_reviews/detail/'.$study_summary_id.'/'.$study_reviews_id);
			}
	}
}

?>
