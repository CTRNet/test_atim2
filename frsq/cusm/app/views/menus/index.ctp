<?php
	$atim_content = array(
		'menu'			=>	'',
		'announcements'	=>	''
	);
	
	if(count($menu_data)){
		
		$atim_content['menu'] .= '
				<ul id="big_menu_main" class="big_menu">
		';
		
		$count = 0;
		foreach ( $menu_data as $menu ) {
			$html_attributes = array();
			$html_attributes['class'] = 'menu '.$structures->generateLinkClass( 'plugin '.$menu['Menu']['use_link'] );
			$html_attributes['title'] = __($menu['Menu']['language_title'], true);
					
			if(!$menu['Menu']['language_description']){
				$menu['Menu']['language_description'] = $menu['Menu']['language_title'];
			}
					
			if(!$menu['Menu']['allowed']){
				$atim_content['menu'] .= '
						<!-- '.$menu['Menu']['id'].' -->
						<li class="not_allowed count_'.$count.'">
							<a class="menu plugin not_allowed" title="'.__($menu['Menu']['language_title'], true).'">
								'.__($menu['Menu']['language_title'], true).'
								<span>'.__($menu['Menu']['language_description'], true).'</span>
							</a>
						</li>
				';
			}else{
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
	
	$atim_content['announcements'] .= '<h2>'.__( 'core_announcements', true ).'</h2>';
		
	if(count($announcements_data)){
	
		$atim_content['announcements'] .= '
				<ul class="big_announcements">
		';
		
		foreach($announcements_data as $key => $announcement){
			$atim_content['announcements'] .= '
					<!-- '.$announcement['Announcement']['id'].' -->
					<li>
						<a href="'.$html->url( '/customize/announcements/detail/'.$announcement['Announcement']['id'] ).'">
							'.$announcement['Announcement']['title'].'
							<span>'.__( strtolower(date( 'M', $time->toUnix($announcement['Announcement']['date']) )), true ).' '.date( 'd', $time->toUnix($announcement['Announcement']['date']) ).'</span>
						</a>
					</li>
			';
		}
			
		$atim_content['announcements'] .= '
			</ul>
		';
		
	}

	echo $structures->generateContentWrapper($atim_content);
	
?>