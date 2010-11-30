<?php

class ShellHelper extends Helper {
	
	var $helpers = array('Html', 'Session', 'Structures');
	
	function header($options=array()){
		$return = '';
		
		// get/set menu for menu BAR
		$menu_array					= $this->menu( $options['atim_menu'], array('variables'=>$options['atim_menu_variables']) );
		$menu_for_wrapper			= $menu_array[0];
		
		// get/set menu for header
		
		$menu_array					= $this->menu( $options['atim_menu_for_header'], array('variables'=>$options['atim_menu_variables']) );
		
		$user_for_header			= '';
		$root_menu_for_header		= '';
		$main_menu_for_header		= '';
		
		if(isset($_SESSION) && isset($_SESSION['Auth']) && isset($_SESSION['Auth']['User']) && count($_SESSION['Auth']['User'])){
			$logged_in = true;
			
			// set HEADER root menu links
			if(isset($menu_array[1]) && count($menu_array[1])){
				
				$root_menu_for_header .= '<ul id="root_menu_for_header" class="header_menu">';
				
				foreach( $menu_array[1] as $key => $menu_item){
					
					$html_attributes = array();
					$html_attributes['class'] = 'menu '.$this->Structures->generateLinkClass( 'plugin '.$menu_item['Menu']['use_link'] );
					$html_attributes['title'] = __($menu_item['Menu']['language_title'], true);
							
					if(!$menu_item['Menu']['allowed']){
						$root_menu_for_header .= '
								<!-- '.$menu_item['Menu']['id'].' -->
								<li class="not_allowed count_'.$key.'">
									<a class="menu plugin not_allowed" title="'.__($menu_item['Menu']['language_title'], true).'">'.__($menu_item['Menu']['language_title'], true).'</a>
								</li>
						';
					}else{
						$root_menu_for_header .= '
								<!-- '.$menu_item['Menu']['id'].' -->
								<li class="'.( $menu_item['Menu']['at'] ? 'at ' : '' ).'count_'.$key.'">
									'.$this->Html->link( html_entity_decode(__($menu_item['Menu']['language_title'], true), ENT_QUOTES, "UTF-8"), $menu_item['Menu']['use_link'], $html_attributes ).'
								</li>
						';
					}
				}
				$root_menu_for_header .= '</ul>';
			}
				
			// set HEADER main menu links
			if(isset($menu_array[2]) && count($menu_array[2])){
				$root_menu_for_header .= '<ul id="main_menu_for_header" class="header_menu">';
				
				foreach($menu_array[2] as $key => $menu_item){
					$html_attributes = array();
					$html_attributes['class'] = 'menu '.$this->Structures->generateLinkClass( 'plugin '.$menu_item['Menu']['use_link'] );
					$html_attributes['title'] = html_entity_decode(__($menu_item['Menu']['language_title'], true), ENT_QUOTES, "UTF-8");
					
					if(!$menu_item['Menu']['allowed']){
						$root_menu_for_header .= '
								<!-- '.$menu_item['Menu']['id'].' -->
								<li class="not_allowed count_'.$key.'">
									<a class="menu plugin not_allowed" title="'.__($menu_item['Menu']['language_title'], true).'">'.__($menu_item['Menu']['language_title'], true).'</a>
								</li>
						';
					}else{
						$root_menu_for_header .= '
								<!-- '.$menu_item['Menu']['id'].' -->
								<li class="'.( $menu_item['Menu']['at'] ? 'at ' : '' ).'count_'.$key.'">
									'.$this->Html->link( html_entity_decode(__($menu_item['Menu']['language_title'], true), ENT_QUOTES, "UTF-8"), $menu_item['Menu']['use_link'], $html_attributes ).'
								</li>
						';
					}
				}
				$root_menu_for_header .= '</ul>';
			}
		}else{
			$logged_in = false;
		}
		$return .= "<fieldset>";//the fieldset is present to manage the display for wide forms such as addgrids		
		$return .= '
			<!-- start #header -->
			<div id="header">
				<h1>'.__('core_appname', true).'</h1>
				'.$root_menu_for_header.'
				'.$main_menu_for_header.'
			</div>
			<!-- end #header -->
			
		';	
		// display DEFAULT menu
		if($logged_in){	
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
							<li class="at count_0 root">
								<a href="'.$this->Html->url('/').'" class="without_summary menu plugin login" title="'. __('Login', true).'">'. __('Login', true).'</a>
							</li>
						</ul>
					</div>
					
				</div>
				<!-- end #menu -->
			';
		}
		
		// display any VALIDATION ERRORS
		$display_errors_html = null;
		if(isset($this->validationErrors) && count($this->validationErrors)){
			$display_errors = array();
			foreach ( $this->validationErrors as $model ) {
				foreach ( $model as $field ) {
					$display_errors[] = '
						<li>'.__($field, true).'</li>
					';
				}
			}
			$display_errors_html = 
					'<ul class="error">
						'.implode('',array_unique($display_errors)).'
					</ul>';
		}
		$confirm_msg_html = "";
		if(isset($_SESSION['ctrapp_core']['confirm_msg'])){
			$confirm_msg_html = '<ul class="confirm"><li>'.$_SESSION['ctrapp_core']['confirm_msg'].'</li></ul>';
			unset($_SESSION['ctrapp_core']['confirm_msg']);
		}
		
		if(isset($_SESSION['ctrapp_core']['warning_msg']) && count($_SESSION['ctrapp_core']['warning_msg']) > 0){
			$confirm_msg_html .= '<ul class="warning">';
			foreach($_SESSION['ctrapp_core']['warning_msg'] as $warning_msg){
				$confirm_msg_html .= "<li>".$warning_msg."</li>";
			}
			$confirm_msg_html .= '</ul>';
			$_SESSION['ctrapp_core']['warning_msg'] = array();
		}
		if($display_errors_html != null || strlen($confirm_msg_html) > 0){
		$return .= '
			<!-- start #validation -->
			<div id="validation">
				'.$display_errors_html.$confirm_msg_html.'
			</div>
			<!-- end #validation -->
			';
		}
		$return .= '	
			<!-- start #wrapper -->
			<div class="outerWrapper">
				<div id="wrapper" class="wrapper plugin_'.( isset($this->params['plugin']) ? $this->params['plugin'] : 'none' ).' controller_'.$this->params['controller'].' action_'.$this->params['action'].'">
		';
		
		return $return;
		
	}
	
	function footer( $options=array() ) {
		
		$return = '';
		
		$return .= '
		   		</div>
		   </div>
		   
			<!-- end #wrapper -->
			
			<!-- start #footer -->
			<div id="footer">
				
				<p>
					<span>
						'.$this->Html->link( html_entity_decode(__('core_footer_about', true), ENT_QUOTES, "UTF-8"), '/pages/about/' ).'
						'.$this->Html->link( html_entity_decode(__('core_footer_installation', true), ENT_QUOTES, "UTF-8"), '/pages/installation/' ).'
						'.$this->Html->link( html_entity_decode(__('core_footer_credits', true), ENT_QUOTES, "UTF-8"), '/pages/credits/' ).'
					</span>
						'.__('core_copyright', true).' &copy; '.date('Y').' '.$this->Html->link( html_entity_decode(__('core_ctrnet', true), ENT_QUOTES, "UTF-8"), 'https://www.ctrnet.ca/' ).'
				</p>
				
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
								$menu_item['Menu']['use_summary'] = $fetched_summary['short'];
							}
							
							if($menu_item['Menu']['at']){
								$is_root = $menu_item['Menu']['is_root'];
								
								$summary_item = $menu_item['Menu']['use_summary'] ? NULL : array('class'=>'without_summary');
								
								if($menu_item['Menu']['use_summary']){
									$word = __(trim($menu_item['Menu']['language_title']), true);
									$untranslated = strpos($word, "<span class='untranslated'>") === 0;
									if($untranslated){
										$word = substr($part, 27, -7);			
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
									
									$html_attributes = array('class'=>'mainTitle');
									
									if($is_root){
										$html_attributes['class'] .= ' menu '.$this->Structures->generateLinkClass( 'plugin '.$menu_item['Menu']['use_link'] );
										$html_attributes['title'] = html_entity_decode(__($menu_item['Menu']['language_title'], true), ENT_QUOTES, "UTF-8");
										
										// $active_item = $menu_item['Menu']['allowed'] ? $this->Html->link( __($menu_item['Menu']['language_title'], true), $menu_item['Menu']['use_link'], $html_attributes ) : __($menu_item['Menu']['language_title'], true);
										
										if(!$menu_item['Menu']['allowed']){
											$active_item = '<a class="menu plugin not_allowed" title="'.__($menu_item['Menu']['language_title'], true).'">'.__($menu_item['Menu']['language_title'], true).'</a>';
										}else {
											$active_item = $this->Html->link( html_entity_decode(__($menu_item['Menu']['language_title'], true), ENT_QUOTES, "UTF-8"), $menu_item['Menu']['use_link'], $html_attributes );
										}
									}else{
										$active_item = '<span class="'.implode( ' ', $html_attributes ).'">'.__($menu_item['Menu']['language_title'], true).'</span>';
									}
									
									$page_title[] = __($menu_item['Menu']['language_title'], true);
								}
								
							}
							
							$html_attributes = array();
							$html_attributes['class'] = 'menu list'; // $html_attributes['class'] = 'menu '.$this->Structures->generateLinkClass( $menu_item['Menu']['language_title'], $menu_item['Menu']['use_link'] );
							
							if(!$menu_item['Menu']['allowed']){
								$append_menu .= '
										<!-- '.$menu_item['Menu']['id'].' -->
										<li class="not_allowed count_'.$sub_count.'">
											<a class="menu plugin not_allowed" title="'.__($menu_item['Menu']['language_title'], true).'">'.__($menu_item['Menu']['language_title'], true).'</a>
										</li>
								';
							}else{
								$append_menu .= '
										<!-- '.$menu_item['Menu']['id'].' -->
										<li class="'.( $menu_item['Menu']['at'] ? 'at ' : '' ).'count_'.$sub_count.'">
											'.$this->Html->link( html_entity_decode(__($menu_item['Menu']['language_title'], true), ENT_QUOTES, "UTF-8"), $menu_item['Menu']['use_link'], $html_attributes ).'
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
			App::import('Model','StructureField');
			$structure_fields_model = new StructureField;
			
			list($model,$function) = split('::',$summary);
			
			if(!$function){
				$function = 'summary';
			}
			
			if($model && App::import('Model',$model)){
				// if model name is PLUGIN.MODEL string, need to split and drop PLUGIN name after import but before NEW
				$plugin = NULL;
				if (strpos($model,'.') !== false){
					$plugin_model_name = $model;
					list($plugin,$model) = explode('.',$plugin_model_name);
				}
				
				// load MODEL, and override with CUSTOM model if it exists...
				$summary_model = new $model;
				$custom_model = $model.'Custom';
				if(App::import('Model',$custom_model)){
					$summary_model = new $custom_model;
				}
				
				$summary_result = $summary_model->{$function}($options['variables']);
				if(isset($summary_result['Summary'])){
					if(Configure::read('debug') > 0){
						AppController::addWarningMsg(sprintf(__("the sumarty for model [%s] function [%s] return array should not contain 'summary' as first key (deprecated)", true), $model, $function));
					}
					$summary_result = $summary_result['Summary'];
				}
				
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
								$part = substr($part, 27, -7);			
							}
							$total_length += strlen($part);
							if($total_length > $max_length){
								$part = substr($part, 0, -1 * ($total_length - $max_length))."...";
							}
							$result_str .= $untranslated ? '<span class="untranslated">'.$part.'</span>' : $part;
							if($total_length > $max_length){
								$result_str = '<span class="incompleteMenuTitle" title="'.htmlentities(implode("", $parts), ENT_QUOTES).'">'.$result_str.'</span>';
								break;
							}
						}
						$result['short'] = $result_str;
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
							AppController::addWarningMsg(sprintf(__("the sumarty for model [%s] function [%s] is using the depreacted description way instead of a structure", true), $model, $function));
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