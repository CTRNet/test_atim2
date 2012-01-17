<?php

class ShellHelper extends Helper {
	
	var $helpers = array('Html', 'Session', 'Structures', 'Form');
	
	function header($options=array()){
		$return = '';
		// get/set menu for menu BAR
		$menu_array					= $this->menu( $options['atim_menu'], array('variables'=>$options['atim_menu_variables']) );
		$menu_for_wrapper			= $menu_array[0];
		
		// get/set menu for header
		$main_menu = array();
		$menu_array					= $this->menu( $options['atim_menu_for_header'], array('variables'=>$options['atim_menu_variables']) );
		$user_for_header			= '';
		$root_menu_for_header		= '';
		if(isset($_SESSION) && isset($_SESSION['Auth']) && isset($_SESSION['Auth']['User']) && count($_SESSION['Auth']['User'])){
			$logged_in = true;
			// set HEADER root menu links
				
			$root_menu_for_header .= '<ul class="root_menu_for_header">';
			$online_wiki_str = __('online wiki', true);
			$root_menu_for_header .= '
				<li>
					'.$this->Html->link( "", "http://ctrnet.ca/mediawiki/index.php/", array("target" => "blank", "class" => "menu help icon32", "title" => $online_wiki_str) ).'
				</li>';
			
			foreach( $menu_array[1] as $key => $menu_item){
				$html_attributes = array();
				$html_attributes['class'] = 'menu icon32 '.$this->Structures->generateLinkClass( 'plugin '.$menu_item['Menu']['use_link'] );
				$html_attributes['title'] = __($menu_item['Menu']['language_title'], true);
						
				if($menu_item['Menu']['allowed']){
					$root_menu_for_header .= '
							<!-- '.$menu_item['Menu']['id'].' -->
							<li class="'.( $menu_item['Menu']['at'] ? 'at ' : '' ).'">
								'.$this->Html->link( "", $menu_item['Menu']['use_link'], $html_attributes ).'
							</li>
					';
				}else{
					$root_menu_for_header .= '
							<!-- '.$menu_item['Menu']['id'].' -->
							<li class="not_allowed">
								<a class="menu plugin not_allowed" title="'.__($menu_item['Menu']['language_title'], true).'"></a>
							</li>
					';
					
				}
			}
			$root_menu_for_header .= '</ul>';
				
			// set HEADER main menu links
			$root_menu_for_header .= '<ul class="main_menu_for_header">';
			
			foreach($menu_array[2] as $key => $menu_item){
				$html_attributes = array();
				$html_attributes['class'] = 'menu icon32 '.$this->Structures->generateLinkClass( 'plugin '.$menu_item['Menu']['use_link'] );
				$html_attributes['title'] = __($menu_item['Menu']['language_title'], true);
				
				if($menu_item['Menu']['allowed']){
					$root_menu_for_header .= '
							<!-- '.$menu_item['Menu']['id'].' -->
							<li class="'.$menu_item['Menu']['id'].'">
								'.$this->Html->link( "", $menu_item['Menu']['use_link'], $html_attributes );
					if(array_key_exists($menu_item['Menu']['id'], $options['atim_sub_menu_for_header'])){
						//sub items (level 3)
						$sub_menu = '';
						foreach($options['atim_sub_menu_for_header'][$menu_item['Menu']['id']] as $sub_menu_item){
							if($sub_menu_item['Menu']['flag_active']){
								$html_attributes = array();
								$html_attributes['class'] = 'icon32 '.$this->Structures->generateLinkClass( 'plugin '.$sub_menu_item['Menu']['use_link'] );
								$html_attributes['title'] = __($sub_menu_item['Menu']['language_title'], true);
								if(AppController::checkLinkPermission($sub_menu_item['Menu']['use_link'])){
									$sub_menu .= '<li class="sub_menu">'.$this->Html->link( "", $sub_menu_item['Menu']['use_link'], $html_attributes )."</li>";
								}
							}
						}
						if(!empty($sub_menu)){
							$root_menu_for_header .= '<ul class="sub_menu_for_header '.$menu_item['Menu']['id'].'">'.$sub_menu.'</ul>';
						}
					}
					
					$root_menu_for_header .= '		
						</li>
					';
	
				}else{
					$root_menu_for_header .= '
							<!-- '.$menu_item['Menu']['id'].' -->
							<li>
								<a class="icon32 not_allowed" title="'.__($menu_item['Menu']['language_title'], true).'"></a>
							</li>
					';
				}
			}
			$root_menu_for_header .= '</ul>';
		}else{
			$logged_in = false;
		}
		$return .= "<fieldset class='mainFieldset'>";//the fieldset is present to manage the display for wide forms such as addgrids		
		$return .= '
			<!-- start #header -->
			<div id="header"><div>
				<h1>'.__('core_appname', true).'</h1>
				<h2>'.__('core_installname', true).'</h2>
				'.$root_menu_for_header.'
			</div></div>
			<!-- end #header -->
			
		';	
		if($logged_in){	
			// display DEFAULT menu
			$return .= '
				<!-- start #menu -->
				<div id="menu">
					'.$menu_for_wrapper.'
				</div>
				<!-- end #menu -->
			';
		}else{
			// display hardcoded LOGIN menu
			$return .= '
				<!-- start #menu -->
				<div id="menu">
						
					<div class="menu level_0">
						<ul class="total_count_1">
							<li class="at count_0 root">'
								.$this->Html->link( '<span class="icon32 rm5px login"></span>'.__('Login', true), '/', array('title' => __('Login', true), 'escape' => false, 'class' => 'MainTitle')).
							'</li>
						</ul>
					</div>
					
				</div>
				<!-- end #menu -->
			';
		}
		
		// display any VALIDATION ERRORS
		
		$return .= '<div class="validationWrapper">'.$this->validationHtml().'</div>	
			<!-- start #wrapper -->
			<div class="outerWrapper">
				<div id="wrapper" class="wrapper plugin_'.( isset($this->params['plugin']) ? $this->params['plugin'] : 'none' ).' controller_'.$this->params['controller'].' action_'.$this->params['action'].'">
		';
		
		return $return;
		
	}
	
	function validationHtml(){
		$display_errors_html = $this->validationErrors();
		
		$confirm_msg_html = "";
		if(isset($_SESSION['ctrapp_core']['confirm_msg'])){
			$confirm_msg_html = '<ul class="confirm"><li><span class="icon16 confirm mr5px"></span>'.$_SESSION['ctrapp_core']['confirm_msg'].'</li></ul>';
			unset($_SESSION['ctrapp_core']['confirm_msg']);
		}
		
		foreach(array('confirm', 'warning', 'info') as $type){
			if(isset($_SESSION['ctrapp_core'][$type.'_msg']) && count($_SESSION['ctrapp_core'][$type.'_msg']) > 0){
				$confirm_msg_html .= '<ul class="'.$type.'">';
				foreach($_SESSION['ctrapp_core'][$type.'_msg'] as $msg => $count){
					if($count > 1){
						$msg .= " (".$count.")";
					}
					$confirm_msg_html .= "<li><span class='icon16 ".$type." mr5px'></span>".$msg."</li>";
				}
				$confirm_msg_html .= '</ul>';
				$_SESSION['ctrapp_core'][$type.'_msg'] = array();
			}
		}
		
		$return = "";
		if($display_errors_html != null || strlen($confirm_msg_html) > 0){
			$return .= '
				<!-- start #validation -->
				<div class="validation">
					'.$display_errors_html.$confirm_msg_html.'
				</div>
				<!-- end #validation -->
				';
		}
		
		return $return;
	}
	
	function validationErrors(){
		$result = "";

		$display_errors = array();
		foreach ($this->_View->validationErrors as $model ) {
			foreach ( $model as $field ) {
				if(is_array($field)){
					foreach($field as $field_unit){
						$display_errors[] = '
							<li><span class="icon16 delete mr5px"></span>'.__($field_unit, true).'</li>
						';
					}
				}else{
					$display_errors[] = '
						<li>'.__($field, true).'</li>
					';
				}
			}
		}
		if($display_errors){
			$result =
					'<ul class="error">
						'.implode('',array_unique($display_errors)).'
					</ul>';
		}
		return $result;
	}
	
	function footer( $options=array() ) {
		
		$return = '';
		
		$return .= '
		   		</div>
		   </div>
		   
			<!-- end #wrapper -->
			
			<!-- start #footer -->
			<div id="footer">
						'.$this->Html->link( __('core_footer_about', true), '/Pages/about/' ).' | '
						.$this->Html->link( __('core_footer_installation', true), '/Pages/installation/' ).' | ' 
						.$this->Html->link( __('core_footer_credits', true), '/Pages/credits/' ).'<br/>
						'.__('core_copyright', true).' &copy; '.date('Y').' '.$this->Html->link( __('core_ctrnet', true), 'https://www.ctrnet.ca/' ).'<br/>
						'.__('core_app_version', true).'
			</div>
			<!-- end #footer -->
			</fieldset>
		';
		
		return $return;
	} 
	
	function menu($atim_menu = array(), $options = array()){
		$page_title = array();
		if(!isset($this->pageTitle)){
			$this->pageTitle = '';
		}
						
		$return_html = array();
		$root_menu_array = array();
		$main_menu_array = array();
		
		if(count($atim_menu)){
			
			$summaries = array();
			if(!isset($options['variables'])){
				$options['variables'] = array();
			}
			
			if(isset($_SESSION) && isset($_SESSION['Auth']) && isset($_SESSION['Auth']['User']) && count($_SESSION['Auth']['User'])){
					
				$count = 0;
				$total_count = 0;
				$is_root = false; // used to remove unneeded ROOT menu items from displaying in bar
				
				foreach($atim_menu as $menu){
					
					$active_item = '';
					$summary_item = '';
					$append_menu = '';
					
					// save BASE array (main menu) for display in header
					if($count == (count($atim_menu)-1)){
						$root_menu_array = $menu;
					}else if($count == (count($atim_menu) - 2)){
						$main_menu_array = $menu;
					}
					
					if(!$is_root){
							
						$sub_count = 0;
						foreach($menu as $menu_item){
							
							if($menu_item['Menu']['use_link'] && count($options['variables'])){
								foreach($options['variables'] as $k => $v){
									$menu_item['Menu']['use_link'] = str_replace('%%'.$k.'%%',$v,$menu_item['Menu']['use_link']);
								}
							}
							
							if($menu_item['Menu']['at'] && $menu_item['Menu']['use_summary']){
								$fetched_summary = $this->fetchSummary($menu_item['Menu']['use_summary'], $options);
								$summaries[] = $fetched_summary['long'];
								$menu_item['Menu']['use_summary'] = isset($fetched_summary['page_title']) ? $fetched_summary['page_title'] : "";
							}
							
							if($menu_item['Menu']['at']){
								$is_root = $menu_item['Menu']['is_root'];
								
								$summary_item = $menu_item['Menu']['use_summary'] ? NULL : array('class'=>'without_summary');
								
								if($menu_item['Menu']['use_summary']){
									$word = __(trim($menu_item['Menu']['language_title']), true);
									$untranslated = strpos($word, "<span class='untranslated'>") === 0;
									if($untranslated){
										$word = substr(trim($word), 27, -7);			
									}
									$max_length = 30;
									if(strlen($word) > $max_length){
										$word = '<span class="incompleteMenuTitle" title="'.htmlentities($word, ENT_QUOTES).'">'.substr($word, 0, -1 * (strlen($word) - $max_length))."...".'</span>';
									}
									$word = $untranslated ? '<span class="untranslated">'.$word.'</span>' : $word;
								
									$active_item = '
										<span class="mainTitle">'.$menu_item['Menu']['use_summary'].'</span>
										<br />&nbsp;&lfloor; <span class="menuSubTitle">'.$word.'</span>
									';
									
									$page_title[] = $menu_item['Menu']['use_summary'];
								}else{
									
									if($is_root){
										$title = html_entity_decode(__($menu_item['Menu']['language_title'], true), ENT_QUOTES, "UTF-8");
										
										// $active_item = $menu_item['Menu']['allowed'] ? $this->Html->link( __($menu_item['Menu']['language_title'], true), $menu_item['Menu']['use_link'], $html_attributes ) : __($menu_item['Menu']['language_title'], true);
										
										if(!$menu_item['Menu']['allowed']){
											$active_item = '<a class="icon32 mr5px not_allowed" title="'.__($menu_item['Menu']['language_title'], true).'">'.__($menu_item['Menu']['language_title'], true).'</a>';
										}else {
											//$html_attributes
											$class = ' menu '.$this->Structures->generateLinkClass( 'plugin '.$menu_item['Menu']['use_link'] );
											$active_item = $this->Html->link( html_entity_decode( '<span class="icon32 mr5px '.$class.'"></span>'.__($menu_item['Menu']['language_title'], true), ENT_QUOTES, "UTF-8"), $menu_item['Menu']['use_link'],  array('escape' => false, 'title' => $title, 'class' => 'mainTitle'));
										}
									}else{
										$active_item = '<span class="mainTitle">'.__($menu_item['Menu']['language_title'], true).'</span>';
									}
									
									$page_title[] = __($menu_item['Menu']['language_title'], true);
								}
								
							}
							
							$title = html_entity_decode(__($menu_item['Menu']['language_title'], true), ENT_QUOTES, "UTF-8");
							if($menu_item['Menu']['allowed']){
								$append_menu .= '
										<!-- '.$menu_item['Menu']['id'].' -->
										<li class="'.( $menu_item['Menu']['at'] ? 'at ' : '' ).'count_'.$sub_count.'">
											'.$this->Html->link( '<span class="icon16 list"></span><span class="menuLabel">'.$title.'</span>', $menu_item['Menu']['use_link'], array('escape' => false, 'title' => $title) ).'
										</li>
								';
							}else{
								$append_menu .= '
										<!-- '.$menu_item['Menu']['id'].' -->
										<li class="not_allowed count_'.$sub_count.'">
											<a title="'.$title.'"><span class="icon16 not_allowed"></span><span class="menuLabel">'.$title.'</span></a>
										</li>
														';
							}
							$sub_count++;
						}
						
						// append FLYOUT menus to all menu bar TABS except ROOT tab
						if(!$is_root){
							$append_menu = '
									<div class="menu level_1">
										<ul>
											'.$append_menu.'
										</ul>
									</div>
							';
						}else{
							$append_menu = '';
						}
						
						$return_html[] = '
							<li class="at count_'.$count.( $is_root ? ' root' : '' ).'">
								'.$active_item.'
								'.$append_menu.'
							</li>
						';
						
						// increment number of VISIBLE menu bar tabs
						$total_count++;
					}
					
					// increment number to TOTAL menu array items
					$count++;
				}
			}
				
			// if summary info has been provided AND config variable allows it, provide expandable tab
				
			$return_summary = '';
			$summaries = array_filter($summaries);
			
			if(show_summary && count($summaries)){
				$return_summary .= '
					<ul id="summary">
						<li>
							<span class="summaryBtn">'.__('summary', null).'</span>
							
							<ul>
				';

				$summary_count = 0;
				foreach($summaries as $summary){
					$return_summary .= '
								<li class="count_'.$summary_count.'">
									'.$summary.'
								</li>
					';
					
					$summary_count++;
				}
				
				$return_summary .= '
							</ul>
							
						</li>
					</ul>
				';
			}
		}
		
		if($return_html){
			$return_html = '
				<div class="menu level_0">
					<ul class="total_count_'.$total_count.'">
						'.implode('',array_reverse($return_html)).'
					</ul>
					
					'.$return_summary.'
				</div>
			';
		}
		
		// reverse-sort the Page Title array, and set pageTitle
		if(strlen($this->pageTitle) == 0){
			$this->pageTitle = implode(' &laquo; ',$page_title);
		}
		
		$return_array = array($return_html, $root_menu_array, $main_menu_array);
		return $return_array;
	}
	
	/**
	 * Builds 2 summaries, one for the menu tabs (short) and one for the summary button (long)
	 * @param unknown_type $summary
	 * @param unknown_type $options
	 * @return array('short' => short summary, 'long' => long summary)
	 */
	function fetchSummary($summary, $options) {
		$result = array("short" => null, "long" => null);
		if($summary){
			// get StructureField model, to swap out permissible values if needed
			App::uses('StructureField', 'Model');
			$structure_fields_model = new StructureField;
			
			list($model,$function) = split('::',$summary);
			
			if(!$function){
				$function = 'summary';
			}
			
			if($model){
				// if model name is PLUGIN.MODEL string, need to split and drop PLUGIN name after import but before NEW
				$plugin = NULL;
				if (strpos($model, '.') !== false){
					$plugin_model_name = $model;
					list($plugin,$model) = explode('.',$plugin_model_name);
				}
				
				// load MODEL, and override with CUSTOM model if it exists...
				$summary_model = AppModel::getInstance($plugin, $model, true);
				$summary_result = $summary_model->{$function}($options['variables']);

				if($summary_result){
					//short--- 
					if(isset($summary_result['menu']) && is_array($summary_result['menu'])){
						$parts = array(trim($summary_result['menu'][0])." ", isset($summary_result['menu'][1]) ? trim($summary_result['menu'][1]) : '');
						$total_length = 0;
						$result_str = "";
						$max_length = 22;
						foreach($parts as $part){
							$untranslated = strpos($part, "<span class='untranslated'>") === 0;
							if($untranslated){
								$part = substr(trim($part), 27, -7);			
							}
							$total_length += strlen($part);
							if($total_length > $max_length){
								$part = substr($part, 0, -1 * ($total_length - $max_length))."...";
							}
							$result_str .= $untranslated ? '<span class="untranslated">'.$part.'</span>' : $part;
							if($total_length > $max_length){
								$result['page_title'] = $result_str;
								$result_str = '<span class="incompleteMenuTitle" title="'.htmlentities(implode("", $parts), ENT_QUOTES).'">'.$result_str.'</span>';
								break;
							}
						}
						$result['short'] = $result_str;
						if(!isset($result['page_title'])){
							$result['page_title'] = $result_str;
						}
					}else{
						$result['short'] = false;
					}
					//--------
					
					//long---
					$summary_long = "";
					if(isset($summary_result['title']) && is_array($summary_result['title']) ) {
						$summary_long = '
							'.__($summary_result['title'][0], true).'
							<span class="list_header">'.$summary_result['title'][1].'</span>
						';
					}

					if(isset($summary_result['data']) && isset($summary_result['structure alias'])){
						$structure = StructuresComponent::$singleton->get('form', $summary_result['structure alias']);
						$summary_long .= $this->Structures->build($structure, array('type' => 'summary', 'data' => $summary_result['data'], 'settings' => array('return' => true, 'actions' => false)));
					}else if(isset($summary_result['description']) && is_array($summary_result['description'])){
						if(Configure::read('debug') > 0){
							AppController::addWarningMsg(__("the sumarty for model [%s] function [%s] is using the depreacted description way instead of a structure", $model, $function));
						}
						$summary_long .= '
							<dl>
						';
						foreach($summary_result['description'] as $k => $v){
							
							// if provided VALUE is an array, it should be a select-option that needs to be looked up and translated...
							if(is_array($v)){
								$v = $structure_fields_model->findPermissibleValue($plugin,$model,$v);
							}
							
							$summary_long .= '
									<dt>'.__($k,true).'</dt>
									<dd>'.( $v ? $v : '-' ).'</dd>
							';
						}
						$summary_long .= '
							</dl>
						';
					}
					$result['long'] = strlen($summary_long) > 0 ? $summary_long : false;
					//-------
				}
			}
		}
		return $result;
	}
	
}
	
?>