<?php

class MenusComponent extends Object {
	
	var $controller;
	
	var $components = array('Session', 'SessionAcl');
	var $uses = array('Aco');
	
	function initialize( &$controller, $settings=array() ) {
		$this->controller =& $controller;
	}
	
	function get( $alias=NULL, $replace=array() ) {
		
		$aro_alias = 'Group::'.$this->Session->read('Auth.User.group_id');
		
		$return = array();
		$alias_calculated = array();
		
		
		// if ALIAS not provided, try to guess what menu item CONTROLLER is looking for, defaulting to DETAIL/PROFILE if possible
		if ( !$alias ) {
			$alias					= '/'.( $this->controller->params['plugin'] ? $this->controller->params['plugin'].'/' : '' ).$this->controller->params['controller'].'/'.$this->controller->params['action'];
			
			$alias_with_params = $alias;
			foreach ( $this->controller->params['pass'] as $param ) {
				$alias_with_params .= '/'.$param;
				$alias_calculated[]	= $alias_with_params.'%';
			}
			$alias_calculated = array_reverse($alias_calculated);
			
			$alias_calculated[]	= '/'.( $this->controller->params['plugin'] ? $this->controller->params['plugin'].'/' : '' ).$this->controller->params['controller'].'/detail%';
			$alias_calculated[]	= '/'.( $this->controller->params['plugin'] ? $this->controller->params['plugin'].'/' : '' ).$this->controller->params['controller'].'/profile%';
			$alias_calculated[]	= '/'.( $this->controller->params['plugin'] ? $this->controller->params['plugin'].'/' : '' ).$this->controller->params['controller'].'/listall%';
			$alias_calculated[]	= '/'.( $this->controller->params['plugin'] ? $this->controller->params['plugin'].'/' : '' ).$this->controller->params['controller'].'/index%';
			$alias_calculated[]	= '/'.( $this->controller->params['plugin'] ? $this->controller->params['plugin'].'/' : '' ).$this->controller->params['controller'].'%';
			
		}
		
		
		$cache_name = str_replace("/", "_", $alias)."_".str_replace(":", "", $aro_alias);
		$return = Cache::read($cache_name, "menus");
		if($return === null){
			$return = false;
			if(Configure::read('debug') == 2){
				AppController::addWarningMsg('Menu caching issue. (null)');
			}
		}
		if(!$return){
			if ( $alias ) {
				App::import('model', 'Menu');
				$this->Component_Menu = new Menu;
				
				$result = $this->Component_Menu->find(
								'all', 
								array(
									'conditions'	=>	array(
										"Menu.use_link" => array($alias, $alias.'/'),
										"Menu.flag_active" => 1
									), 
									'recursive'		=>	3,
									'order'			=> 'Menu.parent_id DESC, Menu.display_order ASC',
										'limit'			=> 1
								)
				);
				
				if (!$result) {
					
					$result = $this->Component_Menu->find(
									'all', 
									array(
										'conditions'	=>	array(
											'Menu.use_link LIKE' => $alias.'%',
											'Menu.flag_active' => 1
										), 
										'recursive'		=>	3,
										'order'			=> 'Menu.parent_id DESC, Menu.display_order ASC',
										'limit'			=> 1
									)
					);
				}
				
				if (!$result) {
					
					$alias_count = 0;
					while ( !$result && $alias_count<count($alias_calculated) ) {
						$result = $this->Component_Menu->find(
									'all', 
									array(
										'conditions'	=>	array(
											"Menu.use_link LIKE " => $alias_calculated[$alias_count],
											"Menu.flag_active" => 1
										), 
										'recursive'		=>	3,
										'order'			=> 'Menu.parent_id DESC, Menu.display_order ASC',
										'limit'			=> 1
									)
						);
						
						$alias_count++;
					}
					
				}
				
				$menu = array();
				
				$parent_id = isset($result[0]['Menu']['parent_id']) ? $result[0]['Menu']['parent_id'] : false;
				$source_id = isset($result[0]['Menu']['id']) ? $result[0]['Menu']['id'] : false;
				
				while ( $parent_id!==false ) {
					
					$current_level = $this->Component_Menu->find('all', array('conditions' => array(
							"Menu.parent_id" => $parent_id,
							"Menu.flag_active" => 1
						),
						'order'=>'Menu.parent_id DESC, Menu.display_order ASC')
					);
					if ( $current_level && count($current_level) ) {
						
						foreach ( $current_level as &$current_item ) {
							$current_item['Menu']['at'] = $current_item['Menu']['id']==$source_id ? true : false;
							
							$parts = Router::parse($current_item['Menu']['use_link']);
							$aco_alias = 'controllers/'.($parts['plugin'] ? Inflector::camelize($parts['plugin']) : 'App').'/';
							$aco_alias .= ($parts['controller'] ? Inflector::camelize($parts['controller']).'/' : '');
							$aco_alias .= ($parts['action'] ? $parts['action'] : '');
							
							$current_item['Menu']['allowed'] = $this->SessionAcl->check($aro_alias, $aco_alias);
							
						}
						
						$menu[] = $current_level;
						
						$source_result = $this->Component_Menu->find('first', array('conditions' => array('Menu.id' => $parent_id)));
						
						$source_id = $source_result['Menu']['id'];
						$parent_id = $source_result['Menu']['parent_id'];
						
					}
					
					else {
						$parent_id = false;
					}
					
				}
				
				if ( $result ) $return = $menu;
				
			}
			
			if(Configure::read('debug') == 0){
				Cache::write($cache_name, $return, "menus");
			}
		}
		
		return $return;
		
	}
}

?>