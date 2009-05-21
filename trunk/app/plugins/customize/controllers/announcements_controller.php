<?php

class AnnouncementsController extends AppController {
	
	var $name = 'Announcements';
	var $uses = array('Announcement');
	
	var $components = array('Summaries');
	var $helpers = array('Summaries');
	
	function index() {
		
		// set MENU varible for echo on VIEW 
		$ctrapp_menu[] = $this->Menus->tabs( 'core_CAN_42', 'core_CAN_97', '' );
		// $ctrapp_menu[] = $this->Menus->tabs( 'core_CAN_86', 'core_CAN_87', $participant_id );
		$this->set( 'ctrapp_menu', $ctrapp_menu );
		
		// set FORM variable, for HELPER call on VIEW 
		$this->set( 'ctrapp_form', $this->Forms->getFormArray('announcements') );
		
		// set SUMMARY varible from plugin's COMPONENTS 
		$this->set( 'ctrapp_summary', $this->Summaries->build( $this->othAuth->user('id') ) );
		
		// set SIDEBAR variable, for HELPER call on VIEW 
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set( 'ctrapp_sidebar', $this->Sidebars->getColsArray( $this->params['plugin'].'_'.$this->params['controller'].'_index' ) );
		
			$criteria = array();
			$criteria[] = 'date_start<=NOW()';
			$criteria[] = 'date_end>=NOW()';
			$criteria[] = '(group_id="0" OR group_id="'.$this->othAuth->user('group_id').'")';
			$criteria = array_filter( $criteria );
			
		list( $order, $limit, $page ) = $this->Pagination->init( $criteria );
		$this->set( 'announcements', $this->Announcement->findAll( $criteria, NULL, $order, $limit, $page ) );
		
	}
	
	function detail( $announcement_id ) {
		
		// set MENU varible for echo on VIEW 
		$ctrapp_menu[] = $this->Menus->tabs( 'core_CAN_42', 'core_CAN_97', '' );
		// $ctrapp_menu[] = $this->Menus->tabs( 'core_CAN_86', 'core_CAN_87', $announcement_id );
		$this->set( 'ctrapp_menu', $ctrapp_menu );
		
		// set FORM variable, for HELPER call on VIEW 
		// $this->set( 'ctrapp_form', $this->Forms->getFormArray('participants') );
		$this->set( 'ctrapp_form', $this->Forms->getFormArray('announcements') );
		
		// set SUMMARY varible from plugin's COMPONENTS 
		$this->set( 'ctrapp_summary', $this->Summaries->build( $this->othAuth->user('id') ) );
		
		// set SIDEBAR variable, for HELPER call on VIEW 
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set( 'ctrapp_sidebar', $this->Sidebars->getColsArray( $this->params['plugin'].'_'.$this->params['controller'].'_index' ) );
		
		// set FORM variable, for HELPER call on VIEW 
		$this->set( 'announcement_id', $announcement_id );
		
		$this->Announcement->id = $announcement_id;
		$this->set( 'data', $this->Announcement->read() );

	}

}

?>