<?php
	$atim_content = array(
		'menu'			=> ''
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
	
	if($due_messages_count > 0 && AppController::checkLinkPermission('/clinicalannotation/participant_messages/search/')){
		$atim_content['messages'] = '<ul class="warning"><li>'.__('not done participant messages having reached their due date', true).': '.$due_messages_count.'.
		Click <a href="javascript:goToNotDoneDueMessages()">here</a> to see them.
		</li></ul>
		<form action="'.$this->webroot.'clinicalannotation/participant_messages/search/" method="POST" id="doneDueMessages">
			<input type="hidden" name="data[ParticipantMessage][done]" value="0">
			<input type="hidden" name="data[ParticipantMessage][due_date_end]" value="'.now().'">
		</form>
		';
	}
	

	echo $structures->generateContentWrapper($atim_content);
?>
<script>
function goToNotDoneDueMessages(){
	$("#doneDueMessages").submit();
}
</script>