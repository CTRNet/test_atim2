<?php

class RtbformsController extends RtbformAppController {
	
  var $name = 'Rtbforms';
  var $uses = array('Rtbform');
  
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
    
    // clear SEARCH criteria, for pagination bug 
    $_SESSION['ctrapp_core']['criteria'] = '';
    
    // set SUMMARY varible from plugin's COMPONENTS 
    $this->set( 'ctrapp_summary', $this->Summaries->build() );
    
    // set MENU varible for echo on VIEW 
    $this->set( 'ctrapp_menu', array() );
    
    // set FORM variable, for HELPER call on VIEW 
    $this->set( 'ctrapp_form', $this->Forms->getFormArray('rtbforms') );
    
	// set SIDEBAR variable, for HELPER call on VIEW 
	// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
	$this->set( 'ctrapp_sidebar', $this->Sidebars->getColsArray( $this->params['plugin'].'_'.$this->params['controller'].'_'.$this->params['action'] ) );
	  
  }
  
  function search() {
    
    // set MENU varible for echo on VIEW 
    $this->set( 'ctrapp_menu', array() );
    
    // set FORM variable, for HELPER call on VIEW 
    $this->set( 'ctrapp_form', $this->Forms->getFormArray('rtbforms') );
    
    // set SUMMARY varible from plugin's COMPONENTS 
    $this->set( 'ctrapp_summary', $this->Summaries->build() );
    
	// set SIDEBAR variable, for HELPER call on VIEW 
	// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
	$this->set( 'ctrapp_sidebar', $this->Sidebars->getColsArray( $this->params['plugin'].'_'.$this->params['controller'].'_'.$this->params['action'] ) );
    
    // if SEARCH form data, parse and create conditions 
    if ( $this->data ) {
      $criteria = $this->Forms->getSearchConditions( $this->data );
      $_SESSION['ctrapp_core']['criteria'] = $criteria; // save CRITERIA to session for pagination 
    } else {
      $criteria = $_SESSION['ctrapp_core']['criteria']; // if no form data, use SESSION critera for PAGINATION bug 
    }

    //    print "q:".$criteria;
    
    list( $order, $limit, $page ) = $this->Pagination->init( $criteria );
    $this->set( 'rtbforms', $this->Rtbform->findAll( $criteria, NULL, $order, $limit, $page, 0, 2 ) );
    
  }
	
  function profile( $rtbform_id=null ) {
    
    // clear SEARCH criteria, for pagination bug 
    $_SESSION['ctrapp_core']['criteria'] = '';
    
    // set MENU varible for echo on VIEW 
	$ctrapp_menu[] = $this->Menus->tabs( 'rtbf_CAN_01', 'rtbf_CAN_02', $rtbform_id );
	$this->set( 'ctrapp_menu', array() );

    // set FORM variable, for HELPER call on VIEW 
    $this->set( 'ctrapp_form', $this->Forms->getFormArray('rtbforms') );
    
    // set SUMMARY varible from plugin's COMPONENTS 
    $this->set( 'ctrapp_summary', $this->Summaries->build($rtbform_id) );
    
    // set SIDEBAR variable, for HELPER call on VIEW 
    // use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
    $this->set( 'ctrapp_sidebar', $this->Sidebars->getColsArray( $this->params['plugin'].'_'.
								 $this->params['controller'].'_'.
								 $this->params['action'] ) );
    
    $this->Rtbform->id = $rtbform_id;
    $this->set( 'data', $this->Rtbform->read() );
  }
  

  function add() {
    
    // setup MODEL(s) validation array(s) for displayed FORM 
    foreach ( $this->Forms->getValidateArray('rtbforms') as $validate_model=>$validate_rules ) {
      $this->{ $validate_model }->validate = $validate_rules;
    }
    
    // set MENU varible for echo on VIEW 
    $this->set( 'ctrapp_menu', array() );
    
    // set FORM variable, for HELPER call on VIEW 
    $this->set( 'ctrapp_form', $this->Forms->getFormArray('rtbforms') );
    
    // set SUMMARY varible from plugin's COMPONENTS 
    $this->set( 'ctrapp_summary', $this->Summaries->build() );
    
    // set SIDEBAR variable, for HELPER call on VIEW 
    // use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
    $this->set( 'ctrapp_sidebar', $this->Sidebars->getColsArray( $this->params['plugin'].'_'.
								 $this->params['controller'].'_'.
								 $this->params['action'] ) );

    
    if ( !empty($this->data) ) {

      if ( $this->Rtbform->save( $this->data ) ) {
	$this->flash( 'Your data has been saved.','/rtbforms/profile/'.$this->Rtbform->getLastInsertId() );
      }else{
	print_r($this->params['data']);
      }      
    }
  }
  

  function edit( $rtbform_id=null ) {

    // setup MODEL(s) validation array(s) for displayed FORM 
    foreach ( $this->Forms->getValidateArray('rtbforms') as $validate_model=>$validate_rules ) {
      $this->{ $validate_model }->validate = $validate_rules;
    }
    
    // set MENU varible for echo on VIEW 
	$ctrapp_menu[] = $this->Menus->tabs( 'rtbf_CAN_01', 'rtbf_CAN_02', $rtbform_id );
	$this->set( 'ctrapp_menu', array() );
    
    // set FORM variable, for HELPER call on VIEW 
    $this->set( 'ctrapp_form', $this->Forms->getFormArray('rtbforms') );
    
    // set SUMMARY varible from plugin's COMPONENTS 
    $this->set( 'ctrapp_summary', $this->Summaries->build($rtbform_id) );
    
    // set SIDEBAR variable, for HELPER call on VIEW 
    // use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
    $this->set( 'ctrapp_sidebar', $this->Sidebars->getColsArray( $this->params['plugin'].'_'.
								 $this->params['controller'].'_'.
								 $this->params['action'] ) );
    
    if ( empty($this->data) ) {
      
      $this->Rtbform->id = $rtbform_id;
      $this->data = $this->Rtbform->read();
      $this->set( 'data', $this->data );
      
    } else {
      
      if ( $this->Rtbform->save( $this->data['Rtbform'] ) ) {
	$this->flash( 'Your data has been updated.','/rtbforms/profile/'.$rtbform_id );
      }else{
	print_r($this->params['data']);
      }      

    }
  }
  
  function delete( $rtbform_id=null ) {
    
    $this->Rtbform->del( $rtbform_id );
    $this->flash( 'Your data has been deleted.', '/rtbforms' );
    
  }
  
}

?>