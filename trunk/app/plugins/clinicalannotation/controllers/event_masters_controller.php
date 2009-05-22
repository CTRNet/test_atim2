<?php

class EventMastersController extends ClinicalannotationAppController {

	var $uses = array('EventControl', 'EventMaster', 'Diagnosis');
	var $paginate = array('EventMaster'=>array('limit'=>10,'order'=>'EventMaster.event_date ASC')); 	

	function listall( $menu_id=NULL, $event_group=NULL, $participant_id=null ) {
		// Missing or empty function variable, send to ERROR page
		if ( !$participant_id ) { $this->redirect( '/pages/err_clin-ann_no_part_id', NULL, TRUE ); }
		
		// get all DX rows, for EVENT FILTER pulldown && DX input
		$this->set('dx_listall', $this->Diagnosis->find('all',array('conditions'=>array('Diagnosis.participant_id'=>$participant_id))));
		
		// set SESSION var of EVENT PRIMARY to blank or form value
		if ( isset($this->params['form']['event_filter']) ) {
			$_SESSION['ctrapp_core']['clinical_annotation']['event_filter'] = $this->params['form']['event_filter'];
		} else if ( !isset( $_SESSION['ctrapp_core']['clinical_annotation']['event_filter'] ) ) {
			$_SESSION['ctrapp_core']['clinical_annotation']['event_filter'] = '';
		}

		// build EVENT FILTER LIST
		$event_filter_array = array();
		if ( $_SESSION['ctrapp_core']['clinical_annotation']['event_filter']!=='' ) {
			if ( substr($_SESSION['ctrapp_core']['clinical_annotation']['event_filter'],0,1)=='p' ) {
				// get ROWS of DXs with matching EVENT PRIMARY
				$case_number = substr($_SESSION['ctrapp_core']['clinical_annotation']['event_filter'],1);
				$event_filter_result = $this->Diagnosis->find('all',array('conditions'=>array('participant_id'=>$participant_id, 'case_number'=>$case_number)));
			} else {
				// get ROWS of DXs with EXACT ID
				$case_number = substr($_SESSION['ctrapp_core']['clinical_annotation']['event_filter'],1);
				$event_filter_result = $this->Diagnosis->find('all',array('conditions'=>array('participant_id'=>$participant_id, 'case_number'=>$case_number)));
			}

			// add DX ids to CRITERIA array list
			foreach( $event_filter_result as $dx ) {
				$event_filter_array[] = $dx['Diagnosis']['id'];
			}
		}

		// build criteria, append EVENT_FILTER if any...
		$criteria = 'EventMaster.participant_id="'.$participant_id.'" AND EventMaster.event_group="'.$event_group.'"';
		if ( $_SESSION['ctrapp_core']['clinical_annotation']['event_filter']!=='' ) {
			$criteria .= ' AND ( EventMaster.diagnosis_id="'.implode( '" OR EventMaster.diagnosis_id="', $event_filter_array ).'" )';
		}
		
		// Set view variables
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id) );
		$this->set('menu_id', $menu_id);
		$this->set('event_group', $event_group);
		
		$this->data = $this->paginate($this->EventMaster, array('EventMaster.participant_id'=>$participant_id));

		// find all EVENTCONTROLS, for ADD form
		$this->set('event_controls', $this->EventControl->find('all', array('conditions'=>array('event_group'=>$event_group))));
	}
}

?>