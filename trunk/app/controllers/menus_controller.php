<?php

class MenusController extends AppController {
	
	var $components = array('Acl', 'Session');
	var $uses = array('Menu','Announcement');
	
	function beforeFilter() {
		parent::beforeFilter();
	}
	
	function index( $set_of_menus=NULL ) {
		
		// TOOLS menu
		if ( $set_of_menus=='tools' ) {
			$this->set( 'atim_menu', $this->Menus->get('/menus/tools') );
			$menu_data = $this->Menu->find('all',array('conditions'=>'Menu.parent_id="core_CAN_33" AND (active="yes" OR active="y" OR active="1")', 'order'=>'Menu.display_order ASC'));
		} 
		
		// MAIN menu
		else {
			$this->set( 'atim_menu', $this->Menus->get('/menus') );
			$menu_data = $this->Menu->find('all',array('conditions'=>'Menu.parent_id="MAIN_MENU_1" AND (active="yes" OR active="y" OR active="1")', 'order'=>'Menu.display_order ASC'));
			
			// get ANNOUNCEMENTS for main menu
			
			$findAll_conditions[] = 'date_start<=NOW()';
			$findAll_conditions[] = 'date_end>=NOW()';
			$findAll_conditions[] = '(group_id="0" OR group_id="'.$_SESSION['Auth']['User']['group_id'].'")';
		
			$this->set( 'announcements_data', $this->Announcement->find( 'all', array( 'conditions'=>$findAll_conditions, 'order'=>'date DESC') ) );
		}
		
		foreach ( $menu_data as &$current_item ) {
			$current_item['Menu']['at'] = false;
			
			if ( Configure::read("debug") ) {
				$current_item['Menu']['allowed'] = true;
			} else {
				$aro_alias = 'Group::'.$this->Session->read('Auth.User.group_id');
				
				$parts = Router::parse($current_item['Menu']['use_link']);
				$aco_alias = 'controllers/'.($parts['plugin'] ? Inflector::camelize($parts['plugin']) : 'App').'/';
				$aco_alias .= ($parts['controller'] ? Inflector::camelize($parts['controller']).'/' : '');
				$aco_alias .= ($parts['action'] ? $parts['action'] : '');
				
				$current_item['Menu']['allowed'] = $this->Acl->check($aro_alias, $aco_alias);
			}
			
		}
		
		$this->set( 'menu_data', $menu_data );
		
		if ( $set_of_menus ) $this->render($set_of_menus);
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
