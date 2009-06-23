<?php

class ProtocolExtendsController extends ProtocolAppController {

	var $uses = array(
		'Protocol.ProtocolExtend',
		'Protocol.ProtocolMaster',
		'Protocol.ProtocolControl',
		'Drug.Drug');
	var $paginate = array('ProtocolMaster'=>array('limit'=>10,'order'=>'ProtocolMaster.name DESC'));
	
	function listall($protocol_master_id){
		$this->set('atim_menu_variables', array('ProtocolMaster.id'=>$protocol_master_id));
		
		$protocol_master_data = $this->ProtocolMaster->find('first', array('conditions'=>array('ProtocolMaster.id'=>$protocol_master_id)));
		
		$this->ProtocolExtend = new ProtocolExtend(false, $protocol_master_data['ProtocolMaster']['extend_tablename']);
		$use_form_alias = $protocol_master_data['ProtocolMaster']['extend_form_alias'];
		$this->set('atim_structure', $this->Structures->get('form', $use_form_alias));
		
		$this->data = $this->paginate($this->ProtocolExtend, array('ProtocolExtend.protocol_master_id'=>$protocol_master_id));
		
		$drug_list = $this->Drug->find('all', array('fields'=>array('Drug.id', 'Drug.generic_name'), 'order'  => array('Drug.generic_name')));
		foreach( $drug_list as $record){
			$drug_id_findall[ $record['Drug']['id'] ] = $record['Drug']['generic_name'];
		}
		$this->set('drug_id_findall', $drug_id_findall);
	}
	
	function detail($protocol_master_id=null, $protocol_extend_id=null) {
		
		$this->set('atim_menu_variables', array('Participant.id'=>$participant_id, 'ProtocolMaster.id'=>$protocol_master_id));
		
		// Get treatment master row for extended data
		$protocol_master_data = $this->ProtocolMaster->find('first',array('conditions'=>array('ProtocolMaster.id'=>$protocol_master_id)));
		
		// Set form alias/tablename to use
		$this->ProtocolExtend = new ProtocolExtend( false, $tx_master_data['ProtocolMaster']['extend_tablename'] );
		$use_form_alias = $protocol_master_data['ProtocolMaster']['extend_form_alias'];
	    $this->set( 'atim_structure', $this->Structures->get( 'form', $use_form_alias ) );

	    $this->data = $this->ProtocolExtend->find('first',array('conditions'=>array('ProtocolExtend.id'=>$protocol_extend_id)));
	    
		// Get all drugs to override drug_id with generic drug name
		$drug_list = $this->Drug->find('all', array('fields' => array('Drug.id', 'Drug.generic_name'), 'order' => array('Drug.generic_name')));
		foreach ( $drug_list as $record ) {
			$drug_id_findall[ $record['Drug']['id'] ] = $record['Drug']['generic_name'];
		}
		$this->set('drug_id_findall', $drug_id_findall);
		
	}

	function add($protocol_master_id=null) {
		$this->set('atim_menu_variables', array('ProtocolMaster.id'=>$protocol_master_id));
		
		// Get treatment master row for extended data
		$protocol_master_data = $this->ProtocolMaster->find('first',array('conditions'=>array('ProtocolMaster.id'=>$protocol_master_id)));

		// Set form alias/tablename to use
		$this->ProtocolExtend = new ProtocolExtend( false, $protocol_master_data['ProtocolMaster']['extend_tablename'] );
		$use_form_alias = $protocol_master_data['ProtocolMaster']['extend_form_alias'];
	    $this->set( 'atim_structure', $this->Structures->get( 'form', $use_form_alias ) );

		// Get all drugs to override drug_id with generic drug name
		$drug_list = $this->Drug->find('all', array('fields' => array('Drug.id', 'Drug.generic_name'), 'order' => array('Drug.generic_name')));
		foreach ( $drug_list as $record ) {
			$drug_id_findall[ $record['Drug']['id'] ] = $record['Drug']['generic_name'];
		}
		$this->set('drug_id_findall', $drug_id_findall);
		
		if ( !empty($this->data) ) {
			$this->data['ProtocolExtend']['protocol_master_id'] = $protocol_master_data['ProtocolMaster']['id'];
			if ( $this->ProtocolExtend->save( $this->data ) ) {
				$this->flash( 'Your data has been saved.', '/protocol/protocol_extends/listall/'.$protocol_master_id );
			}
		} 
	}

	function edit($protocol_master_id=null, $protocol_extend_id=null) {
		
		$this->set('atim_menu_variables', array(
			'ProtocolMaster.id'=>$protocol_master_id,
			'ProtocolExtend.id'=>$protcol_extend_id
		));
		
		// Get treatment master row for extended data
		$protocol_master_data = $this->ProtocolMaster->find('first',array('conditions'=>array('ProtocolMaster.id'=>$protocol_master_id)));
				
		// Set form alias/tablename to use
		$this->ProtocolExtend = new ProtocolExtend( false, $tx_master_data['ProtocolMaster']['extend_tablename'] );
		$use_form_alias = $protocol_master_data['ProtocolMaster']['extend_form_alias'];
	    $this->set('atim_structure', $this->Structures->get('form', $use_form_alias));

	    // Get all drugs to override drug_id with generic drug name
		$drug_list = $this->Drug->find('all', array('fields' => array('Drug.id', 'Drug.generic_name'), 'order' => array('Drug.generic_name')));
		foreach ( $drug_list as $record ) {
			$drug_id_findall[ $record['Drug']['id'] ] = $record['Drug']['generic_name'];
		}
		$this->set('drug_id_findall', $drug_id_findall);
	    
	    $this_data = $this->ProtocolExtend->find('first',array('conditions'=>array('ProtocolExtend.id'=>$protocol_extend_id)));

	    if (!empty($this->data)) {
			$this->ProtocolExtend->id = $protocol_extend_id;
			if ($this->ProtocolExtend->save($this->data)) {
				$this->flash( 'Your data has been updated.','/protocol/protocol_extends/detail/'.$protocol_master_id.'/'.$protocol_extend_id);
			}
		} else {
			$this->data = $this_data;
		}
	}

	function delete($protocol_master_id=null, $protocol_extend_id=null) {

		$this->ProtocolExtend->del( $protocol_extend_id );
		$this->flash( 'Your data has been deleted.', '/protocol/protocol_extends/listall/'.$protocol_master_id );

	}
/*
	var $name = 'ProtocolExtends';
	var $uses = array( 'ProtocolMaster', 'ProtocolExtend', 'Drug' );

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

	function listall( $protocol_master_id=0 ) {

		// get Extend tablename and form_alias from Master row

			$this->ProtocolMaster->id = $protocol_master_id;
			$protocol_master_data = $this->ProtocolMaster->read();

			$use_form_alias = $protocol_master_data['ProtocolMaster']['extend_form_alias'];
			$this->ProtocolExtend = new ProtocolExtend( false, $protocol_master_data['ProtocolMaster']['extend_tablename'] );

		// set MENU varible for echo on VIEW
			$ctrapp_menu[] = $this->Menus->tabs( 'proto_CAN_37', 'proto_CAN_83', $protocol_master_id );	
		$this->set( 'ctrapp_menu', $ctrapp_menu );

		// set FORM variable, for HELPER call on VIEW
		$this->set( 'ctrapp_form', $this->Forms->getFormArray( $use_form_alias ) );

		// set SUMMARY varible from plugin's COMPONENTS
		$this->set( 'ctrapp_summary', $this->Summaries->build( $protocol_master_id ) );

		// set SIDEBAR variable, for HELPER call on VIEW
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set( 'ctrapp_sidebar', $this->Sidebars->getColsArray( $this->params['plugin'].'_'.$this->params['controller'].'_'.$this->params['action'] ) );

		// set FORM variable, for HELPER call on VIEW
		$this->set( 'protocol_master_id', $protocol_master_id );

			$criteria = array();
			$criteria['protocol_master_id'] = $protocol_master_id;
			$criteria = array_filter($criteria);

		list( $order, $limit, $page ) = $this->Pagination->init( $criteria );

		$this->set( 'protocol_extends', $this->ProtocolExtend->findAll( $criteria, NULL, $order, $limit, $page ) );

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

	function detail( $protocol_master_id=0, $protocol_extend_id=0 ) {

		// get Extend tablename and form_alias from Master row

			$this->ProtocolMaster->id = $protocol_master_id;
			$protocol_master_data = $this->ProtocolMaster->read();

			$use_form_alias = $protocol_master_data['ProtocolMaster']['extend_form_alias'];
			$this->ProtocolExtend = new ProtocolExtend( false, $protocol_master_data['ProtocolMaster']['extend_tablename'] );

		// set MENU varible for echo on VIEW
		$ctrapp_menu[] = $this->Menus->tabs( 'proto_CAN_37', 'proto_CAN_83', $protocol_master_id );	
		$this->set( 'ctrapp_menu', $ctrapp_menu );

		// set FORM variable, for HELPER call on VIEW
		$this->set( 'ctrapp_form', $this->Forms->getFormArray( $use_form_alias ) );

		// set SUMMARY varible from plugin's COMPONENTS
		$this->set( 'ctrapp_summary', $this->Summaries->build( $protocol_master_id) );

		// set SIDEBAR variable, for HELPER call on VIEW
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set( 'ctrapp_sidebar', $this->Sidebars->getColsArray( $this->params['plugin'].'_'.$this->params['controller'].'_'.$this->params['action'] ) );

		// set FORM variable, for HELPER call on VIEW
		$this->set( 'protocol_master_id', $protocol_master_id );
		$this->set( 'protocol_extend_id', $protocol_extend_id );

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

		$this->ProtocolExtend->id = $protocol_extend_id;
		$this->set( 'data', $this->ProtocolExtend->read() );
	}

	function add( $protocol_master_id=0 ) {

		// get Extend tablename and form_alias from Master row

			$this->ProtocolMaster->id = $protocol_master_id;
			$protocol_master_data = $this->ProtocolMaster->read();

			$use_form_alias = $protocol_master_data['ProtocolMaster']['extend_form_alias'];
			$this->ProtocolExtend = new ProtocolExtend( false, $protocol_master_data['ProtocolMaster']['extend_tablename'] );

		// setup MODEL(s) validation array(s) for displayed FORM
		foreach ( $this->Forms->getValidateArray( $use_form_alias ) as $validate_model=>$validate_rules ) {
			$this->{ $validate_model }->validate = $validate_rules;
		}

		// set MENU varible for echo on VIEW
		$ctrapp_menu[] = $this->Menus->tabs( 'proto_CAN_37', 'proto_CAN_83', $protocol_master_id );	
		$this->set( 'ctrapp_menu', $ctrapp_menu );

		// set FORM variable, for HELPER call on VIEW
		$this->set( 'ctrapp_form', $this->Forms->getFormArray( $use_form_alias ) );

		// set SUMMARY varible from plugin's COMPONENTS
		$this->set( 'ctrapp_summary', $this->Summaries->build( $protocol_master_id) );

		// set SIDEBAR variable, for HELPER call on VIEW
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set( 'ctrapp_sidebar', $this->Sidebars->getColsArray( $this->params['plugin'].'_'.$this->params['controller'].'_'.$this->params['action'] ) );

		// set FORM variable, for HELPER call on VIEW
		$this->set( 'protocol_master_id', $protocol_master_id );

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

		// look for CUSTOM HOOKS, "format"
		$custom_ctrapp_controller_hook 
			= APP . 'plugins' . DS . $this->params['plugin'] . DS . 
			'controllers' . DS . 'hooks' . DS . 
			$this->params['controller'].'_'.$this->params['action'].'_format.php';
		
		if (file_exists($custom_ctrapp_controller_hook)) {
			require($custom_ctrapp_controller_hook);
		}
		
		if ( !empty($this->data) ) {

			// after DETAIL model is set and declared
			$this->cleanUpFields('ProtocolExtend');

			if ( $this->ProtocolExtend->save( $this->data ) ) {
				$this->flash( 'Your data has been saved.', '/protocol_extends/listall/'.$protocol_master_id );
			}

		}

	}

	function edit( $protocol_master_id=0, $protocol_extend_id=0 ) {

		// get Extend tablename and form_alias from Master row

			$this->ProtocolMaster->id = $protocol_master_id;
			$protocol_master_data = $this->ProtocolMaster->read();

			$use_form_alias = $protocol_master_data['ProtocolMaster']['extend_form_alias'];
			$this->ProtocolExtend = new ProtocolExtend( false, $protocol_master_data['ProtocolMaster']['extend_tablename'] );

		// setup MODEL(s) validation array(s) for displayed FORM
		foreach ( $this->Forms->getValidateArray( $use_form_alias ) as $validate_model=>$validate_rules ) {
			$this->{ $validate_model }->validate = $validate_rules;
		}

		// set MENU varible for echo on VIEW
		$ctrapp_menu[] = $this->Menus->tabs( 'proto_CAN_37', 'proto_CAN_83', $protocol_master_id );	
		$this->set( 'ctrapp_menu', $ctrapp_menu );

		// set FORM variable, for HELPER call on VIEW
		$this->set( 'ctrapp_form', $this->Forms->getFormArray( $use_form_alias ) );

		// set SUMMARY varible from plugin's COMPONENTS
		$this->set( 'ctrapp_summary', $this->Summaries->build( $protocol_master_id) );

		// set SIDEBAR variable, for HELPER call on VIEW
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set( 'ctrapp_sidebar', $this->Sidebars->getColsArray( $this->params['plugin'].'_'.$this->params['controller'].'_'.$this->params['action'] ) );

		// set FORM variable, for HELPER call on VIEW
		$this->set( 'protocol_master_id', $protocol_master_id );
		$this->set( 'protocol_extend_id', $protocol_extend_id );

		// look for CUSTOM HOOKS, "format"
		$custom_ctrapp_controller_hook 
			= APP . 'plugins' . DS . $this->params['plugin'] . DS . 
			'controllers' . DS . 'hooks' . DS . 
			$this->params['controller'].'_'.$this->params['action'].'_format.php';
		
		if (file_exists($custom_ctrapp_controller_hook)) {
			require($custom_ctrapp_controller_hook);
		}
		
		if ( empty($this->data) ) {

			$this->ProtocolExtend->id = $protocol_extend_id;
			$this->data = $this->ProtocolExtend->read();
			$this->set( 'data', $this->data );

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

		} else {

			// after DETAIL model is set and declared
			$this->cleanUpFields('ProtocolExtend');

			if ( $this->ProtocolExtend->save( $this->data['ProtocolExtend'] ) ) {
				$this->flash( 'Your data has been updated.','/protocol_extends/detail/'.$protocol_master_id.'/'.$protocol_extend_id );
			}

		}

	}

	function delete( $protocol_master_id=0, $protocol_extend_id=0 ) {

		// get Extend tablename and form_alias from Master row

		// look for CUSTOM HOOKS, "format"
		$custom_ctrapp_controller_hook 
			= APP . 'plugins' . DS . $this->params['plugin'] . DS . 
			'controllers' . DS . 'hooks' . DS . 
			$this->params['controller'].'_'.$this->params['action'].'_format.php';
		
		if (file_exists($custom_ctrapp_controller_hook)) {
			require($custom_ctrapp_controller_hook);
		}
		
			$this->ProtocolMaster->id = $protocol_master_id;
			$protocol_master_data = $this->ProtocolMaster->read();

			$use_form_alias = $protocol_master_data['ProtocolMaster']['extend_form_alias'];
			$this->ProtocolExtend = new ProtocolExtend( false, $protocol_master_data['ProtocolMaster']['extend_tablename'] );

		$this->ProtocolExtend->del( $protocol_extend_id );
		$this->flash( 'Your data has been deleted.', '/protocol_extends/listall/'.$protocol_master_id );

	}
*/
}

?>
