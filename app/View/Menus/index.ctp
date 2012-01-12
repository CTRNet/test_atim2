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
			$html_attributes['class'] = 'menu '.$this->Structures->generateLinkClass( 'plugin '.$menu['Menu']['use_link'] );
			$html_attributes['title'] = __($menu['Menu']['language_title']);
					
			if(!$menu['Menu']['language_description']){
				$menu['Menu']['language_description'] = $menu['Menu']['language_title'];
			}
					
			if(!$menu['Menu']['allowed']){
				$atim_content['menu'] .= '
						<!-- '.$menu['Menu']['id'].' -->
						<li class="not_allowed count_'.$count.'">
							<a class="menu plugin not_allowed" title="'.__($menu['Menu']['language_title']).'">
								'.__($menu['Menu']['language_title']).'
								<span>'.__($menu['Menu']['language_description']).'</span>
							</a>
						</li>
				';
			}else{
				$atim_content['menu'] .= '
						<!-- '.$menu['Menu']['id'].' -->
						<li class="'.( $menu['Menu']['at'] ? 'at ' : '' ).'count_'.$count.'">
							<a class="'.$html_attributes['class'].'" href="'.$this->Html->url( $menu['Menu']['use_link'] ).'" title="'.$html_attributes['title'].'">
								'.__($menu['Menu']['language_title']).'
								<span>'.__($menu['Menu']['language_description']).'</span>
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
	
	if($due_messages_count > 0 && AppController::checkLinkPermission('/ClinicalAnnotation/ParticipantMessages/search/')){
		$atim_content['messages'] = '<ul class="warning"><li>'.__('not done participant messages having reached their due date').': '.$due_messages_count.'.
		Click <a href="javascript:goToNotDoneDueMessages()">here</a> to see them.
		</li></ul>
		<form action="'.$this->request->webroot.'ClinicalAnnotation/ParticipantMessages/search/'.AppController::getNewSearchId().'" method="POST" id="doneDueMessages">
			<input type="hidden" name="data[ParticipantMessage][done]" value="0">
			<input type="hidden" name="data[ParticipantMessage][due_date_end]" value="'.now().'">
		</form>
		';
	}
	

	echo $this->Structures->generateContentWrapper($atim_content);
?>
<script>
function goToNotDoneDueMessages(){
	$("#doneDueMessages").submit();
}
</script>