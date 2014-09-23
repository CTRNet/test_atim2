<?php
	$atim_content = array();
	
	$atim_content['page'] = '
		<h3>'.__( 'system error', true ).'</h3>
		'.__('a system error has been detected').'
	';
	
	if (Configure::read('debug') > 0 ) {
		$atim_content['page'] .= "<br/>".$this->element('exception_stack_trace');
	}

	echo $this->Structures->generateContentWrapper($atim_content);
?>