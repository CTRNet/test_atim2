<?php
	
	$atim_content = array();
	$atim_content['menu'] = '';
	$atim_content['announcements'] = '';
	
	if ( count($menu_data) ) {
		
		$atim_content['menu'] .= '
				<ul id="big_menu_main" class="big_menu">
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
	
	$atim_content['announcements'] .= '<h2>'.__( 'core_announcements', true ).'</h2>';
		
	if ( count($announcements_data) ) {
		
		foreach ( $announcements_data as $key=>$announcement ) {
			
			// first announcement
			if ( !$key ) {
				$atim_content['announcements'] .=  '
					<h3>'.$announcement['Announcement']['title'].' <span>'.__( strtolower(date( 'M', $time->toUnix($announcement['Announcement']['date']) )), true ).' '.date( 'd', $time->toUnix($announcement['Announcement']['date']) ).'</span></h3>
					<p>'.$announcement['Announcement']['body'].'</p>
				';
				
				if ( count($announcements_data)>1 ) {
					$atim_content['announcements'] .=  '
					<h3 class="previous_announcements">'.__( 'core_previous_announcements', true ).'</h3>
					';
				}
			}
			
			// all other announcements
			else {
				$atim_content['announcements'] .=  '
					<h3>'.$html->link( $announcement['Announcement']['title'], '/customize/announcements/detail/'.$announcement['Announcement']['id'] ).' <span>'.__( strtolower(date( 'M', $time->toUnix($announcement['Announcement']['date']) )), true ).' '.date( 'd', $time->toUnix($announcement['Announcement']['date']) ).'</span></h3>
				';
			}
			
		}
		
	}
	
	echo $structures->generate_content_wrapper( $atim_content );
	
?>