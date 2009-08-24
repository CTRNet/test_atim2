<?php
	
	$atim_content = array();
	$atim_content['menu'] = '';
	
	if ( count($menu_data) ) {
		
		$atim_content['menu'] .= '
				<ul id="big_menu_tools" class="big_menu">
		';
		
			$count = 0;
			foreach ( $menu_data as $menu ) {
				
				$html_attributes = array();
				$html_attributes['class'] = 'menu '.$structures->generate_link_class( 'plugin '.$menu['Menu']['use_link'] );
				$html_attributes['title'] = __($menu['Menu']['language_title'], true);
				
				if ( !$menu['Menu']['language_description'] ) $menu['Menu']['language_description'] = $menu['Menu']['language_title'];
						
				/*
				$atim_content['menu'] .= '
							<!-- '.$menu['Menu']['id'].' -->
							<li class="'.( !$menu['Menu']['allowed'] ? 'not_allowed ' : '' ).'count_'.$count.'">
								'.( $menu['Menu']['allowed'] ? $html->link( __($menu['Menu']['language_title'], true), $menu['Menu']['use_link'], $html_attributes ) : __($menu['Menu']['language_title'], true) ).'
							</li>
				';
				*/
						
				if ( !$menu['Menu']['allowed'] ) {
					
					$atim_content['menu'] .= '
							<!-- '.$menu['Menu']['id'].' -->
							<li class="not_allowed count_'.$count.'">
								<a class="menu plugin not_allowed" title="'.__($menu['Menu']['language_title'], true).'">
									'.__($menu['Menu']['language_title'], true).'
									<span>'.__($menu['Menu']['language_description'], true).'</span>
								</a>
							</li>
					';
					
				} 
				
				else {
					$link_title = __($menu['Menu']['language_title'], true).'<span>'.__($menu['Menu']['language_description'], true).'</span>';
					
					$atim_content['menu'] .= '
							<!-- '.$menu['Menu']['id'].' -->
							<li class="'.( $menu['Menu']['at'] ? 'at ' : '' ).'count_'.$count.'">
								<a class="'.$html_attributes['class'].'" href="'.$html->url( $menu['Menu']['use_link'] ).'" title="'.$html_attributes['title'].'">
									'.__($menu['Menu']['language_title'], true).'
									<span>'.__($menu['Menu']['language_description'], true).'</span>
								</a>
							</li>
					';
				}
				
				$count++;
			}
			
		$atim_content['menu'] .= '
			</ul>
		';
		
	}
	
	echo $structures->generate_content_wrapper( $atim_content, array('links'=>array('bottom'=>array('back to main menu'=>'/menus'))) );
	
?>