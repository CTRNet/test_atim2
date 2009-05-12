<?php

class SopExtendsController extends SopAppController {

	$uses = array('SopMaster', 'SopExtend', 'Material');
	$paginate = array('SopMaster'=>array('limit'=>10,'order'=>'SopMaster.title ASC'));
	$components = array('Summaries');
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

	var $name = 'SopExtends';
	var $uses = array( 'SopMaster', 'SopExtend', 'Material');
	
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

	function index() {
		// nothing...
	}

	function listall( $sop_master_id=0 ) {

		// get Extend tablename and form_alias from Master row
		$this->set( 'ctrapp_summary', $this->Summaries->build($sop_master_id) );

		$this->SopMaster->id = $sop_master_id;
		$sop_master_data = $this->SopMaster->read();

		$use_form_alias = $sop_master_data['SopMaster']['extend_form_alias'];
		$this->SopExtend = new SopExtend( false, $sop_master_data['SopMaster']['extend_tablename'] );

		// set MENU varible for echo on VIEW
		$ctrapp_menu[] = $this->Menus->tabs( 'sop_CAN_01', 'sop_CAN_04', $sop_master_id );
		$this->set( 'ctrapp_menu', $ctrapp_menu );

		// set FORM variable, for HELPER call on VIEW
		$this->set( 'ctrapp_form', $this->Forms->getFormArray( $use_form_alias ) );

		// set SIDEBAR variable, for HELPER call on VIEW
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set( 'ctrapp_sidebar', $this->Sidebars->getColsArray( $this->params['plugin'].'_'.$this->params['controller'].'_'.$this->params['action'] ) );

		// set FORM variable, for HELPER call on VIEW
		$this->set( 'sop_master_id', $sop_master_id );

		$criteria = array();
		$criteria['sop_master_id'] = $sop_master_id;
		$criteria = array_filter($criteria);

		list( $order, $limit, $page ) = $this->Pagination->init( $criteria );

		$this->set( 'sop_extends', $this->SopExtend->findAll( $criteria, NULL, $order, $limit, $page ) );

		// Get all SopMaster for dropdown list
		$criteria = NULL;
		$fields = 'Material.id, Material.item_name';
		$order = 'Material.item_name ASC';
		$material_id_findall_result = $this->Material->findAll( $criteria, $fields, $order );
		$material_id_findall = array();
		foreach ( $material_id_findall_result as $record ) {
			$material_id_findall[ $record['Material']['id'] ] = $record['Material']['item_name'];
		}
		$this->set( 'material_id_findall', $material_id_findall ); 

	}

	function detail( $sop_master_id=0, $sop_extend_id=0 ) {

		// get Extend tablename and form_alias from Master row
		$this->set( 'ctrapp_summary', $this->Summaries->build($sop_master_id) );

		$this->SopMaster->id = $sop_master_id;
		$sop_master_data = $this->SopMaster->read();

		$use_form_alias = $sop_master_data['SopMaster']['extend_form_alias'];
		$this->SopExtend = new SopExtend( false, $sop_master_data['SopMaster']['extend_tablename'] );

		// set MENU varible for echo on VIEW
		$ctrapp_menu[] = $this->Menus->tabs( 'sop_CAN_01', 'sop_CAN_04', $sop_master_id );
		$this->set( 'ctrapp_menu', $ctrapp_menu );

		// set FORM variable, for HELPER call on VIEW
		$this->set( 'ctrapp_form', $this->Forms->getFormArray( $use_form_alias ) );

		// set SUMMARY varible from plugin's COMPONENTS
	//	$this->set( 'ctrapp_summary', $this->Summaries->build( ) );

		// set SIDEBAR variable, for HELPER call on VIEW
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set( 'ctrapp_sidebar', $this->Sidebars->getColsArray( $this->params['plugin'].'_'.$this->params['controller'].'_'.$this->params['action'] ) );

		// set FORM variable, for HELPER call on VIEW
		$this->set( 'sop_master_id', $sop_master_id );
		$this->set( 'sop_extend_id', $sop_extend_id );

		// Get all SopMaster for dropdown list
		$criteria = NULL;
		$fields = 'Material.id, Material.item_name';
		$order = 'Material.item_name ASC';
		$material_id_findall_result = $this->Material->findAll( $criteria, $fields, $order );
		$material_id_findall = array();
		foreach ( $material_id_findall_result as $record ) {
			$material_id_findall[ $record['Material']['id'] ] = $record['Material']['item_name'];
		}
		$this->set( 'material_id_findall', $material_id_findall );

		$this->SopExtend->id = $sop_extend_id;
		$this->set( 'data', $this->SopExtend->read() ); 
	}

	function add( $sop_master_id=0 ) {

		// get Extend tablename and form_alias from Master row
		$this->set( 'ctrapp_summary', $this->Summaries->build($sop_master_id) );

		$this->SopMaster->id = $sop_master_id;
		$sop_master_data = $this->SopMaster->read();

		$use_form_alias = $sop_master_data['SopMaster']['extend_form_alias'];
		$this->SopExtend = new SopExtend( false, $sop_master_data['SopMaster']['extend_tablename'] );

		// setup MODEL(s) validation array(s) for displayed FORM
		foreach ( $this->Forms->getValidateArray( $use_form_alias ) as $validate_model=>$validate_rules ) {
			$this->{ $validate_model }->validate = $validate_rules;
		}

		// set MENU varible for echo on VIEW
		$ctrapp_menu[] = $this->Menus->tabs( 'sop_CAN_01', 'sop_CAN_04', $sop_master_id );
		$this->set( 'ctrapp_menu', $ctrapp_menu );

		// set FORM variable, for HELPER call on VIEW
		$this->set( 'ctrapp_form', $this->Forms->getFormArray( $use_form_alias ) );

		// set SUMMARY varible from plugin's COMPONENTS
		//$this->set( 'ctrapp_summary', $this->Summaries->build( ) );

		// set SIDEBAR variable, for HELPER call on VIEW
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set( 'ctrapp_sidebar', $this->Sidebars->getColsArray( $this->params['plugin'].'_'.$this->params['controller'].'_'.$this->params['action'] ) );

		// set FORM variable, for HELPER call on VIEW
		$this->set( 'sop_master_id', $sop_master_id );

		// Get all SopMaster for dropdown list
		$criteria = NULL;
		$fields = 'Material.id, Material.item_name';
		$order = 'Material.item_name ASC';
		$material_id_findall_result = $this->Material->findAll( $criteria, $fields, $order );
		$material_id_findall = array();
		foreach ( $material_id_findall_result as $record ) {
			$material_id_findall[ $record['Material']['id'] ] = $record['Material']['item_name'];
		}
		$this->set( 'material_id_findall', $material_id_findall );

		if ( !empty($this->data) ) {

			// after DETAIL model is set and declared
			$this->cleanUpFields('SopExtend');

			if ( $this->SopExtend->save( $this->data ) ) {
				$this->flash( 'Your data has been saved.', '/sop_extends/listall/'.$sop_master_id );
			}

		}

	}

	function edit( $sop_master_id=0, $sop_extend_id=0 ) {

		// get Extend tablename and form_alias from Master row
		$this->set( 'ctrapp_summary', $this->Summaries->build($sop_master_id) );

		$this->SopMaster->id = $sop_master_id;
		$sop_master_data = $this->SopMaster->read();

		$use_form_alias = $sop_master_data['SopMaster']['extend_form_alias'];
		$this->SopExtend = new SopExtend( false, $sop_master_data['SopMaster']['extend_tablename'] );

		// setup MODEL(s) validation array(s) for displayed FORM
		foreach ( $this->Forms->getValidateArray( $use_form_alias ) as $validate_model=>$validate_rules ) {
			$this->{ $validate_model }->validate = $validate_rules;
		}

		// set MENU varible for echo on VIEW
		$ctrapp_menu[] = $this->Menus->tabs( 'sop_CAN_01', 'sop_CAN_04', $sop_master_id );
		$this->set( 'ctrapp_menu', $ctrapp_menu );

		// set FORM variable, for HELPER call on VIEW
		$this->set( 'ctrapp_form', $this->Forms->getFormArray( $use_form_alias ) );

		// set SUMMARY varible from plugin's COMPONENTS
		//$this->set( 'ctrapp_summary', $this->Summaries->build( ) );

		// set SIDEBAR variable, for HELPER call on VIEW
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set( 'ctrapp_sidebar', $this->Sidebars->getColsArray( $this->params['plugin'].'_'.$this->params['controller'].'_'.$this->params['action'] ) );

		// set FORM variable, for HELPER call on VIEW
		$this->set( 'sop_master_id', $sop_master_id );
		$this->set( 'sop_extend_id', $sop_extend_id );

		if ( empty($this->data) ) {

			$this->SopExtend->id = $sop_extend_id;
			$this->data = $this->SopExtend->read();
			$this->set( 'data', $this->data );

			// Get all SopMaster for dropdown list
			$criteria = NULL;
			$fields = 'Material.id, Material.item_name';
			$order = 'Material.item_name ASC';
			$material_id_findall_result = $this->Material->findAll( $criteria, $fields, $order );
			$material_id_findall = array();
			foreach ( $material_id_findall_result as $record ) {
				$material_id_findall[ $record['Material']['id'] ] = $record['Material']['item_name'];
			}
			$this->set( 'material_id_findall', $material_id_findall );
		} else {
			// after DETAIL model is set and declared
			$this->cleanUpFields('SopExtend');

			if ( $this->SopExtend->save( $this->data['SopExtend'] ) ) {
				$this->flash( 'Your data has been updated.','/sop_extends/detail/'.$sop_master_id.'/'.$sop_extend_id );
			}
		}
	}
*/
	function delete( $sop_master_id=0, $sop_extend_id=0 ) {}
/*
		// get Extend tablename and form_alias from Master row

		$this->SopMaster->id = $sop_master_id;
		$sop_master_data = $this->SopMaster->read();

		$use_form_alias = $sop_master_data['SopMaster']['extend_form_alias'];
		$this->SopExtend = new SopExtend( false, $sop_master_data['SopMaster']['extend_tablename'] );

		$this->SopExtend->del( $sop_extend_id );
		$this->flash( 'Your data has been deleted.', '/sop_extends/listall/'.$sop_master_id );

	}
*/
}

?>
