<?php

class ReproductiveHistoriesController extends ClinicalAnnotationAppController {
	
	var $uses = array(
		'Clinicalannotation.ReproductiveHistory',
		'Clinicalannotation.Participant'
	);
	var $paginate = array('ReproductiveHistory'=>array('limit'=>10,'order'=>'ReproductiveHistory.date_captured'));
	
	function listall( $participant_id ) {
		if ( !$participant_id ) { $this->redirect( 'err_clin_funct_param_missing', NULL, TRUE ); }

		// MANAGE DATA
		$participant_data = $this->Participant->find('first', array('conditions'=>array('Participant.id'=>$participant_id), 'recursive' => '-1'));		
		if(empty($participant_data)) { $this->redirect( '/pages/err_clin_no_data', null, true ); }
	
		$this->data = $this->paginate($this->ReproductiveHistory, array('ReproductiveHistory.participant_id'=>$participant_id));
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id));
				
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }
	}
	
	function detail( $participant_id, $reproductive_history_id ) {
		if ( !$participant_id && !$reproductive_history_id ) { $this->redirect( '/pages/err_clin_funct_param_missing', NULL, TRUE ); }
		
		// MANAGE DATA
		$reproductive_data = $this->ReproductiveHistory->find('first', array('conditions'=>array('ReproductiveHistory.id'=>$reproductive_history_id, 'ReproductiveHistory.participant_id'=>$participant_id), 'recursive' => '-1'));		
		if(empty($reproductive_data)) { $this->redirect( '/pages/err_clin_no_data', null, true ); }
		$this->data = $reproductive_data;
		
		$this->data = $this->ReproductiveHistory->find('first',array('conditions'=>array('ReproductiveHistory.id'=>$reproductive_history_id)));
		// MANAGE FORM, MENU AND ACTION BUTTONS
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id, 'ReproductiveHistory.id'=>$reproductive_history_id) );
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }	
	}
	
	function add( $participant_id=null ) {
		if ( !$participant_id ) { $this->redirect( '/pages/err_clin_funct_param_missing', NULL, TRUE ); }

		// MANAGE DATA
		$participant_data = $this->Participant->find('first', array('conditions'=>array('Participant.id'=>$participant_id), 'recursive' => '-1'));
		if(empty($participant_data)) { $this->redirect( '/pages/err_clin_no_data', null, true ); }
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id));
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }
	
		if ( !empty($this->data) ) {
			$this->data['ReproductiveHistory']['participant_id'] = $participant_id;
			
			$submitted_data_validates = true;
			// ... special validations
			
			// CUSTOM CODE: PROCESS SUBMITTED DATA BEFORE SAVE
			$hook_link = $this->hook('presave_process');
			if( $hook_link ) { require($hook_link); }
			
			if($submitted_data_validates) {
				if ( $this->ReproductiveHistory->save($this->data) ) {
					$this->flash( 'your data has been saved','/clinicalannotation/reproductive_histories/detail/'.$participant_id.'/'.$this->ReproductiveHistory->id );
				}			
			}
		}
	}
	
	function edit( $participant_id, $reproductive_history_id) {
		if (( !$participant_id ) && ( !$reproductive_history_id )) { $this->redirect( '/pages/err_clin_funct_param_missing', NULL, TRUE ); }
		
		// MANAGE DATA
		$reproductive_history_data = $this->ReproductiveHistory->find('first',array('conditions'=>array('ReproductiveHistory.id'=>$reproductive_history_id, 'ReproductiveHistory.participant_id'=>$participant_id)));
		if(empty($reproductive_history_data)) { $this->redirect( '/pages/err_clin_no_data', null, true ); }	
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id, 'ReproductiveHistory.id'=>$reproductive_history_id) );
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }	

		if(empty($this->data)) {
			$this->data = $reproductive_history_data;
		} else {
			$submitted_data_validates = true;
			// ... special validations
			
			// CUSTOM CODE: PROCESS SUBMITTED DATA BEFORE SAVE
			$hook_link = $this->hook('presave_process');
			if( $hook_link ) { require($hook_link); }
			
			if($submitted_data_validates) {
				$this->ReproductiveHistory->id = $reproductive_history_id;
				if ( $this->ReproductiveHistory->save($this->data) ) {
					$this->flash( 'your data has been updated','/clinicalannotation/reproductive_histories/detail/'.$participant_id.'/'.$reproductive_history_id );
				}
			}
		}
	}

	function delete( $participant_id, $reproductive_history_id ) {
		if (( !$participant_id ) && ( !$reproductive_history_id )) { $this->redirect( '/pages/err_clin_funct_param_missing', NULL, TRUE ); }	
		
		// MANAGE DATA
		$reproductive_history_data = $this->ReproductiveHistory->find('first',array('conditions'=>array('ReproductiveHistory.id'=>$reproductive_history_id, 'ReproductiveHistory.participant_id'=>$participant_id)));
		if(empty($reproductive_history_data)) { $this->redirect( '/pages/err_clin_no_data', null, true ); }	

		$arr_allow_deletion = $this->allowReproductiveHistoryDeletion($reproductive_history_id);
		
		// CUSTOM CODE
		$hook_link = $this->hook('delete');
		if( $hook_link ) { require($hook_link); }
		
		if($arr_allow_deletion['allow_deletion']) {
			// DELETE DATA
			$flash_link = '/clinicalannotation/reproductive_histories/listall/'.$participant_id;
			if ($this->ReproductiveHistory->atim_delete($reproductive_history_id)) {
				$this->flash( 'your data has been deleted', $flash_link );
			} else {
				$this->flash( 'error deleting data - contact administrator', $flash_link );
			}	
		} else {
			$this->flash($arr_allow_deletion['msg'], '/clinicalannotation/reproductive_histories/detail/'.$participant_id.'/'.$reproductive_history_id);	
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
	 
	function allowReproductiveHistoryDeletion($reproductive_history_id){
		//$returned_nbr = $this->LinkedModel->find('count', array('conditions' => array('LinkedModel.family_history_id' => $family_history_id), 'recursive' => '-1'));
		//if($returned_nbr > 0) { return array('allow_deletion' => false, 'msg' => 'a LinkedModel exists for the deleted family history'); }
		
		return array('allow_deletion' => true, 'msg' => '');
	}	
}

?>