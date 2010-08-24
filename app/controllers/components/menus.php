<?php

class MenusComponent extends Object {
	
	var $controller;
	static $menu_cache_directory = "../tmp/cache/menus/";
	
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
				$alias_calculated[]	= 'Menu.use_link LIKE "'.$alias_with_params.'%"';
			}
			$alias_calculated = array_reverse($alias_calculated);
			
			$alias_calculated[]	= 'Menu.use_link LIKE "/'.( $this->controller->params['plugin'] ? $this->controller->params['plugin'].'/' : '' ).$this->controller->params['controller'].'/detail%"';
			$alias_calculated[]	= 'Menu.use_link LIKE "/'.( $this->controller->params['plugin'] ? $this->controller->params['plugin'].'/' : '' ).$this->controller->params['controller'].'/profile%"';
			$alias_calculated[]	= 'Menu.use_link LIKE "/'.( $this->controller->params['plugin'] ? $this->controller->params['plugin'].'/' : '' ).$this->controller->params['controller'].'/listall%"';
			$alias_calculated[]	= 'Menu.use_link LIKE "/'.( $this->controller->params['plugin'] ? $this->controller->params['plugin'].'/' : '' ).$this->controller->params['controller'].'/index%"';
			$alias_calculated[]	= 'Menu.use_link LIKE "/'.( $this->controller->params['plugin'] ? $this->controller->params['plugin'].'/' : '' ).$this->controller->params['controller'].'%"';
			
		}
		
		
		$fname = MenusComponent::$menu_cache_directory.str_replace("/", "_", $alias)."_".str_replace(":", "", $aro_alias).".cache";
		
		if(file_exists($fname) && !(Configure::read('ATiMMenuCache.disable')) ){
			
			$fhandle = fopen($fname, 'r');
			$return = unserialize(fread($fhandle, filesize($fname)));
			fclose($fhandle);
		}
		
		else{
			
			if( Configure::read('ATiMMenuCache.disable') ){
				MenusComponent::clearCache();
			}
			
			if ( $alias ) {
				App::import('model', 'Menu');
				$this->Component_Menu = new Menu;
				
				$result = $this->Component_Menu->find(
								'all', 
								array(
									'conditions'	=>	'(Menu.use_link="'.$alias.'" OR Menu.use_link="'.$alias.'/") AND Menu.flag_active="1"', 
									'recursive'		=>	3,
									'order'			=> 'Menu.parent_id DESC, Menu.display_order ASC',
										'limit'			=> 1
								)
				);
				
				if (!$result) {
					
					$result = $this->Component_Menu->find(
									'all', 
									array(
										'conditions'	=>	'(Menu.use_link LIKE "'.$alias.'%") AND Menu.flag_active="1"', 
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
										'conditions'	=>	'('.$alias_calculated[$alias_count].') AND Menu.flag_active="1"', 
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
					
					$current_level = $this->Component_Menu->find('all', array('conditions' => '(Menu.parent_id = "'.$parent_id.'") AND Menu.flag_active="1"', 'order'=>'Menu.parent_id DESC, Menu.display_order ASC'));
					
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
			
			if( !(Configure::read('ATiMMenuCache.disable')) ){
				$fhandle = fopen($fname, 'w');
				fwrite($fhandle, serialize($return));
				flush();
				fclose($fhandle);
			}
			
		}
		
		return $return;
		
	}

	static function clearCache(){
		//clear menu cache
		try{
			if ($dh = opendir(MenusComponent::$menu_cache_directory)) {
				while (($file = readdir($dh)) !== false) {
					if(filetype(MenusComponent::$menu_cache_directory . $file) == "file"){
						unlink(MenusComponent::$menu_cache_directory . $file);
					}
				}
				closedir($dh);
			}
		}catch(Exception $e){
			//do nothing, it's a race condition with someone else
		}
	}
}

?>