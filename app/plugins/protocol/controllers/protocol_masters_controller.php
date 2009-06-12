<?php

class ProtocolMastersController extends ProtocolAppController {

	var $uses = array('Protocol.ProtocolControl', 'Protocol.ProtocolMaster');
	var $paginate = array('ProtocolMaster'=>array('limit'=>10,'order'=>'ProtocolMaster.name DESC'));
	
	function listall() {
		
		$this->data = $this->paginate($this->ProtocolMaster, array());
		
		// find all TXCONTROLS, for ADD form
		$this->set('protocol_controls', $this->ProtocolControl->find('all'));	
	}
	
	function add() {
		$this->set( 'atim_structure', $this->Structures->get('pd_chemos',$this->data['ProtocolMaster']['detail_form_alias']) );
		//$this->data['ProtocolMaster']['detail_form_alias'] = 'pd_chemos';
		//$this->data['ProtocolMaster']['detail_tablename'] = 'pd_chemos';
	
		if ( !empty($this->data) ) {
			if ( $this->ProtocolMaster->save($this->data) ) {
				$this->flash( 'Your data has been updated.','/protocol/protocol_masters/detail/'.$this->ProtocolMaster->id );
			}
		}
	}
	
	function detail($protocol_master_id) {
		if ( !$protocol_master_id ) { $this->redirect( '/pages/err_clin-ann_no_part_id', NULL, TRUE ); }
	
		$this->set( 'atim_menu_variables', array('ProtocolMaster.id'=>$protocol_master_id));
		$this->data = $this->ProtocolMaster->find('first',array('conditions'=>array('ProtocolMaster.id'=>$protocol_master_id)));
		
		// set FORM ALIAS based off VALUE from MASTER table
		$this->set( 'atim_structure', $this->Structures->get('form',$this->data['TreatmentMaster']['detail_form_alias']) );
	}

	function edit( $protocol_master_id  ) {
		if ( !$protocol_master_id ) { $this->redirect( '/pages/err_clin-ann_no_part_id', NULL, TRUE ); }
		
		$this->set( 'atim_menu_variables', array('ProtocolMaster.id'=>$protocol_master_id) );
		$this_data = $this->ProtocolMaster->find('first',array('conditions'=>array('ProtocolMaster.id'=>$protocol_master_id)));
		
		// set FORM ALIAS based off VALUE from MASTER table
		$this->set( 'atim_structure', $this->Structures->get('form',$this_data['ProtocolMaster']['detail_form_alias']) );
		
		if ( !empty($this->data) ) {
			$this->ProtocolMaster->id = $tx_master_id;
			if ( $this->ProtocolMaster->save($this->data) ) $this->flash( 'Your data has been updated.','/protocol/protocol_masters/detail/'.$protocol_master_id.'/');
		} else {
			$this->data = $this_data;
		}
		
	}
	
	function delete( $protocol_master_id ) {
		if ( !$protocol_master_id ) { $this->redirect( '/pages/err_clin-ann_no_part_id', NULL, TRUE ); }
		
		if( $this->ProtocolMaster->del( $protocol_master_id ) ) {
			$this->flash( 'Your data has been deleted.', '/protocol/protocol_masters/listall/');
		} else {
			$this->flash( 'Your data has been deleted.', '/protocol/protocol_masters/listall/');
		}
	}
	
//	var $components = array('Summaries');
//	
//	var $helpers = array('Summaries', 'MoreForm');

/*  
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

	function listall() {

		// set MENU varible for echo on VIEW
//		$ctrapp_menu[] = $this->Menus->tabs( 'tool_CAN_37', 'tool_CAN_81', null );
		$this->set( 'ctrapp_menu', array() );

		// set FORM variable, for HELPER call on VIEW
		$this->set( 'ctrapp_form', $this->Forms->getFormArray('protocol_masters') );

		// set SUMMARY varible from plugin's COMPONENTS
		$this->set( 'ctrapp_summary', $this->Summaries->build() );

		// set SIDEBAR variable, for HELPER call on VIEW
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set( 'ctrapp_sidebar', $this->Sidebars->getColsArray( $this->params['plugin'].'_'.$this->params['controller'].'_'.$this->params['action'] ) );

			$criteria = array();

		list( $order, $limit, $page ) = $this->Pagination->init( $criteria );
		$this->set( 'protocol_masters', $this->ProtocolMaster->findAll( $criteria, NULL, $order, $limit, $page ) );

			$conditions = array();
			$conditions = array_filter($conditions);

		// findall ProtocolControlS, for ADD form
		$this->set( 'protocol_controls', $this->ProtocolControl->findAll( $conditions ) );

		/*
		$protocol_masters = $this->ProtocolMaster->findAll( $criteria, NULL, $order, $limit, $page );

		echo('<pre>');
		print_r($protocol_masters);
		echo('</pre>');
		die();
		

	}

	function detail( $protocol_master_id=null ) {

		// set SUMMARY varible from plugin's COMPONENTS
		$this->set( 'ctrapp_summary', $this->Summaries->build($protocol_master_id) );

		// set SIDEBAR variable, for HELPER call on VIEW
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set( 'ctrapp_sidebar', $this->Sidebars->getColsArray( $this->params['plugin'].'_'.$this->params['controller'].'_'.$this->params['action'] ) );

		// set FORM variable, for HELPER call on VIEW
		$this->set( 'protocol_master_id', $protocol_master_id );

		// Protocol MASTER info defines ProtocolDetail info, including FORM alias

			// read ProtocolMaster info, which contains FORM alias and DETAIL tablename
			$this->ProtocolMaster->id = $protocol_master_id;
			$protocol_master_data = $this->ProtocolMaster->read();

			// set MENU varible for echo on VIEW
			$ctrapp_menu[] = $this->Menus->tabs( 'proto_CAN_37', 'proto_CAN_82', $protocol_master_id );	
			if ( empty($protocol_master_data['ProtocolMaster']['extend_tablename']) ) {
				$ctrapp_menu['0']['proto_CAN_83']['allowed'] = false;
			}
			
			$this->set( 'ctrapp_menu', $ctrapp_menu );
			
			// FORM alias, from Protocol MASTER field
			$this->set( 'ctrapp_form', $this->Forms->getFormArray( $protocol_master_data['ProtocolMaster']['detail_form_alias'] ) );

			// start new instance of ProtocolDetail model, using TABLENAME from Protocol MASTER
			$this->ProtocolDetail = new ProtocolDetail( false, $protocol_master_data['ProtocolMaster']['detail_tablename'] );
			// read related ProtocolDetail row, whose ID should be same as ProtocolMaster ID
			$this->ProtocolDetail->id = $protocol_master_id;
			$protocol_specific_data = $this->ProtocolDetail->read();

			// merge both datasets into a SINGLE dataset, set for VIEW
			$this->set( 'data', array_merge( $protocol_master_data, $protocol_specific_data )  );

	}

	function add( $protocol_control_id=null ) {

		if ( $protocol_control_id!=null ) {

			// read ProtocolControl info, which contains FORM alias and DETAIL tablename
			$this->ProtocolControl->id = $protocol_control_id;
			$protocol_control_data = $this->ProtocolControl->read();
			$this->set( 'control_data', $protocol_control_data  );

			// start new instance of ProtocolDetail model, using TABLENAME from Protocol MASTER
			$this->ProtocolDetail = new ProtocolDetail( false, $protocol_control_data['ProtocolControl']['detail_tablename'] );

		} else if ( isset($this->params['form']['protocol_control_id']) ) {

			// get ProtocolControl ID from LISTALL add form submit
			$protocol_control_id = $this->params['form']['protocol_control_id'];

			// read ProtocolControl info, which contains FORM alias and DETAIL tablename
			$this->ProtocolControl->id = $protocol_control_id;
			$protocol_control_data = $this->ProtocolControl->read();
			$this->set( 'control_data', $protocol_control_data  );

			// start new instance of ProtocolDetail model, using TABLENAME from Protocol MASTER
			$this->ProtocolDetail = new ProtocolDetail( false, $protocol_control_data['ProtocolControl']['detail_tablename'] );

		} else {

			// error
			die('missing protocol control id');

		}

		// get all DX rows, for Protocol FILTER pulldown && DX input
		$criteria = '';
		$order = 'case_number ASC, dx_date ASC';
//		$this->set( 'dx_listall', $this->Diagnosis->findAll( $criteria, NULL, $order ) );

		// set MENU varible for echo on VIEW
		$this->set( 'ctrapp_menu', array() );

		// set FORM variable, for HELPER call on VIEW
		$this->set( 'ctrapp_form', $this->Forms->getFormArray( $protocol_control_data['ProtocolControl']['detail_form_alias'] ) );

		// set SUMMARY varible from plugin's COMPONENTS
		$this->set( 'ctrapp_summary', $this->Summaries->build() );

		// set SIDEBAR variable, for HELPER call on VIEW
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set( 'ctrapp_sidebar', $this->Sidebars->getColsArray( $this->params['plugin'].'_'.$this->params['controller'].'_'.$this->params['action'] ) );

		// set FORM variable, for HELPER call on VIEW
		$this->set( 'protocol_control_id', $protocol_control_id );

		// setup MODEL(s) validation array(s) for displayed FORM
		foreach ( $this->Forms->getValidateArray( $protocol_control_data['ProtocolControl']['detail_form_alias'] ) as $validate_model=>$validate_rules ) {
			$this->{ $validate_model }->validate = $validate_rules;
		}

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
			$this->cleanUpFields('ProtocolDetail');

			if ( !isset($this->data['ProtocolDetail']) ) { $this->data['ProtocolDetail'] = array(); } // if not DETAIL form elements used...

			if ( $this->ProtocolMaster->validates( $this->data['ProtocolMaster'] ) && $this->ProtocolDetail->validates( $this->data['ProtocolDetail'] ) ) {

				// save ProtocolMaster data
				$this->ProtocolMaster->save( $this->data['ProtocolMaster'] );

				// set ID fields based on ProtocolMaster
				$this->data['ProtocolDetail']['id'] = $this->ProtocolMaster->getLastInsertId();
				$this->data['ProtocolDetail']['protocol_master_id'] = $this->ProtocolMaster->getLastInsertId();

				// save ProtocolDetail data
				$this->ProtocolDetail->save( $this->data['ProtocolDetail'] );

				$this->flash( 'Your data has been updated.','/protocol_masters/listall/' );

			}

		}

	}

	function edit( $protocol_master_id=null ) {

		// get all DX rows, for Protocol FILTER pulldown && DX input
		$criteria = '';
		$order = 'case_number ASC, dx_date ASC';
//		$this->set( 'dx_listall', $this->Diagnosis->findAll( $criteria, NULL, $order ) );

		// set MENU varible for echo on VIEW
		$ctrapp_menu[] = $this->Menus->tabs( 'proto_CAN_37', 'proto_CAN_82', $protocol_master_id );	
		if ( empty($protocol_master_data['ProtocolMaster']['extend_tablename']) ) {
			$ctrapp_menu['0']['proto_CAN_83']['allowed'] = false;
		}
		$this->set( 'ctrapp_menu', $ctrapp_menu );

		// set FORM variable, for HELPER call on VIEW
		// $this->set( 'ctrapp_form', $this->Forms->getFormArray('protocol_masters') );

		// set SUMMARY varible from plugin's COMPONENTS
		$this->set( 'ctrapp_summary', $this->Summaries->build($protocol_master_id) );

		// set SIDEBAR variable, for HELPER call on VIEW
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set( 'ctrapp_sidebar', $this->Sidebars->getColsArray( $this->params['plugin'].'_'.$this->params['controller'].'_'.$this->params['action'] ) );

		// set FORM variable, for HELPER call on VIEW
		$this->set( 'protocol_master_id', $protocol_master_id );

		// Protocol MASTER info defines ProtocolDetail info, including FORM alias

			// read ProtocolMaster info, which contains FORM alias and DETAIL tablename
			$this->ProtocolMaster->id = $protocol_master_id;
			$protocol_master_data = $this->ProtocolMaster->read();

			// setup MODEL(s) validation array(s) for displayed FORM
				foreach ( $this->Forms->getValidateArray( $protocol_master_data['ProtocolMaster']['detail_form_alias'] ) as $validate_model=>$validate_rules ) {
					$this->{ $validate_model }->validate = $validate_rules;
				}

			// FORM alias, from Protocol MASTER field
			$this->set( 'ctrapp_form', $this->Forms->getFormArray( $protocol_master_data['ProtocolMaster']['detail_form_alias'] ) );

			// start new instance of ProtocolDetail model, using TABLENAME from Protocol MASTER
			$this->ProtocolDetail = new ProtocolDetail( false, $protocol_master_data['ProtocolMaster']['detail_tablename'] );
			// read related ProtocolDetail row, whose ID should be same as ProtocolMaster ID
			$this->ProtocolDetail->id = $protocol_master_id;
			$protocol_specific_data = $this->ProtocolDetail->read();

		// look for CUSTOM HOOKS, "format"
		$custom_ctrapp_controller_hook 
			= APP . 'plugins' . DS . $this->params['plugin'] . DS . 
			'controllers' . DS . 'hooks' . DS . 
			$this->params['controller'].'_'.$this->params['action'].'_format.php';
		
		if (file_exists($custom_ctrapp_controller_hook)) {
			require($custom_ctrapp_controller_hook);
		}
		
		if ( empty($this->data) ) {

			// merge both datasets into a SINGLE dataset, set for VIEW
			$this->data = array_merge( $protocol_master_data, $protocol_specific_data );
			$this->set( 'data', $this->data  );

		} else {

			// after DETAIL model is set and declared
			$this->cleanUpFields('ProtocolDetail');

			if ( !isset($this->data['ProtocolDetail']) ) { $this->data['ProtocolDetail'] = array(); } // if not DETAIL form elements used...

			if ( $this->ProtocolMaster->validates( $this->data['ProtocolMaster'] ) && $this->ProtocolDetail->validates( $this->data['ProtocolDetail'] ) ) {

				$this->ProtocolMaster->save( $this->data['ProtocolMaster'] );
				$this->ProtocolDetail->save( $this->data['ProtocolDetail'] );

				$this->flash( 'Your data has been updated.','/protocol_masters/detail/'.$protocol_master_id );
			}

		}



	}

	function delete( $protocol_master_id=null ) {

		if(!$this->allowProtocolDeletion($protocol_master_id)) {
			$this->flash( 'Your are not allowed to delete this data.','/protocol_masters/detail/'.$protocol_master_id );
			exit;
		}
	
		// look for CUSTOM HOOKS, "format"
		$custom_ctrapp_controller_hook 
			= APP . 'plugins' . DS . $this->params['plugin'] . DS . 
			'controllers' . DS . 'hooks' . DS . 
			$this->params['controller'].'_'.$this->params['action'].'_format.php';
		
		if (file_exists($custom_ctrapp_controller_hook)) {
			require($custom_ctrapp_controller_hook);
		}
		
		// read ProtocolMaster info, which contains FORM alias and DETAIL tablename
		$this->ProtocolMaster->id = $protocol_master_id;
		$protocol_master_data = $this->ProtocolMaster->read();

		// start new instance of ProtocolDetail model, using TABLENAME from Protocol MASTER
		$this->ProtocolDetail = new ProtocolDetail( false, $protocol_master_data['ProtocolMaster']['detail_tablename'] );

		// delete MASTER/DETAIL rows
		$this->ProtocolMaster->del( $protocol_master_id );
		$this->ProtocolDetail->del( $protocol_master_id );

		$this->flash( 'Your data has been deleted.', '/protocol_masters/listall/' );

	}
	
	function allowProtocolDeletion($protocol_master_id) {

		// Check into protocol extend table name
		$criteria = array();
		$exten_tables_list = 
			$this->ProtocolControl->generateList(
				$criteria,
				null, 
				null,
				'{n}.ProtocolControl.id', 
				'{n}.ProtocolControl.extend_tablename');
			
		if(!empty($exten_tables_list)) {
			foreach($exten_tables_list as $id => $extend_tablename) {
				
				$this->ProtocolExtend = new ProtocolExtend( false, $extend_tablename );
				
				$criteria = 'ProtocolExtend.protocol_master_id ="' .$protocol_master_id.'"';			 
				$record_nbr = $this->ProtocolExtend->findCount($criteria);
				
				if($record_nbr > 0){
					return FALSE;
				}
				
			}
		}
				
		// Check into trt table name
		$criteria = 'TreatmentMaster.protocol_id ="' .$protocol_master_id.'"';			 
		$record_nbr = $this->TreatmentMaster->findCount($criteria);
		
		if($record_nbr > 0){
			return FALSE;
		}
		
		// Etc
		
		return TRUE;
	}
*/
}

?>
