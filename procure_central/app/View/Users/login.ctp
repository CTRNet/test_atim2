<?php
$structureLinks = array(
    'top' => '/',
    'bottom' => array()
);
if (Configure::read('reset_forgotten_password_feature')) {
    $structureLinks['bottom'] = array(
        'reset password' => array(
            'link' => '/Users/resetForgottenPassword/',
            'icon' => 'customize'
        )
    );
}

echo "<div class='validation hidden' id='timeErr'><ul class='warning'><li>" . __("server_client_time_discrepency") . "</li></ul></div>";
$this->Structures->build($atimStructure, array(
    'type' => 'add',
    'links' => $structureLinks,
    'settings' => array(
        'tabindex' => 1000
    )
));

?>
<script>
var loginPage = true;
</script>