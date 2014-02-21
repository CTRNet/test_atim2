<?php

class StudyEthicsBoardsController extends StudyAppController {
		
	var $uses = array('Study.StudyEthicsBoard','Study.StudySummary');
	var $paginate = array('StudyEthicsBoard'=>array('limit' => pagination_amount,'order'=>'StudyEthicsBoard.ethics_board'));
	
	function listall( $study_summary_id ) {
pr('Has to be reviewed before to be used in prod.');
$this->redirect( '/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true );
exit;
		// Missing or empty function variable, send to ERROR page
		if ( !$study_summary_id ) { $this->redirect( '/Pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, NULL, TRUE ); }


    	// MANAGE DATA
    	$study_ethics_board_data= $this->StudySummary->find('first',array('conditions'=>array('StudySummary.id'=>$study_summary_id), 'recursive' => '-1'));
        if(empty($study_ethics_board_data)) { $this->redirect( '/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); }

		$this->request->data = $this->paginate($this->StudyEthicsBoard, array('StudyEthicsBoard.study_summary_id'=>$study_summary_id));

		// MANAGE FORM, MENU AND ACTION BUTTONS
    	$this->set( 'atim_menu_variables', array('StudySummary.id'=>$study_summary_id));


		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }
		
	}

	function detail( $study_summary_id, $study_ethics_board_id ) {
pr('Has to be reviewed before to be used in prod.');
$this->redirect( '/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true );
exit;
		if ( !$study_summary_id ) { $this->redirect( '/Pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, NULL, TRUE ); }
		if ( !$study_ethics_board_id ) { $this->redirect( '/Pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, NULL, TRUE ); }


    	// MANAGE DATA
    	$study_ethics_board_data= $this->StudyEthicsBoard->find('first',array('conditions'=>array('StudyEthicsBoard.id'=>$study_ethics_board_id, 'StudyEthicsBoard.study_summary_id'=>$study_summary_id)));
    	if(empty($study_ethics_board_data)) { $this->redirect( '/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); }
    	$this->request->data = $study_ethics_board_data;


    	// MANAGE FORM, MENU AND ACTION BUTTONS
		$this->set( 'atim_menu_variables', array('StudySummary.id'=>$study_summary_id, 'StudyEthicsBoard.id'=>$study_ethics_board_id) );
		
    	// CUSTOM CODE: FORMAT DISPLAY DATA
   		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }
		
	}


	function add( $study_summary_id ) {
pr('Has to be reviewed before to be used in prod.');
$this->redirect( '/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true );
exit;
		if ( !$study_summary_id ) { $this->redirect( '/Pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, NULL, TRUE ); }
	
        // MANAGE DATA
        $study_ethics_board_data= $this->StudySummary->find('first',array('conditions'=>array('StudySummary.id'=>$study_summary_id), 'recursive' => '-1'));
        if(empty($study_ethics_board_data)) { $this->redirect( '/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); }

        // MANAGE FORM, MENU AND ACTION BUTTONS

		// $this->set('atim_structure', $this->Structures->get('form', 'familyhistories'));
		// $this->set('atim_menu', $this->Menus->get('/ClinicalAnnotation/FamilyHistories/listall/%%Participant.id%%'));
		$this->set( 'atim_menu_variables', array('StudySummary.id'=>$study_summary_id));
		
		
       	// CUSTOM CODE: FORMAT DISPLAY DATA

		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }
		
		if ( !empty($this->request->data) ) {

			// LAUNCH SAVE PROCESS
			// 1- SET ADDITIONAL DATA

			$this->request->data['StudyEthicsBoard']['study_summary_id'] = $study_summary_id;

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
				if ( $this->StudyEthicsBoard->save($this->request->data) ) {
					$hook_link = $this->hook('postsave_process');
					if( $hook_link ) {
						require($hook_link);
					}
					$this->atimFlash(__('your data has been saved'),'/Study/StudyEthicsBoards/detail/'.$study_summary_id.'/'.$this->StudyEthicsBoard->id );
					}
				}
			}
 	}


  
	function edit( $study_summary_id, $study_ethics_board_id ) {
pr('Has to be reviewed before to be used in prod.');
$this->redirect( '/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true );
exit;
		if ( !$study_summary_id ) { $this->redirect( '/Pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, NULL, TRUE ); }
		if ( !$study_ethics_board_id ) { $this->redirect( '/Pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, NULL, TRUE ); }
		
		// MANAGE DATA
		$study_ethics_board_data= $this->StudyEthicsBoard->find('first',array('conditions'=>array('StudyEthicsBoard.id'=>$study_ethics_board_id, 'StudyEthicsBoard.study_summary_id'=>$study_summary_id)));
		if(empty($study_ethics_board_data)) { $this->redirect( '/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); }


		// MANAGE FORM, MENU AND ACTION BUTTONS
		$this->set( 'atim_menu_variables', array('StudySummary.id'=>$study_summary_id, 'StudyEthicsBoard.id'=>$study_ethics_board_id) );
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }
		


		if (empty($this->request->data) ) {
			$this->request->data = $study_ethics_board_data;
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
					$this->StudyEthicsBoard->id = $study_ethics_board_id;
					if ( $this->StudyEthicsBoard->save($this->request->data) ) {
						$hook_link = $this->hook('postsave_process');
						if( $hook_link ) {
							require($hook_link);
						}
						$this->atimFlash(__('your data has been updated'),'/Study/StudyEthicsBoards/detail/'.$study_summary_id.'/'.$study_ethics_board_id );
						}
					}
				}
	}

  
	function delete( $study_summary_id, $study_ethics_board_id ) {
pr('Has to be reviewed before to be used in prod.');
$this->redirect( '/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true );
exit;
		if ( !$study_summary_id ) { $this->redirect( '/Pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, NULL, TRUE ); }
		if ( !$study_ethics_board_id ) { $this->redirect( '/Pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, NULL, TRUE ); }
		
		// MANAGE DATA
		$study_ethics_board_data= $this->StudyEthicsBoard->find('first',array('conditions'=>array('StudyEthicsBoard.id'=>$study_ethics_board_id, 'StudyEthicsBoard.study_summary_id'=>$study_summary_id)));
		if(empty($study_ethics_board_data)) { $this->redirect( '/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); }

		$arr_allow_deletion = $this->StudyEthicsBoard->allowDeletion($study_ethics_board_id);


		// CUSTOM CODE
		$hook_link = $this->hook('delete');
		if( $hook_link ) { require($hook_link); }


		if($arr_allow_deletion['allow_deletion']) {

			// DELETE DATA

			if( $this->StudyEthicsBoard->atimDelete( $study_ethics_board_id ) ) {
				$this->atimFlash(__('your data has been deleted'), '/Study/StudyEthicsBoards/listall/'.$study_summary_id );
			} else {
				$this->flash(__('error deleting data - contact administrator.'), '/Study/StudyEthicsBoards/listall/'.$study_summary_id );
			}
		}else {
				$this->flash(__($arr_allow_deletion['msg']), '/Study/StudyEthicsBoards/detail/'.$study_summary_id.'/'.$study_ethics_board_id);
		}
	}
}

?>
