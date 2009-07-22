<?php
	
	$atim_content = array();
	$atim_content['menu'] = '';
	
	if ( count($menu_data) ) {
		
		$atim_content['menu'] .= '
				<ul id="big_menu_tools" class="big_menu">
		';
		
			$count = 0;
			foreach ( $menu_data as $menu ) {
				
				$atim_content['menu'] .= '
							<!-- '.$menu['Menu']['id'].' -->
							<li class="'.( !$menu['Menu']['allowed'] ? 'not_allowed ' : '' ).'count_'.$count.'">
								'.( $menu['Menu']['allowed'] ? $html->link( __($menu['Menu']['language_title'], true), $menu['Menu']['use_link'] ) : __($menu['Menu']['language_title'], true) ).'
							</li>
				';
				
				$count++;
			}
			
		$atim_content['menu'] .= '
			</ul>
		';
		
	}
	
	echo $structures->generate_content_wrapper( $atim_content, array('links'=>array('bottom'=>array('back to main menu'=>'/menus'))) );
	
?>