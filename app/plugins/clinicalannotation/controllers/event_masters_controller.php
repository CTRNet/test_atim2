<?php

class EventMastersController extends ClinicalannotationAppController {

	var $uses = array('EventControl', 'EventMaster', 'Diagnosis');
	var $paginate = array('EventMaster'=>array('limit'=>10,'order'=>'EventMaster.date ASC')); 	

	function listall( $menu_id=NULL, $event_group=NULL, $participant_id=null ) {
		// Missing or empty function variable, send to ERROR page
		if ( !$participant_id ) { $this->redirect( '/pages/err_clin-ann_no_part_id', NULL, TRUE ); }
		
/*		// get all DX rows, for EVENT FILTER pulldown && DX input
		$criteria = 'participant_id="'.$participant_id.'"';
		$order = 'case_number ASC, dx_date ASC';
		$this->set( 'dx_listall', $this->Diagnosis->findAll( $criteria, NULL, $order ) );
*/
		// set SESSION var of EVENT PRIMARY to blank or form value
		if ( isset($this->params['form']['event_filter']) ) {
			$_SESSION['ctrapp_core']['clinical_annotation']['event_filter'] = $this->params['form']['event_filter'];
		} else if ( !isset( $_SESSION['ctrapp_core']['clinical_annotation']['event_filter'] ) ) {
			$_SESSION['ctrapp_core']['clinical_annotation']['event_filter'] = '';
		}

/*		// build EVENT FILTER LIST
		$event_filter_array = array();
		if ( $_SESSION['ctrapp_core']['clinical_annotation']['event_filter']!=='' ) {
			if ( substr($_SESSION['ctrapp_core']['clinical_annotation']['event_filter'],0,1)=='p' ) {
				// get ROWS of DXs with matching EVENT PRIMARY
				$criteria = 'participant_id="'.$participant_id.'" AND case_number="'.substr($_SESSION['ctrapp_core']['clinical_annotation']['event_filter'],1).'"';
				$event_filter_result = $this->Diagnosis->findAll( $criteria );
			} else {
				// get ROWS of DXs with EXACT ID
				$criteria = 'participant_id="'.$participant_id.'" AND id="'.$_SESSION['ctrapp_core']['clinical_annotation']['event_filter'].'"';
				$event_filter_result = $this->Diagnosis->findAll( $criteria );
			}

			// add DX ids to CRITERIA array list
			foreach( $event_filter_result as $dx ) {
				$event_filter_array[] = $dx['Diagnosis']['id'];
			}
		}
*/
		// build criteria, append EVENT_FILTER if any...
		$criteria = 'EventMaster.participant_id="'.$participant_id.'" AND EventMaster.event_group="'.$event_group.'"';
		if ( $_SESSION['ctrapp_core']['clinical_annotation']['event_filter']!=='' ) {
			$criteria .= ' AND ( EventMaster.diagnosis_id="'.implode( '" OR EventMaster.diagnosis_id="', $event_filter_array ).'" )';
		}

		$this->data = $this->paginate($this->EventMaster, array('EventMaster.participant_id'=>$participant_id));
/*
		$conditions = array();
		$conditions['event_group'] = $event_group;
		$conditions = array_filter($conditions);

		// findall EVENTCONTROLS, for ADD form
		$this->set( 'event_controls', $this->EventControl->findAll( $conditions ) );
*/
	}
}

?>