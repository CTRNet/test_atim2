<?php

class SopMastersController extends SopAppController {
	$uses = array('SopControl', 'SopMaster');
	$paginate = array('SopMaster'=>array('limit'=10,'order'=>'SopMaster.title ASC'));
	$component = array('Summaries');
	$helper = array('Summaries');
	
	function listall() {
		$this->data = $this->paginate($this->SopMaster);
	}
	
	function detail() {
		$this->data = $this->SopMaster->find('first',array('conditions'=>array('SopMaster.id'=>$sop_master_id)));
	}
	
	function add( ) {
		$this->set( 'atim_menu', $this->Menus->get('/sop_master/listall/') );
		
		if ( !empty($this->data) ) {
			if ( $this->SopMaster->save($this->data) ) $this->flash( 'Your data has been updated.','/sop_master/detail/'.$this->SopMaster->id );
		}
	}
	
	function edit( $sop_master_id) {
		$this->set( 'atim_menu_variables', array( 'SopMaster.id'=>$sop_master_id) );
		
		if ( !empty($this->data) ) {
			$this->SopMaster->id = $sop_master_id;
			if ( $this->SopMaster->save($this->data) ) $this->flash( 'Your data has been updated.','/sop_master/detail/'.$sop_master_id );
		} else {
			$this->data = $this->SopMaster->find('first',array('conditions'=>array('SopMaster.id'=>$sop_master_id)));
		}
	}
/*
	var $name = 'SopMasters';
	var $uses = array('SopControl', 'SopMaster');
	
	var $useDbConfig = 'default';

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
*/
	function index() {}
	/*
		// nothing...
	}

	function listall() {

		// set MENU varible for echo on VIEW
		$this->set( 'ctrapp_menu', array() );

		// set FORM variable, for HELPER call on VIEW
		$this->set( 'ctrapp_form', $this->Forms->getFormArray('sop_masters') );

		$this->set( 'ctrapp_summary', $this->Summaries->build() );
		
		// set SIDEBAR variable, for HELPER call on VIEW
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set( 'ctrapp_sidebar', $this->Sidebars->getColsArray( $this->params['plugin'].'_'.$this->params['controller'].'_'.$this->params['action'] ) );

			$criteria = array();

		list( $order, $limit, $page ) = $this->Pagination->init( $criteria );
		$this->set( 'sop_masters', $this->SopMaster->findAll( $criteria, NULL, $order, $limit, $page ) );

			$conditions = array();
			$conditions = array_filter($conditions);

		// findall SopControlS, for ADD form
		$this->set( 'sop_controls', $this->SopControl->findAll( $conditions ) );
		
		// Test statement for getting list of SOP's
		// $sop_list = $this->getSOPList('Inventory', 'Blood', 'Blood');
		// print_r($sop_list);

	}

	function detail( $sop_master_id=null ) {

		// set SIDEBAR variable, for HELPER call on VIEW
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set( 'ctrapp_sidebar', $this->Sidebars->getColsArray( $this->params['plugin'].'_'.$this->params['controller'].'_'.$this->params['action'] ) );

		// set FORM variable, for HELPER call on VIEW
		$this->set( 'sop_master_id', $sop_master_id );

		$this->set( 'ctrapp_summary', $this->Summaries->build($sop_master_id) );

		// Sop MASTER info defines SopDetail info, including FORM alias

			// read SopMaster info, which contains FORM alias and DETAIL tablename
			$this->SopMaster->id = $sop_master_id;
			$sop_master_data = $this->SopMaster->read();

			// set MENU varible for echo on VIEW
			$ctrapp_menu[] = $this->Menus->tabs( 'sop_CAN_01', 'sop_CAN_03', $sop_master_id );
			if ( empty($sop_master_data['SopMaster']['extend_tablename']) ) {
				$ctrapp_menu['0']['sop_CAN_04']['allowed'] = false; // based on SopMaster values
			}
			$this->set( 'ctrapp_menu', $ctrapp_menu );

			// FORM alias, from Sop MASTER field
			$this->set( 'ctrapp_form', $this->Forms->getFormArray( $sop_master_data['SopMaster']['detail_form_alias'] ) );

			// start new instance of SopDetail model, using TABLENAME from Sop MASTER
			$this->SopDetail = new SopDetail( false, $sop_master_data['SopMaster']['detail_tablename'] );
			// read related SopDetail row, whose ID should be same as SopMaster ID
			$this->SopDetail->id = $sop_master_id;
			$sop_specific_data = $this->SopDetail->read();

			// merge both datasets into a SINGLE dataset, set for VIEW
			$this->set( 'data', array_merge( $sop_master_data, $sop_specific_data )  );

	}

	function add( $sop_control_id=null ) {

		if ( $sop_control_id!=null ) {

			// read SopControl info, which contains FORM alias and DETAIL tablename
			$this->SopControl->id = $sop_control_id;
			$sop_control_data = $this->SopControl->read();
			$this->set( 'control_data', $sop_control_data  );

			// start new instance of SopDetail model, using TABLENAME from Sop MASTER
			$this->SopDetail = new SopDetail( false, $sop_control_data['SopControl']['detail_tablename'] );

		} else if ( isset($this->params['form']['sop_control_id']) ) {

			// get SopControl ID from LISTALL add form submit
			$sop_control_id = $this->params['form']['sop_control_id'];

			// read SopControl info, which contains FORM alias and DETAIL tablename
			$this->SopControl->id = $sop_control_id;
			$sop_control_data = $this->SopControl->read();
			$this->set( 'control_data', $sop_control_data  );

			// start new instance of SopDetail model, using TABLENAME from Sop MASTER
			$this->SopDetail = new SopDetail( false, $sop_control_data['SopControl']['detail_tablename'] );

		} else {

			// error
			die('missing sop control id');

		}

		// set MENU varible for echo on VIEW
		$this->set( 'ctrapp_menu', array() );

		// set FORM variable, for HELPER call on VIEW
		$this->set( 'ctrapp_form', $this->Forms->getFormArray( $sop_control_data['SopControl']['detail_form_alias'] ) );

		// set SUMMARY varible from plugin's COMPONENTS
		$this->set( 'ctrapp_summary', $this->Summaries->build() );

		// set SIDEBAR variable, for HELPER call on VIEW
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set( 'ctrapp_sidebar', $this->Sidebars->getColsArray( $this->params['plugin'].'_'.$this->params['controller'].'_'.$this->params['action'] ) );

		// set FORM variable, for HELPER call on VIEW
		$this->set( 'sop_control_id', $sop_control_id );

		// setup MODEL(s) validation array(s) for displayed FORM
		foreach ( $this->Forms->getValidateArray( $sop_control_data['SopControl']['detail_form_alias'] ) as $validate_model=>$validate_rules ) {
			$this->{ $validate_model }->validate = $validate_rules;
		}

		if ( !empty($this->data) ) {

			// after DETAIL model is set and declared
			$this->cleanUpFields('SopDetail');

			if ( !isset($this->data['SopDetail']) ) { $this->data['SopDetail'] = array(); } // if not DETAIL form elements used...

			if ( $this->SopMaster->validates( $this->data['SopMaster'] ) && $this->SopDetail->validates( $this->data['SopDetail'] ) ) {

				// save SopMaster data
				$this->SopMaster->save( $this->data['SopMaster'] );

				// set ID fields based on SopMaster
				$this->data['SopDetail']['id'] = $this->SopMaster->getLastInsertId();
				$this->data['SopDetail']['sop_master_id'] = $this->SopMaster->getLastInsertId();

				// save SopDetail data
				$this->SopDetail->save( $this->data['SopDetail'] );

				$this->flash( 'Your data has been updated.','/sop_masters/listall/' );

			}

		}

	}

	function edit( $sop_master_id=null ) {

		// set FORM variable, for HELPER call on VIEW
		// $this->set( 'ctrapp_form', $this->Forms->getFormArray('sop_masters') );
		$this->set( 'ctrapp_summary', $this->Summaries->build($sop_master_id) );

		// set SIDEBAR variable, for HELPER call on VIEW
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set( 'ctrapp_sidebar', $this->Sidebars->getColsArray( $this->params['plugin'].'_'.$this->params['controller'].'_'.$this->params['action'] ) );

		// set FORM variable, for HELPER call on VIEW
		$this->set( 'sop_master_id', $sop_master_id );

		// Sop MASTER info defines SopDetail info, including FORM alias

			// read SopMaster info, which contains FORM alias and DETAIL tablename
			$this->SopMaster->id = $sop_master_id;
			$sop_master_data = $this->SopMaster->read();
			
			$ctrapp_menu[] = $this->Menus->tabs( 'sop_CAN_01', 'sop_CAN_03', $sop_master_id );
			if ( empty($sop_master_data['SopMaster']['extend_tablename']) ) {
				$ctrapp_menu['0']['sop_CAN_04']['allowed'] = false; // based on SopMaster values
			}
			$this->set( 'ctrapp_menu', $ctrapp_menu );

			// setup MODEL(s) validation array(s) for displayed FORM
				foreach ( $this->Forms->getValidateArray( $sop_master_data['SopMaster']['detail_form_alias'] ) as $validate_model=>$validate_rules ) {
					$this->{ $validate_model }->validate = $validate_rules;
				}

			// FORM alias, from Sop MASTER field
			$this->set( 'ctrapp_form', $this->Forms->getFormArray( $sop_master_data['SopMaster']['detail_form_alias'] ) );

			// start new instance of SopDetail model, using TABLENAME from Sop MASTER
			$this->SopDetail = new SopDetail( false, $sop_master_data['SopMaster']['detail_tablename'] );
			// read related SopDetail row, whose ID should be same as SopMaster ID
			$this->SopDetail->id = $sop_master_id;
			$sop_specific_data = $this->SopDetail->read();

		if ( empty($this->data) ) {

			// merge both datasets into a SINGLE dataset, set for VIEW
			$this->data = array_merge( $sop_master_data, $sop_specific_data );
			$this->set( 'data', $this->data  );

		} else {

			// after DETAIL model is set and declared
			$this->cleanUpFields('SopDetail');

			if ( !isset($this->data['SopDetail']) ) { $this->data['SopDetail'] = array(); } // if not DETAIL form elements used...

			if ( $this->SopMaster->validates( $this->data['SopMaster'] ) && $this->SopDetail->validates( $this->data['SopDetail'] ) ) {

				$this->SopMaster->save( $this->data['SopMaster'] );
				$this->SopDetail->save( $this->data['SopDetail'] );

				$this->flash( 'Your data has been updated.','/sop_masters/detail/'.$sop_master_id );
			}

		}



	}
*/
	function delete( $sop_master_id=null ) {}
/*
		// read SopMaster info, which contains FORM alias and DETAIL tablename
		$this->SopMaster->id = $sop_master_id;
		$sop_master_data = $this->SopMaster->read();

		// start new instance of SopDetail model, using TABLENAME from Sop MASTER
		$this->SopDetail = new SopDetail( false, $sop_master_data['SopMaster']['detail_tablename'] );

		// delete MASTER/DETAIL rows
		$this->SopMaster->del( $sop_master_id );
		$this->SopDetail->del( $sop_master_id );

		$this->flash( 'Your data has been deleted.', '/sop_masters/listall/' );

	}
*/	
	function getSOPList( $sop_group=null, $sop_type=null, $sop_product=null ) {}
	/*	
		// Check arguments for data
		if ($sop_group && $sop_type && $sop_product) {
			// set criteria
			$criteria = 'SopMaster.sop_group = \''.$sop_group.'\'';
			$criteria .= ' AND SopMaster.type = \''.$sop_type.'\'';
				
			// query DB, get list of SOP's
			$sop_data = $this->SopMaster->findAll($criteria, NULL, NULL, NULL, NULL, 0);
			
			// Sort sop list by version number
			// asort ($sop_data); TODO: Sort by the version number
			
			$sop_list = array();
			
			// Build array of SOP's to return, listing active ones first
			foreach($sop_data as $id => $sop_record){
				//Check status, if active add to array
				if ($sop_record['SopMaster']['status'] == 'active') {
					array_push($sop_list, $sop_record['SopMaster']['code'].' v'.$sop_record['SopMaster']['version'].' - '.$sop_record['SopMaster']['status']);		
				}
			}
			
			// Add to array of SOP's to return, add all versions not active
			foreach($sop_data as $id => $sop_record){
				//Check status, if not active add to array
				if ($sop_record['SopMaster']['status'] != 'active') {
					array_push($sop_list, $sop_record['SopMaster']['code'].' v'.$sop_record['SopMaster']['version'].' - '.$sop_record['SopMaster']['status']);		
				}
			}
		}
		else { // Missing required parameter, return empty array
			$sop_list = array();
		}
		
		return $sop_list;
	}

}

?>
