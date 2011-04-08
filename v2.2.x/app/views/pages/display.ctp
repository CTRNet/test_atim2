<?php
	
	$atim_content = array();
	
	$atim_content['page'] = '
		<h3>'.__( $data['Page']['language_title'], true ).'</h3>
		'.$data['Page']['language_body'].'
	';
	if(isset($data['err_trace'])){
		$atim_content['page'] .= "<br/>".$data['err_trace'];
	}
	
	echo $structures->generateContentWrapper($atim_content);
?>