<?php

class TreatmentExtendsController extends ClinicalAnnotationAppController {

	var $name = 'TreatmentExtends';
	var $uses = array( 'TreatmentMaster', 'TreatmentExtend', 'Drug' );

	var $components = array('Summaries');
	var $helpers = array('Summaries');

	function beforeFilter() {

		// $auth_conf array hardcoded in oth_auth component, due to plugins compatibility
		$this->othAuth->controller = &$this;
		$this->othAuth->init();
		$this->othAuth->check();

		// CakePHP function to re-combine dat/time select fields
		$this->cleanUpFields();

	}

	function index() {
		// nothing...
	}

	function listall( $participant_id=0, $tx_master_id=0 ) {

		// get Extend tablename and form_alias from Master row

			$this->TreatmentMaster->id = $tx_master_id;
			$tx_master_data = $this->TreatmentMaster->read();

			$use_form_alias = $tx_master_data['TreatmentMaster']['extend_form_alias'];
			$this->TreatmentExtend = new TreatmentExtend( false, $tx_master_data['TreatmentMaster']['extend_tablename'] );

		// set MENU varible for echo on VIEW
		$ctrapp_menu[] = $this->Menus->tabs( 'clin_CAN_1', 'clin_CAN_75', $participant_id );
		$ctrapp_menu[] = $this->Menus->tabs( 'clin_CAN_75', 'clin_CAN_80', $participant_id.'/'.$tx_master_id ); // based on TxMaster values
		$this->set( 'ctrapp_menu', $ctrapp_menu );

		// set FORM variable, for HELPER call on VIEW
		$this->set( 'ctrapp_form', $this->Forms->getFormArray( $use_form_alias ) );

		// set SUMMARY varible from plugin's COMPONENTS
		$this->set( 'ctrapp_summary', $this->Summaries->build( $participant_id ) );

		// set SIDEBAR variable, for HELPER call on VIEW
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set( 'ctrapp_sidebar', $this->Sidebars->getColsArray( $this->params['plugin'].'_'.$this->params['controller'].'_'.$this->params['action'] ) );

		// set FORM variable, for HELPER call on VIEW
		$this->set( 'participant_id', $participant_id );
		$this->set( 'tx_master_id', $tx_master_id );

			$criteria = array();
			$criteria['tx_master_id'] = $tx_master_id;
			$criteria = array_filter($criteria);

		list( $order, $limit, $page ) = $this->Pagination->init( $criteria );
		$this->set( 'treatment_extends', $this->TreatmentExtend->findAll( $criteria, NULL, $order, $limit, $page ) );
		
		// Get all drug names for dropdown list
		$criteria = NULL;
		$fields = 'Drug.id, Drug.generic_name';
		$order = 'Drug.id ASC';
		$drug_id_findall_result = $this->Drug->findAll( $criteria, $fields, $order );
		$drug_id_findall = array();
		foreach ( $drug_id_findall_result as $record ) {
			$drug_id_findall[ $record['Drug']['id'] ] = $record['Drug']['generic_name'];
		}
		$this->set( 'drug_id_findall', $drug_id_findall );
		
	}

	function detail( $participant_id=0, $tx_master_id=0, $tx_extend_id=0 ) {

		// get Extend tablename and form_alias from Master row

			$this->TreatmentMaster->id = $tx_master_id;
			$tx_master_data = $this->TreatmentMaster->read();

			$use_form_alias = $tx_master_data['TreatmentMaster']['extend_form_alias'];
			$this->TreatmentExtend = new TreatmentExtend( false, $tx_master_data['TreatmentMaster']['extend_tablename'] );

		// set MENU varible for echo on VIEW
		$ctrapp_menu[] = $this->Menus->tabs( 'clin_CAN_1', 'clin_CAN_75', $participant_id );
		$ctrapp_menu[] = $this->Menus->tabs( 'clin_CAN_75', 'clin_CAN_80', $participant_id.'/'.$tx_master_id ); // based on TxMaster values
		$this->set( 'ctrapp_menu', $ctrapp_menu );

		// set FORM variable, for HELPER call on VIEW
		$this->set( 'ctrapp_form', $this->Forms->getFormArray( $use_form_alias ) );

		// set SUMMARY varible from plugin's COMPONENTS
		$this->set( 'ctrapp_summary', $this->Summaries->build( $participant_id ) );

		// set SIDEBAR variable, for HELPER call on VIEW
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set( 'ctrapp_sidebar', $this->Sidebars->getColsArray( $this->params['plugin'].'_'.$this->params['controller'].'_'.$this->params['action'] ) );

		// set FORM variable, for HELPER call on VIEW
		$this->set( 'participant_id', $participant_id );
		$this->set( 'tx_master_id', $tx_master_id );
		$this->set( 'tx_extend_id', $tx_extend_id );

		// Get all drug names for dropdown list
		$criteria = NULL;
		$fields = 'Drug.id, Drug.generic_name';
		$order = 'Drug.id ASC';
		$drug_id_findall_result = $this->Drug->findAll( $criteria, $fields, $order );
		$drug_id_findall = array();
		foreach ( $drug_id_findall_result as $record ) {
			$drug_id_findall[ $record['Drug']['id'] ] = $record['Drug']['generic_name'];
		}
		$this->set( 'drug_id_findall', $drug_id_findall );
		
		$this->TreatmentExtend->id = $tx_extend_id;
		$this->set( 'data', $this->TreatmentExtend->read() );
	}

	function add( $participant_id=0, $tx_master_id=0 ) {

		// get Extend tablename and form_alias from Master row

			$this->TreatmentMaster->id = $tx_master_id;
			$tx_master_data = $this->TreatmentMaster->read();

			$use_form_alias = $tx_master_data['TreatmentMaster']['extend_form_alias'];
			$this->TreatmentExtend = new TreatmentExtend( false, $tx_master_data['TreatmentMaster']['extend_tablename'] );

		// setup MODEL(s) validation array(s) for displayed FORM
		foreach ( $this->Forms->getValidateArray( $use_form_alias ) as $validate_model=>$validate_rules ) {
			$this->{ $validate_model }->validate = $validate_rules;
		}

		// set MENU varible for echo on VIEW
		$ctrapp_menu[] = $this->Menus->tabs( 'clin_CAN_1', 'clin_CAN_75', $participant_id );
		$ctrapp_menu[] = $this->Menus->tabs( 'clin_CAN_75', 'clin_CAN_80', $participant_id.'/'.$tx_master_id ); // based on TxMaster values
		$this->set( 'ctrapp_menu', $ctrapp_menu );

		// set FORM variable, for HELPER call on VIEW
		$this->set( 'ctrapp_form', $this->Forms->getFormArray( $use_form_alias ) );

		// set SUMMARY varible from plugin's COMPONENTS
		$this->set( 'ctrapp_summary', $this->Summaries->build( $participant_id ) );

		// set SIDEBAR variable, for HELPER call on VIEW
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set( 'ctrapp_sidebar', $this->Sidebars->getColsArray( $this->params['plugin'].'_'.$this->params['controller'].'_'.$this->params['action'] ) );

		// set FORM variable, for HELPER call on VIEW
		$this->set( 'participant_id', $participant_id );
		$this->set( 'tx_master_id', $tx_master_id );
		
		// Get all drug names for dropdown list
		$criteria = NULL;
		$fields = 'Drug.id, Drug.generic_name';
		$order = 'Drug.id ASC';
		$drug_id_findall_result = $this->Drug->findAll( $criteria, $fields, $order );
		$drug_id_findall = array();
		foreach ( $drug_id_findall_result as $record ) {
			$drug_id_findall[ $record['Drug']['id'] ] = $record['Drug']['generic_name'];
		}
		$this->set( 'drug_id_findall', $drug_id_findall );
		
		if ( !empty($this->data) ) {

			// after DETAIL model is set and declared
			$this->cleanUpFields('TreatmentExtend');

			if ( $this->TreatmentExtend->save( $this->data ) ) {
				$this->flash( 'Your data has been saved.', '/treatment_extends/listall/'.$participant_id.'/'.$tx_master_id );
			}

		}

	}

	function edit( $participant_id=0, $tx_master_id=0, $tx_extend_id=0 ) {

		// get Extend tablename and form_alias from Master row

			$this->TreatmentMaster->id = $tx_master_id;
			$tx_master_data = $this->TreatmentMaster->read();

			$use_form_alias = $tx_master_data['TreatmentMaster']['extend_form_alias'];
			$this->TreatmentExtend = new TreatmentExtend( false, $tx_master_data['TreatmentMaster']['extend_tablename'] );

		// setup MODEL(s) validation array(s) for displayed FORM
		foreach ( $this->Forms->getValidateArray( $use_form_alias ) as $validate_model=>$validate_rules ) {
			$this->{ $validate_model }->validate = $validate_rules;
		}

		// set MENU varible for echo on VIEW
		$ctrapp_menu[] = $this->Menus->tabs( 'clin_CAN_1', 'clin_CAN_75', $participant_id );
		$ctrapp_menu[] = $this->Menus->tabs( 'clin_CAN_75', 'clin_CAN_80', $participant_id.'/'.$tx_master_id ); // based on TxMaster values
		$this->set( 'ctrapp_menu', $ctrapp_menu );

		// set FORM variable, for HELPER call on VIEW
		$this->set( 'ctrapp_form', $this->Forms->getFormArray( $use_form_alias ) );

		// set SUMMARY varible from plugin's COMPONENTS
		$this->set( 'ctrapp_summary', $this->Summaries->build( $participant_id ) );

		// set SIDEBAR variable, for HELPER call on VIEW
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set( 'ctrapp_sidebar', $this->Sidebars->getColsArray( $this->params['plugin'].'_'.$this->params['controller'].'_'.$this->params['action'] ) );

		// set FORM variable, for HELPER call on VIEW
		$this->set( 'participant_id', $participant_id );
		$this->set( 'tx_master_id', $tx_master_id );
		$this->set( 'tx_extend_id', $tx_extend_id );
		
		// Get all drug names for dropdown list
		$criteria = NULL;
		$fields = 'Drug.id, Drug.generic_name';
		$order = 'Drug.id ASC';
		$drug_id_findall_result = $this->Drug->findAll( $criteria, $fields, $order );
		$drug_id_findall = array();
		foreach ( $drug_id_findall_result as $record ) {
			$drug_id_findall[ $record['Drug']['id'] ] = $record['Drug']['generic_name'];
		}
		$this->set( 'drug_id_findall', $drug_id_findall );
		
		if ( empty($this->data) ) {

			$this->TreatmentExtend->id = $tx_extend_id;
			$this->data = $this->TreatmentExtend->read();
			$this->set( 'data', $this->data );

		} else {

			// after DETAIL model is set and declared
			$this->cleanUpFields('TreatmentExtend');

			if ( $this->TreatmentExtend->save( $this->data['TreatmentExtend'] ) ) {
				$this->flash( 'Your data has been updated.','/treatment_extends/detail/'.$participant_id.'/'.$tx_master_id.'/'.$tx_extend_id );
			}

		}

	}

	function delete( $participant_id=0, $tx_master_id=0, $tx_extend_id=0 ) {

		// get Extend tablename and form_alias from Master row

			$this->TreatmentMaster->id = $tx_master_id;
			$tx_master_data = $this->TreatmentMaster->read();

			$use_form_alias = $tx_master_data['TreatmentMaster']['extend_form_alias'];
			$this->TreatmentExtend = new TreatmentExtend( false, $tx_master_data['TreatmentMaster']['extend_tablename'] );

		$this->TreatmentExtend->del( $tx_extend_id );
		$this->flash( 'Your data has been deleted.', '/treatment_extends/listall/'.$participant_id.'/'.$tx_master_id );

	}

}

?>