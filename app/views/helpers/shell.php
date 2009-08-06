<?php

class ShellHelper extends Helper {
	
	var $helpers = array('Html','Session','Structures');
	
	function header( $options=array() ) {
		
		$menu_array					= $this->menu( $options['atim_menu'], array('variables'=>$options['atim_menu_variables']) );
		
		$menu_for_wrapper			= $menu_array[0];
		
		$user_for_header			= '';
		$root_menu_for_header	= '';
		$main_menu_for_header	= '';
		
		if ( isset($_SESSION) && isset($_SESSION['Auth']) && isset($_SESSION['Auth']['User']) && count($_SESSION['Auth']['User']) ) {
			
			// set HEADER root menu links
				
				if ( isset($menu_array[1]) && count($menu_array[1]) ) {
					
					$root_menu_for_header .= '<ul id="root_menu_for_header" class="header_menu">';
					
					foreach ( $menu_array[1] as $key=>$menu_item ) {
						
						$root_menu_for_header .= '
									<!-- '.$menu_item['Menu']['id'].' -->
									<li class="'.( !$menu_item['Menu']['allowed'] ? 'not_allowed ' : '' ).( $menu_item['Menu']['at'] ? 'at ' : '' ).'count_'.$key.'">
										'.( $menu_item['Menu']['allowed'] ? $this->Html->link( __($menu_item['Menu']['language_title'], true), $menu_item['Menu']['use_link'] ) : __($menu_item['Menu']['language_title'], true) ).'
									</li>
						';
						
					}
					
					$root_menu_for_header .= '</ul>';
					
				}
				
			// set HEADER main menu links
				
				if ( isset($menu_array[2]) && count($menu_array[2]) ) {
					
					$root_menu_for_header .= '<ul id="main_menu_for_header" class="header_menu">';
					
					foreach ( $menu_array[2] as $key=>$menu_item ) {
						
						$root_menu_for_header .= '
									<!-- '.$menu_item['Menu']['id'].' -->
									<li class="'.( !$menu_item['Menu']['allowed'] ? 'not_allowed ' : '' ).( $menu_item['Menu']['at'] ? 'at ' : '' ).'count_'.$key.'">
										'.( $menu_item['Menu']['allowed'] ? $this->Html->link( __($menu_item['Menu']['language_title'], true), $menu_item['Menu']['use_link'] ) : __($menu_item['Menu']['language_title'], true) ).'
									</li>
						';
						
					}
					
					$root_menu_for_header .= '</ul>';
					
				}
				
			// set HEADER logged in user
				
				/*
				$user_for_header .= '
					<p id="user_for_header">
						<span>Logged in as:</span>
						'.$_SESSION['Auth']['User']['name'].'
					</p>
				';
				*/
			
		}
		
		echo '
			<!-- start #header -->
			<div id="header">
				<h1>'.__('core_appname', true).'</h1>
				'.$root_menu_for_header.'
				'.$main_menu_for_header.'
			</div>
			<!-- end #header -->
			
			'.$user_for_header.'
			
			<!-- start #menu -->
			<div id="menu">
				'.$menu_for_wrapper.'
			</div>
			<!-- end #menu -->
			
			<!-- start #wrapper -->
			<div id="wrapper" class="plugin_'.( isset($this->params['plugin']) ? $this->params['plugin'] : 'none' ).' controller_'.$this->params['controller'].' action_'.$this->params['action'].'">
		';
		
	}
	
	function footer( $options=array() ) {
		
		echo '
		   </div>
			<!-- end #wrapper -->
			
			<!-- start #footer -->
			<div id="footer">
				
				<p>
					<span>
						'.$this->Html->link( __('core_footer_about', true), '/pages/about/' ).'
						'.$this->Html->link( __('core_footer_installation', true), '/pages/installation/' ).'
						'.$this->Html->link( __('core_footer_credits', true), '/pages/credits/' ).'
					</span>
						'.__('core_copyright', true).' &copy; '.date('Y').' '.$this->Html->link( __('core_ctrnet', true), 'https://www.ctrnet.ca/' ).'
				</p>
				
			</div>
			<!-- end #footer -->
		';
		
	} 
	
	function menu( $atim_menu=array(), $options=array() ) {
		
		$this->pageTitle = 'aaa';
		
		$return_html = '';
		$root_menu_array = array();
		$main_menu_array = array();
		
		if ( count($atim_menu) ) {
			
			$summaries = array();
			if ( !isset($options['variables']) ) $options['variables'] = array();
			
			$return_html .= '
				<div class="menu level_0">
					<ul>
			';
			
				if ( isset($_SESSION) && isset($_SESSION['Auth']) && isset($_SESSION['Auth']['User']) && count($_SESSION['Auth']['User']) ) {
					
					$count = 0;
					$is_root = false; // used to remove unneeded ROOT menu items from displaying in bar
					
					foreach ( $atim_menu as $menu ) {
						
						$active_item = '';
						$summary_item = '';
						$append_menu = '';
						
						// save BASE array (main menu) for display in header
						if ( $count==(count($atim_menu)-1) )	$root_menu_array = $menu;
						if ( $count==(count($atim_menu)-2) )	$main_menu_array = $menu;
						
						if ( !$is_root ) {
								
							$sub_count = 0;
							foreach ( $menu as $menu_item ) {
								
								if ( $menu_item['Menu']['use_link'] && count($options['variables']) ) {
									foreach ( $options['variables'] as $k=>$v ) {
										$menu_item['Menu']['use_link'] = str_replace('%%'.$k.'%%',$v,$menu_item['Menu']['use_link']);
									}
								}
								
								if ( $menu_item['Menu']['at'] && $menu_item['Menu']['use_summary'] ) {
									$summaries[] = $this->fetch_summary($menu_item['Menu']['use_summary'],$options,'long');
									$menu_item['Menu']['use_summary'] = $this->fetch_summary($menu_item['Menu']['use_summary'],$options,'short');
								}
								
								if ( $menu_item['Menu']['at'] ) {
									
									$is_root = $menu_item['Menu']['is_root'];
									
									$summary_item = $menu_item['Menu']['use_summary'] ? NULL : array('class'=>'without_summary');
									
									if ( $menu_item['Menu']['use_summary'] ) {
										$active_item = '
											<span>'.$menu_item['Menu']['use_summary'].'</span>
											<br />&nbsp;&lfloor; '.__($menu_item['Menu']['language_title'], true).'
										';
									}
									
									else {
										$active_item = '<span class="without_summary">'.__($menu_item['Menu']['language_title'], true).'</span>';
									}
									
								}
								
								$html_attributes = array();
								$html_attributes['class'] = 'menu '.$this->Structures->generate_link_class( $menu_item['Menu']['language_title'], $menu_item['Menu']['use_link'] );
								
								$append_menu .= '
											<!-- '.$menu_item['Menu']['id'].' -->
											<li class="'.( !$menu_item['Menu']['allowed'] ? 'not_allowed ' : '' ).( $menu_item['Menu']['at'] ? 'at ' : '' ).'count_'.$sub_count.'">
												'.( $menu_item['Menu']['allowed'] ? $this->Html->link( __($menu_item['Menu']['language_title'], true), $menu_item['Menu']['use_link'], $html_attributes ) : __($menu_item['Menu']['language_title'], true) ).'
											</li>
								';
								
								$sub_count++;
								
							}
							
							if ( !$is_root ) {
								$append_menu = '
										<div class="menu level_1">
											<ul>
												'.$append_menu.'
											</ul>
										</div>
								';
							} else {
								$append_menu = '';
							}
							
							$return_html .= '
								<li class="at count_'.$count.( $is_root ? ' root' : '' ).'">
									'.$active_item.'
									'.$append_menu.'
								</li>
							';
							
						}
						
						$count++;
					}
				}
				
			$return_html .= '
				</ul>
				
			';
			
			// if summary info has been provided, provide expandable tab
			$summaries = array_filter($summaries);
			if ( count($summaries) ) {
				$return_html .= '
					<ul id="summary">
						<li>
							<span>Summary</span>
							
							<ul>
				';
				
				$count = 0;
				foreach ( $summaries as $summary ) {
					$return_html .= '
								<li class="count_'.$count.'">
									'.$summary.'
								</li>
					';
					
					$count++;
				}
				
				$return_html .= '
							</ul>
							
						</li>
					</ul>
				';
			}
			
			$return_html .= '
				</div>
			';
			
		}
		
		// no menu provided...
		else {
			$return_html .= '
				<div class="menu level_0">
				</div>
			';
		}
		
		$return_array = array( $return_html, $root_menu_array, $main_menu_array );
		return $return_array;
		
	}
	
	function fetch_summary( $summary, $options, $format='short' ) {
		
		if ( $summary ) {
		
			list($model,$function) = split('::',$summary);
			
			if ( !$function ) $function = 'summary';
			
			if ( $model && App::import('Model',$model) ) {
				
				// if model name is PLUGIN.MODEL string, need to split and drop PLUGIN name after import but before NEW
				if ( strpos($model,'.')!==false ) {
					$plugin_model_name = $model;
					$plugin_model_name = explode('.',$plugin_model_name);
					$model = $plugin_model_name[1];
				}
				
				$summary_model = new $model;
				
				$summary_result = $summary_model->{$function}( $options['variables'] );
				
				if ( $summary_result ) { 
					
					if ( $format=='short' ) {
						$summary = trim(__($summary_result['Summary']['menu'][0], true).' '.$summary_result['Summary']['menu'][1]); 
					}
					
					else {
						
						$formatted_summary = '
							<dl>
							'.__($summary_result['Summary']['title'][0], true).'
							<lh>'.$summary_result['Summary']['title'][1].'</lh>
						';
						
						foreach ( $summary_result['Summary']['description'] as $k=>$v ) {
							$formatted_summary .= '
									<dt>'.__($k,true).'</dt>
									<dd>'.$v.'</dd>
							';
						}
						
						$formatted_summary .= '
							</dl>
						';
						
						$summary = $formatted_summary;
						
					}
				} 
				
				else { 
					$summary = false; 
				}
			} 
			
			else {
				$summary = false;
			}
			
		}
		
		return $summary;
		
	}
	
}
	
?>