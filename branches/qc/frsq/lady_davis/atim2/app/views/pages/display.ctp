<?php
	
	$atim_content = array();
	
	$atim_content['page'] = '
		<h3>'.__( $data['Page']['language_title'], true ).'</h3>
		'.__( $data['Page']['language_body'], true ).'
	';
	if(isset($data['err_trace'])){
		$atim_content['page'] .= "<br/>".$data['err_trace'];
	}
	
	echo $structures->generate_content_wrapper( $atim_content );
?>