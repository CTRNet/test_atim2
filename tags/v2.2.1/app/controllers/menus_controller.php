<?php

class MenusController extends AppController {
	
	var $components = array('Session', 'SessionAcl');
	var $uses = array('Menu','Announcement');
	
	function beforeFilter() {
		parent::beforeFilter();
		
		// Don't restrict the index action so that users with NO permissions
		// who have VALID login credentials will not trigger an infinite loop.
		if(isset($_SESSION) && isset($_SESSION['Auth']) && isset($_SESSION['Auth']['User']) && count($_SESSION['Auth']['User'])) {
			$this->Auth->allowedActions = array('index');
		}
	}
	
	function index($set_of_menus=NULL){
		// get ANNOUNCEMENTS for main menu
		if ( !$set_of_menus ) {
			$this->set( 'announcements_data', $this->Announcement->find( 'all', array('conditions'=> array(
					'date_start <=' => now(),
					'date_end >=' => now(),
					'group_id' => array(0, $_SESSION['Auth']['User']['group_id'])
				),
				'order'=>'date DESC'))
			);
		
			$menu_data = $this->Menu->find('all',array('conditions'=> array(
					"Menu.parent_id" => "MAIN_MENU_1",
					"Menu.flag_active" => 1
				), 
				'order'=>'Menu.display_order ASC')
			);
			
			$this->set( 'atim_menu', $this->Menus->get('/menus') );
		}else if($set_of_menus == "tools"){
			$this->set( 'atim_menu', $this->Menus->get('/menus/tools') );
						$menu_data = $this->Menu->find('all',array('conditions'=> array(
					"Menu.parent_id" => "core_CAN_33",
					"Menu.flag_active" => 1
				), 
				'order'=>'Menu.display_order ASC')
			);
		}else if($set_of_menus == "datamart"){
			$menu_data = $this->Menu->find('all',array('conditions'=> array(
					"Menu.parent_id" => "qry-CAN-1",
					"Menu.flag_active" => 1
				), 
				'order'=>'Menu.display_order ASC')
			);
			$this->set( 'atim_menu', $this->Menus->get('/menus/datamart/'));
		}
		
		foreach($menu_data as &$current_item){
			$current_item['Menu']['at'] = false;
			
			$aro_alias = 'Group::'.$this->Session->read('Auth.User.group_id');
			
			$parts = Router::parse($current_item['Menu']['use_link']);
			$aco_alias = 'controllers/'.($parts['plugin'] ? Inflector::camelize($parts['plugin']) : 'App').'/';
			$aco_alias .= ($parts['controller'] ? Inflector::camelize($parts['controller']).'/' : '');
			$aco_alias .= ($parts['action'] ? $parts['action'] : '');
			
			$current_item['Menu']['allowed'] = $this->SessionAcl->check($aro_alias, $aco_alias);
		}
		
		$this->set( 'menu_data', $menu_data );
		
		if ($set_of_menus ){
			$this->render($set_of_menus);
		}
	}
	
	function update() {
		$passed_in_variables = $_GET;
		
		// set MENU array, based on passed in ALIAS
		
			$ajax_menu = $this->Menus->get($passed_in_variables['alias']);
			$this->set( 'ajax_menu', $ajax_menu );
		
		// set MENU VARIABLES
			
			// unset GET vars not needed for MENU
			unset($passed_in_variables['alias']);
			unset($passed_in_variables['url']);
			
			$ajax_menu_variables = array();
			foreach ($passed_in_variables as $key=>$val) {
				
				// make corrections to var NAMES, due to frustrating cake/ajax functions
				$key = str_replace('amp;','',$key);
				$key = str_replace('_','.',$key);
				
				$ajax_menu_variables[$key] = $val;
			}
			
			$this->set( 'ajax_menu_variables', $ajax_menu_variables );
	}
	
}

?>