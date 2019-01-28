<?php
$structureLinks = array(
    'top' => '/Users/resetForgottenPassword/',
    'bottom' => array(
        'cancel' => '/'
    )
);

$structureSettings = array(
    'header' => array(
        'title' => __('reset password'),
        'description' => __('step %s', $resetForgottenPasswordStep) . ' : ' . (($resetForgottenPasswordStep == '1') ? __('please enter you username') : __('please complete the security questions'))
    )
);

echo "<div class='validation hidden' id='timeErr'><ul class='warning'><li>" . __("server_client_time_discrepency") . "</li></ul></div>";

$this->Structures->build($atimStructure, array(
    'type' => 'edit',
    'links' => $structureLinks,
    'settings' => $structureSettings
));