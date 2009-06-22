<?php

class MenusComponent extends Object {
	
	var $controller;
	
	var $components = array('Acl', 'Session');
	var $uses = array('Aco');
	
	function initialize( &$controller, $settings=array() ) {
		$this->controller =& $controller;
	}
	
	function get( $alias=NULL, $replace=array() ) {
		
		$aro_alias = 'Group::'.$this->Session->read('Auth.User.group_id');
		
		$return = array();
		$alias_calculated = array();
		
		if ( $alias ) {
			$alias = strtolower($alias);
		} 
		
		// if ALIAS not provided, try to guess what menu item CONTROLLER is looking for, defaulting to DETAIL/PROFILE if possible
		else {
			$alias					= '/'.( $this->controller->params['plugin'] ? $this->controller->params['plugin'].'/' : '' ).$this->controller->params['controller'].'/'.$this->controller->params['action'];
			
			$alias_calculated[]	= 'Menu.use_link LIKE "/'.( $this->controller->params['plugin'] ? $this->controller->params['plugin'].'/' : '' ).$this->controller->params['controller'].'/detail%"';
			$alias_calculated[]	= 'Menu.use_link LIKE "/'.( $this->controller->params['plugin'] ? $this->controller->params['plugin'].'/' : '' ).$this->controller->params['controller'].'/profile%"';
			$alias_calculated[]	= 'Menu.use_link LIKE "/'.( $this->controller->params['plugin'] ? $this->controller->params['plugin'].'/' : '' ).$this->controller->params['controller'].'/listall%"';
			$alias_calculated[]	= 'Menu.use_link LIKE "/'.( $this->controller->params['plugin'] ? $this->controller->params['plugin'].'/' : '' ).$this->controller->params['controller'].'/index%"';
			$alias_calculated[]	= 'Menu.use_link LIKE "/'.( $this->controller->params['plugin'] ? $this->controller->params['plugin'].'/' : '' ).$this->controller->params['controller'].'%"';
		}
		
		if ( $alias ) {
			
			App::import('model', 'Menu');
			$this->Component_Menu =& new Menu;
			
			$result = $this->Component_Menu->find(
							'first', 
							array(
								'conditions'	=>	'Menu.use_link = "'.$alias.'"', 
								'recursive'		=>	3,
								'order'			=> 'Menu.parent_id DESC, Menu.display_order ASC'
							)
			);
			
			if (!$result) {
				$result = $this->Component_Menu->find(
								'first', 
								array(
									'conditions'	=>	'Menu.use_link LIKE "'.$alias.'%"', 
									'recursive'		=>	3,
									'order'			=> 'Menu.parent_id DESC, Menu.display_order ASC'
								)
				);
			}
			
			if (!$result) {
				
				$alias_count = 0;
				while ( !$result && $alias_count<count($alias_calculated) ) {
					$result = $this->Component_Menu->find(
								'first', 
								array(
									'conditions'	=>	$alias_calculated[$alias_count], 
									'recursive'		=>	3,
									'order'			=> 'Menu.parent_id DESC, Menu.display_order ASC'
								)
					);
					
					$alias_count++;
				}
				
			}
			
			$menu = array();
			
			$parent_id = $result['Menu']['parent_id'];
			$source_id = $result['Menu']['id'];
			
			while ( $parent_id!==false ) {
				
				$current_level = $this->Component_Menu->find('all', array('conditions' => 'Menu.parent_id = "'.$parent_id.'"'));
				
				if ( $current_level && count($current_level) ) {
					
					foreach ( $current_level as &$current_item ) {
						$current_item['Menu']['at'] = $current_item['Menu']['id']==$source_id ? true : false;
						
						$parts = Router::parse($current_item['Menu']['use_link']);
						$aco_alias = 'controllers/'.($parts['plugin'] ? Inflector::camelize($parts['plugin']) : 'App').'/';
						$aco_alias .= ($parts['controller'] ? Inflector::camelize($parts['controller']).'/' : '');
						$aco_alias .= ($parts['action'] ? $parts['action'] : '');
						
						$current_item['Menu']['allowed'] = $this->Acl->check($aro_alias, $aco_alias);
						
					}
					
					$menu[] = $current_level;
					
					$source_result = $this->Component_Menu->find('first', array('conditions' => 'Menu.id = "'.$parent_id.'"'));
					
					$source_id = $source_result['Menu']['id'];
					$parent_id = $source_result['Menu']['parent_id'];
					
				}
				
				else {
					$parent_id = false;
				}
				
			}
			
			if ( $result ) $return = $menu;
		}
		
		return $return;
		
	}

}

?>