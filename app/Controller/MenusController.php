<?php

class MenusController extends AppController {
	
	var $components = array('Session', 'SessionAcl');
	var $uses = array('Menu','Announcement');
	
	function beforeFilter() {
		parent::beforeFilter();
		
		// Don't restrict the index action so that users with NO permissions
		// who have VALID login credentials will not trigger an infinite loop.
		if($this->Auth->user()) {
			$this->Auth->allowedActions = array('index');
		}
	}
	
	function index($set_of_menus=NULL){
		if ( !$set_of_menus ) {
			$menu_data = $this->Menu->find('all',array('conditions'=> array(
					"Menu.parent_id" => "MAIN_MENU_1",
					"Menu.flag_active" => 1
				), 
				'order'=>'Menu.display_order ASC')
			);
			$this->set( 'atim_menu', $this->Menus->get('/menus') );
			
			$participant_message_model = AppModel::getInstance('ClinicalAnnotation', 'ParticipantMessage', true);
			$this->set('due_messages_count', $participant_message_model->find('count', array('conditions' => array('ParticipantMessage.done' => 0, 'ParticipantMessage.due_date <' => now()))));
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
			$this->set( 'atim_menu', $this->Menus->get('/menus/Datamart/'));
		}

		foreach($menu_data as &$current_item){
			$current_item['Menu']['at'] = false;
			$current_item['Menu']['allowed'] = AppController::checkLinkPermission($current_item['Menu']['use_link']);
		}
		
		$this->set( 'menu_data', $menu_data );
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
