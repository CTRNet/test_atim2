<?php

class MaterialsController extends AppController {
	$uses = array('Materials');
	$paginate = array('Materials'=>array('limit'=>10,'order'=>'Materials.id ASC'));
	$components = array('Summaries');
	$helper = array('Summaries');
	
	function listall() {
		$this->data = $this->paginate($this->Materials);
	}
	
	function detail() {
		$this->data = $this->Materials->find('first',array('conditions'=>array('Materials.id'=>$material_id)));
	}
	
	function add( ) {
		$this->set( 'atim_menu', $this->Menus->get('n/material/listall/') );
		
		if ( !empty($this->data) ) {
			if ( $this->Materials->save($this->data) ) $this->flash( 'Your data has been updated.','material/detail/'.$this->Materials->id );
		}
	}
	
	function edit( $material_id) {
		$this->set( 'atim_menu_variables', array('Materials.id'=>$material_id) );
		
		if ( !empty($this->data) ) {
			$this->Materials->id = $material_id;
			if ( $this->Materials->save($this->data) ) $this->flash( 'Your data has been updated.','material/detail/'.$material_id );
		} else {
			$this->data = $this->Materials->find('first',array('conditions'=>array('Materials.id'=>$material_id)));
		}
	}
/*
	var $name = 'Materials';
	var $uses = array('Material');

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

	function listall( ) {

		// set MENU varible for echo on VIEW
		$this->set( 'ctrapp_menu', array() );

		// set FORM variable, for HELPER call on VIEW
		$this->set( 'ctrapp_form', $this->Forms->getFormArray('materials') );

		// set SUMMARY variable from plugin's COMPONENTS
		$this->set( 'ctrapp_summary', $this->Summaries->build( ) );

		// set SIDEBAR variable, for HELPER call on VIEW
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set( 'ctrapp_sidebar', $this->Sidebars->getColsArray( $this->params['plugin'].'_'.$this->params['controller'].'_'.$this->params['action'] ) );

		// set FORM variable, for HELPER call on VIEW

		$criteria = array();
		$criteria = array_filter($criteria);

		list( $order, $limit, $page ) = $this->Pagination->init( $criteria );
		$this->set( 'materials', $this->Material->findAll( $criteria, NULL, $order, $limit, $page ) );

	}
*/	
	function index() {}
	/*
		// clear SEARCH criteria, for pagination bug
		$_SESSION['ctrapp_core']['material']['search_criteria'] = NULL;

		// set MENU varible for echo on VIEW
		$this->set( 'ctrapp_menu', array() );

		// set FORM variable, for HELPER call on VIEW
		$this->set( 'ctrapp_form', $this->Forms->getFormArray('materials') );

		// set SUMMARY varible from plugin's COMPONENTS
		$this->set( 'ctrapp_summary', $this->Summaries->build() );

		// set SIDEBAR variable, for HELPER call on VIEW
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set( 'ctrapp_sidebar', $this->Sidebars->getColsArray( $this->params['plugin'].'_'.$this->params['controller'].'_'.$this->params['action'] ) );
	}
*/
	function search( ) {}
	/*
		// set MENU varible for echo on VIEW
		$this->set( 'ctrapp_menu', array() );

		// set FORM variable, for HELPER call on VIEW
		$ctrapp_form = $this->Forms->getFormArray('materials');
		$this->set( 'ctrapp_form', $ctrapp_form );

		// set SUMMARY varible from plugin's COMPONENTS
		$this->set( 'ctrapp_summary', $this->Summaries->build() );

		// set SIDEBAR variable, for HELPER call on VIEW
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set( 'ctrapp_sidebar', $this->Sidebars->getColsArray( $this->params['plugin'].'_'.$this->params['controller'].'_'.$this->params['action'] ) );

		// if SEARCH form data, parse and create conditions
		if ( $this->data ) {
			$criteria = $this->Forms->getSearchConditions( $this->data, $ctrapp_form );
			$_SESSION['ctrapp_core']['material']['search_criteria'] = $criteria; // save CRITERIA to session for pagination
		} else {
			$criteria = $_SESSION['ctrapp_core']['material']['search_criteria']; // if no form data, use SESSION critera for PAGINATION bug
		}

		$no_pagination_order = '';
		$no_pagination_order = 'item_name ASC';

		list( $order, $limit, $page ) = $this->Pagination->init( $criteria );
		$this->set( 'materials', $this->Material->findAll( $criteria, NULL, $no_pagination_order, $limit, $page, 0, 2 ) );
	}
	
	function add() {

    	// setup MODEL(s) validation array(s) for displayed FORM
    	foreach ( $this->Forms->getValidateArray('materials') as $validate_model=>$validate_rules ) {
      		$this->{ $validate_model }->validate = $validate_rules;
    	}

    	// set MENU varible for echo on VIEW
    	$this->set( 'ctrapp_menu', array() );

   		// set FORM variable, for HELPER call on VIEW
    	$this->set( 'ctrapp_form', $this->Forms->getFormArray('materials') );

    	// set SUMMARY varible from plugin's COMPONENTS
    	$this->set( 'ctrapp_summary', $this->Summaries->build() );

    	// set SIDEBAR variable, for HELPER call on VIEW
    	// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
    	$this->set( 'ctrapp_sidebar', $this->Sidebars->getColsArray( $this->params['plugin'].'_'.
								 $this->params['controller'].'_'.
								 $this->params['action'] ) );

		if ( !empty($this->data) ) {
	    	if ( $this->Material->save( $this->data ) ) {
				$this->flash( 'Your data has been saved.','/materials/detail/'.$this->Material->getLastInsertId() );
      		} else {
				print_r($this->params['data']);
      		}
    	}
	}

	function edit( $material_id=null ) {

    	// setup MODEL(s) validation array(s) for displayed FORM
		foreach ( $this->Forms->getValidateArray('materials') as $validate_model=>$validate_rules ) {
      		$this->{ $validate_model }->validate = $validate_rules;
    	}

    	// set MENU varible for echo on VIEW
		$ctrapp_menu[] = $this->Menus->tabs( 'mat_CAN_01', 'mat_CAN_02', $material_id );
    	$this->set( 'ctrapp_menu', array() );

    	// set FORM variable, for HELPER call on VIEW
    	$this->set( 'ctrapp_form', $this->Forms->getFormArray('materials') );

    	// set SUMMARY varible from plugin's COMPONENTS
    	$this->set( 'ctrapp_summary', $this->Summaries->build($material_id) );

    	// set SIDEBAR variable, for HELPER call on VIEW
    	// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
    	$this->set( 'ctrapp_sidebar', $this->Sidebars->getColsArray( $this->params['plugin'].'_'.
								 $this->params['controller'].'_'.
								 $this->params['action'] ) );

    	if ( empty($this->data) ) {
		    $this->Material->id = $material_id;
      		$this->data = $this->Material->read();
      		$this->set( 'data', $this->data );
		} else {
	    	$this->Material->id = $material_id;
      		if ( $this->Material->save( $this->data['Material'] ) ) {
				$this->flash( 'Your data has been updated.','/materials/detail/'.$material_id );
      		} else {
				print_r($this->params['data']);
      		}

    	}
  	}
*/
	function detail( $material_id=null ) {}
/*
		// set MENU varible for echo on VIEW
		$ctrapp_menu[] = $this->Menus->tabs( 'mat_CAN_01', 'mat_CAN_02', $material_id );
		$this->set( 'ctrapp_menu', array() );

		// set FORM variable, for HELPER call on VIEW
		$this->set( 'ctrapp_form', $this->Forms->getFormArray('materials') );

		// set SUMMARY variable from plugin's COMPONENTS
		$this->set( 'ctrapp_summary', $this->Summaries->build($material_id ) );

		// set SIDEBAR variable, for HELPER call on VIEW
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set( 'ctrapp_sidebar', $this->Sidebars->getColsArray( $this->params['plugin'].'_'.$this->params['controller'].'_'.$this->params['action'] ) );

		// set FORM variable, for HELPER call on VIEW
		$this->set( 'material_id', $material_id );

		$this->Material->id = $material_id;
		$this->set( 'data', $this->Material->read() );
	}
*/
	function delete( $material_id=null ) {}
/*
    	$this->Material->del( $material_id );
    	$this->flash( 'Your data has been deleted.', '/materials/index/' );
	}

}

?>