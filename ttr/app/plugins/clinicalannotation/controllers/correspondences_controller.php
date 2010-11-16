<?php

class CorrespondencesController extends ClinicalAnnotationAppController {

	var $uses = array(
		'Clinicalannotation.Correspondence',
		'Clinicalannotation.Participant');
	var $paginate = array('Correspondence'=>array('limit' => pagination_amount,'order'=>'Correspondence.id'));

	function listall( $participant_id ) {
		if ( !$participant_id ) { $this->redirect( 'err_clin_funct_param_missing', NULL, TRUE ); }

		// MANAGE DATA
		$participant_data = $this->Participant->find('first', array('conditions'=>array('Participant.id'=>$participant_id), 'recursive' => '-1'));
		if(empty($participant_data)) { $this->redirect( '/pages/err_clin_no_data', null, true ); }

		$this->data = $this->paginate($this->Correspondence, array('Correspondence.participant_id'=>$participant_id));

		// MANAGE FORM, MENU AND ACTION BUTTONS
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id));

		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }
		//pr($this->data);
	}

	function detail( $participant_id, $correspondence_id ) {
		if ( !$participant_id && !$correspondence_id ) { $this->redirect( '/pages/err_clin_funct_param_missing', NULL, TRUE ); }

		// MANAGE DATA
		$correspondence_data = $this->Correspondence->find('first', array('conditions'=>array('Correspondence.id'=>$correspondence_id, 'Correspondence.participant_id'=>$participant_id), 'recursive' => '-1'));
		if(empty($correspondence_data)) { $this->redirect( '/pages/err_clin_no_data', null, true ); }
		$this->data = $correspondence_data;

		// MANAGE FORM, MENU AND ACTION BUTTONS
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id, 'Correspondence.id'=>$correspondence_id) );

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
			$this->data['Correspondence']['participant_id'] = $participant_id;

			$submitted_data_validates = true;
			// ... special validations

			// CUSTOM CODE: PROCESS SUBMITTED DATA BEFORE SAVE
			$hook_link = $this->hook('presave_process');
			if( $hook_link ) { require($hook_link); }

			if($submitted_data_validates) {
				if ( $this->Correspondence->save($this->data) ) {
					$this->flash( 'your data has been updated','/clinicalannotation/correspondences/detail/'.$participant_id.'/'.$this->Correspondence->id );
				}
			}
		}
	}

	function edit( $participant_id, $correspondence_id ) {
		if ( !$participant_id && !$correspondence_id ) { $this->redirect( '/pages/err_clin_funct_param_missing', NULL, TRUE ); }

		// MANAGE DATA
		$correspondence_data = $this->Correspondence->find('first', array('conditions'=>array('Correspondence.id'=>$correspondence_id, 'Correspondence.participant_id'=>$participant_id), 'recursive' => '-1'));
		if(empty($correspondence_data)) { $this->redirect( '/pages/err_clin_no_data', null, true ); }

		// MANAGE FORM, MENU AND ACTION BUTTONS
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id, 'Correspondence.id'=>$correspondence_id) );

		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }

		if(empty($this->data)) {
			$this->data = $correspondence_data;
		} else {
			$submitted_data_validates = true;
			// ... special validations

			// CUSTOM CODE: PROCESS SUBMITTED DATA BEFORE SAVE
			$hook_link = $this->hook('presave_process');
			if( $hook_link ) { require($hook_link); }

			if($submitted_data_validates) {
				$this->Correspondence->id = $correspondence_id;
				if ( $this->Correspondence->save($this->data) ) {
					$this->flash( 'your data has been updated','/clinicalannotation/correspondences/detail/'.$participant_id.'/'.$correspondence_id );
				}
			}
		}
	}

	function delete( $participant_id, $correspondence_id ) {
		if ( !$participant_id && !$correspondence_id ) { $this->redirect( '/pages/err_clin_funct_param_missing', NULL, TRUE ); }

		// MANAGE DATA
		$correspondence_data = $this->Correspondence->find('first', array('conditions'=>array('Correspondence.id'=>$correspondence_id, 'Correspondence.participant_id'=>$participant_id), 'recursive' => '-1'));
		if(empty($correspondence_data)) { $this->redirect( '/pages/err_clin_no_data', null, true ); }

		$arr_allow_deletion = $this->allowCorrespondenceDeletion($correspondence_id);

		if($arr_allow_deletion['allow_deletion']) {

			if( $this->Correspondence->atim_delete( $correspondence_id ) ) {
				$this->flash( 'your data has been deleted', '/clinicalannotation/correspondences/listall/'.$participant_id );
			} else {
				$this->flash( 'error deleting data - contact administrator', '/clinicalannotation/correspondences/listall/'.$participant_id );
			}
		} else {
			$this->flash($arr_allow_deletion['msg'], '/clinicalannotation/correspondences/detail/'.$participant_id.'/'.$correspondence_id);
		}
	}

	/* --------------------------------------------------------------------------
	 * ADDITIONAL FUNCTIONS
	 * -------------------------------------------------------------------------- */

	/**
	 * Check if a record can be deleted.
	 *
	 * @param $participant_correspondence_id Id of the studied record.
	 *
	 * @return Return results as array:
	 * 	['allow_deletion'] = true/false
	 * 	['msg'] = Correspondence to display when previous field equals false
	 *
	 * @author N. Luc
	 * @since 2007-10-16
	 */

	function allowCorrespondenceDeletion( $correspondence_id ) {
		//$returned_nbr = $this->LinkedModel->find('count', array('conditions' => array('LinkedModel.correspondence_id' => $correspondence_id), 'recursive' => '-1'));
		//if($returned_nbr > 0) { return array('allow_deletion' => false, 'msg' => 'a LinkedModel exists for the deleted correspondence'); }
		return array('allow_deletion' => true, 'msg' => '');
	}
}
?>