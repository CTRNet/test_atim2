<?php

class UserLogsController extends AdministrateAppController {
	
	var $uses = array('UserLog');
	var $paginate = array('UserLog'=>array('limit'=>10,'order'=>'UserLog.visited DESC')); 
	
	function index( $bank_id, $group_id, $user_id ) {
		$this->set( 'atim_menu_variables', array('Bank.id'=>$bank_id,'Group.id'=>$group_id,'User.id'=>$user_id) );
		
		$this->hook();
		
		$this->data = $this->paginate($this->UserLog, array('UserLog.user_id'=>$user_id));
	}
	
	/*
	function index( $bank_id, $group_id, $user_id ) {
		
		// set MENU varible for echo on VIEW 
		$ctrapp_menu[] = $this->Menus->tabs( 'core_CAN_41', 'core_CAN_73', '' );
		$ctrapp_menu[] = $this->Menus->tabs( 'core_CAN_73', 'core_CAN_86', $bank_id );
		$ctrapp_menu[] = $this->Menus->tabs( 'core_CAN_86', 'core_CAN_89', $bank_id.'/'.$group_id );
		$ctrapp_menu[] = $this->Menus->tabs( 'core_CAN_89', 'core_CAN_95', $bank_id.'/'.$group_id.'/'.$user_id );
		$this->set( 'ctrapp_menu', $ctrapp_menu );
		
		// set FORM variable, for HELPER call on VIEW 
		$this->set( 'ctrapp_form', $this->Forms->getFormArray('userlogs') );
		
		// set SUMMARY varible from plugin's COMPONENTS 
		$this->set( 'ctrapp_summary', $this->Summaries->build( $this->othAuth->user('id') ) );
		
		// set SIDEBAR variable, for HELPER call on VIEW 
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set( 'ctrapp_sidebar', $this->Sidebars->getColsArray( $this->params['plugin'].'_'.$this->params['controller'].'_'.$this->params['action'] ) );
		
		// set FORM variable, for HELPER call on VIEW 
		$this->set( 'bank_id', $bank_id );
		$this->set( 'group_id', $group_id );
		$this->set( 'user_id', $user_id );
		
			$criteria = array();
			$criteria['user_id'] = $user_id;
			$criteria = array_filter($criteria);
			
			$sort_order = 'UserLog.visited DESC';
			
		list( $order, $limit, $page ) = $this->Pagination->init( $criteria );
		$this->set( 'userlogs', $this->UserLog->findAll( $criteria, NULL, $sort_order, $limit, $page ) );
		
	}
	*/

}

?>