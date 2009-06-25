<?php

class MenusController extends AppController {
	
	var $components = array('Acl', 'Session');
	
	function beforeFilter() {
		parent::beforeFilter();
	}
	
	function index() {
		
		$this->set( 'atim_menu', $this->Menus->get('/menus') );
		
		$aro_alias = 'Group::'.$this->Session->read('Auth.User.group_id');
		
		$menu_data = $this->Menu->find('all',array('conditions'=>'Menu.parent_id="0" AND (active="yes" OR active="y" OR active="1")', 'order'=>'Menu.display_order ASC'));
		
		foreach ( $menu_data as &$current_item ) {
			$current_item['Menu']['at'] = false;
			
			$parts = Router::parse($current_item['Menu']['use_link']);
			$aco_alias = 'controllers/'.($parts['plugin'] ? Inflector::camelize($parts['plugin']) : 'App').'/';
			$aco_alias .= ($parts['controller'] ? Inflector::camelize($parts['controller']).'/' : '');
			$aco_alias .= ($parts['action'] ? $parts['action'] : '');
			
			$current_item['Menu']['allowed'] = $this->Acl->check($aro_alias, $aco_alias);
			
		}
		
		$this->set( 'menu_data', $menu_data );
		
	}
	
	/*
	var $name = 'Menus';
	
	// main menu 
	function index() {
		
		// set SIDEBAR & ANNOUNCEMENTS variable, for HELPER call on VIEW 
		$this->set( 'ctrapp_sidebar', $this->Sidebars->getColsArray('core_menu_main') );
		$this->set( 'ctrapp_announcements', $this->Sidebars->getAnnouncementsArray() );
		
		
		// set display vars 
		$display_menu = array();
		
		// get PARENT links 
		foreach ( $this->Menu->findAll( 'parent_id="0" AND (active="yes" OR active="y" OR active="1")', NULL, 'display_order ASC', NULL ) as $tab_key=>$tab_value ) {
			
			$display_menu[ $tab_key ][ 'id' ] = '0';
			$display_menu[ $tab_key ][ 'at' ] = false;
			$display_menu[ $tab_key ][ 'text' ] = $tab_value['Menu']['language_title'];
			$display_menu[ $tab_key ][ 'link' ] = $tab_value['Menu']['use_link'];
			$display_menu[ $tab_key ][ 'allowed' ] = $this->othAuth->checkMenuPermission( $display_menu[ $tab_key ][ 'link' ] ) ? true : false;
			
		}
		
		// set vars for VIEWS 
		$this->set( 'display_menu', $display_menu );
		
	}
	
	// main menu 
	function tools() {
		
		// set SIDEBAR variable, for HELPER call on VIEW 
		$this->set( 'ctrapp_sidebar', $this->Sidebars->getColsArray('core_menu_tools') );
		
		// set display vars 
		$display_menu = array();
		
		// get PARENT links 
		foreach ( $this->Menu->findAll( 'parent_id="core_CAN_33" AND (active="yes" OR active="y" OR active="1")', NULL, 'display_order ASC', NULL ) as $tab_key=>$tab_value ) {
			
			$display_menu[ $tab_key ][ 'id' ] = 'core_CAN_33';
			$display_menu[ $tab_key ][ 'at' ] = false;
			$display_menu[ $tab_key ][ 'text' ] = $tab_value['Menu']['language_title'];
			$display_menu[ $tab_key ][ 'link' ] = $tab_value['Menu']['use_link'];
			$display_menu[ $tab_key ][ 'allowed' ] = $this->othAuth->checkMenuPermission( $display_menu[ $tab_key ][ 'link' ] ) ? true : false;
			
		}
		
		// set vars for VIEWS 
		$this->set( 'display_menu', $display_menu );
		
	}
	*/
	
}

?>
