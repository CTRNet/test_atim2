<?php

class ReproductiveHistoriesController extends ClinicalAnnotationAppController {
	
	var $uses = array(
		'ClinicalAnnotation.ReproductiveHistory',
		'ClinicalAnnotation.Participant'
	);
	var $paginate = array('ReproductiveHistory'=>array('limit' => pagination_amount,'order'=>'ReproductiveHistory.date_captured'));
	
	function listall( $participant_id ) {
		if ( !$participant_id ) { $this->redirect( 'err_clin_funct_param_missing', NULL, TRUE ); }

		// MANAGE DATA
		$participant_data = $this->Participant->find('first', array('conditions'=>array('Participant.id'=>$participant_id), 'recursive' => '-1'));		
		if(empty($participant_data)) { $this->redirect( '/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); }
	
		$this->request->data = $this->paginate($this->ReproductiveHistory, array('ReproductiveHistory.participant_id'=>$participant_id));
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id));
				
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }
	}
	
	function detail( $participant_id, $reproductive_history_id ) {
		if ( !$participant_id && !$reproductive_history_id ) { $this->redirect( '/Pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, NULL, TRUE ); }
		
		// MANAGE DATA
		$reproductive_data = $this->ReproductiveHistory->find('first', array('conditions'=>array('ReproductiveHistory.id'=>$reproductive_history_id, 'ReproductiveHistory.participant_id'=>$participant_id), 'recursive' => '-1'));		
		if(empty($reproductive_data)) { $this->redirect( '/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); }
		$this->request->data = $reproductive_data;
		
		$this->request->data = $this->ReproductiveHistory->find('first',array('conditions'=>array('ReproductiveHistory.id'=>$reproductive_history_id)));
		// MANAGE FORM, MENU AND ACTION BUTTONS
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id, 'ReproductiveHistory.id'=>$reproductive_history_id) );
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }	
	}
	
	function add( $participant_id=null ) {
		if ( !$participant_id ) { $this->redirect( '/Pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, NULL, TRUE ); }

		// MANAGE DATA
		$participant_data = $this->Participant->find('first', array('conditions'=>array('Participant.id'=>$participant_id), 'recursive' => '-1'));
		if(empty($participant_data)) { $this->redirect( '/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); }
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id));
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }
	
		if ( !empty($this->request->data) ) {
			$this->request->data['ReproductiveHistory']['participant_id'] = $participant_id;
			
			$submitted_data_validates = true;
			// ... special validations
			
			// CUSTOM CODE: PROCESS SUBMITTED DATA BEFORE SAVE
			$hook_link = $this->hook('presave_process');
			if( $hook_link ) { 
				require($hook_link); 
			}
			
			if($submitted_data_validates) {
				if ( $this->ReproductiveHistory->save($this->request->data) ) {
					$hook_link = $this->hook('postsave_process');
					if( $hook_link ) { 
						require($hook_link); 
					}
					$this->atimFlash( 'your data has been saved','/ClinicalAnnotation/reproductive_histories/detail/'.$participant_id.'/'.$this->ReproductiveHistory->id );
				}			
			}
		}
	}
	
	function edit( $participant_id, $reproductive_history_id) {
		if (( !$participant_id ) && ( !$reproductive_history_id )) { $this->redirect( '/Pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, NULL, TRUE ); }
		
		// MANAGE DATA
		$reproductive_history_data = $this->ReproductiveHistory->find('first',array('conditions'=>array('ReproductiveHistory.id'=>$reproductive_history_id, 'ReproductiveHistory.participant_id'=>$participant_id)));
		if(empty($reproductive_history_data)) { $this->redirect( '/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); }	
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id, 'ReproductiveHistory.id'=>$reproductive_history_id) );
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }	

		if(empty($this->request->data)) {
			$this->request->data = $reproductive_history_data;
		} else {
			$submitted_data_validates = true;
			// ... special validations
			
			// CUSTOM CODE: PROCESS SUBMITTED DATA BEFORE SAVE
			$hook_link = $this->hook('presave_process');
			if( $hook_link ) { 
				require($hook_link); 
			}
			
			if($submitted_data_validates) {
				$this->ReproductiveHistory->id = $reproductive_history_id;
				if ( $this->ReproductiveHistory->save($this->request->data) ) {
					$hook_link = $this->hook('postsave_process');
					if( $hook_link ) { 
						require($hook_link); 
					}
					$this->atimFlash( 'your data has been updated','/ClinicalAnnotation/reproductive_histories/detail/'.$participant_id.'/'.$reproductive_history_id );
				}
			}
		}
	}

	function delete( $participant_id, $reproductive_history_id ) {
		if (( !$participant_id ) && ( !$reproductive_history_id )) { $this->redirect( '/Pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, NULL, TRUE ); }	
		
		// MANAGE DATA
		$reproductive_history_data = $this->ReproductiveHistory->find('first',array('conditions'=>array('ReproductiveHistory.id'=>$reproductive_history_id, 'ReproductiveHistory.participant_id'=>$participant_id)));
		if(empty($reproductive_history_data)) { $this->redirect( '/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); }	

		$arr_allow_deletion = $this->allowReproductiveHistoryDeletion($reproductive_history_id);
		
		// CUSTOM CODE
		$hook_link = $this->hook('delete');
		if( $hook_link ) { require($hook_link); }
		
		if($arr_allow_deletion['allow_deletion']) {
			// DELETE DATA
			$flash_link = '/ClinicalAnnotation/reproductive_histories/listall/'.$participant_id;
			if ($this->ReproductiveHistory->atimDelete($reproductive_history_id)) {
				$this->atimFlash( 'your data has been deleted', $flash_link );
			} else {
				$this->flash( 'error deleting data - contact administrator', $flash_link );
			}	
		} else {
			$this->flash($arr_allow_deletion['msg'], '/ClinicalAnnotation/reproductive_histories/detail/'.$participant_id.'/'.$reproductive_history_id);	
		}
	}
}

?>