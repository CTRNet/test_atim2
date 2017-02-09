<?php
$structure_links = array(
	'top' => '/Users/resetForgottenPassword/',
	'bottom' => array('cancel' => '/')
);

$structure_settings = array(
	'header' => array(
		'title' => __('reset password'),
		'description' => __('step %s', $reset_forgotten_password_step).' : '.(($reset_forgotten_password_step == '1')? __('please enter you username') : __('please conplete the security questions'))
	)
);
				
echo "<div class='validation hidden' id='timeErr'><ul class='warning'><li>".__("server_client_time_discrepency")."</li></ul></div>";

$this->Structures->build(
   $atim_structure, array(
      'type'=>'edit',
      'links'=>$structure_links,
      'settings' => $structure_settings
   )
);
