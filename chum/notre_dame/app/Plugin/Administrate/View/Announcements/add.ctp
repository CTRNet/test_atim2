<?php
$structureLinks = array(
    'top' => "/Administrate/Announcements/add/$linkedModel/" . (isset($atimMenuVariables['User.id']) ? $atimMenuVariables['User.id'] . '/' : $atimMenuVariables['Bank.id']) . '/',
    'bottom' => array(
        'cancel' => (isset($atimMenuVariables['User.id']) ? "/Administrate/Announcements/index/$linkedModel/" . $atimMenuVariables['User.id'] . '/' : "/Administrate/Banks/detail/" . $atimMenuVariables['Bank.id']) . '/'
    )
);

$finalOptions = array(
    'links' => $structureLinks,
    'settings' => array(
        'header' => isset($atimMenuVariables['User.id']) ? '' : __('announcement', null)
    )
);

// CUSTOM CODE
$hookLink = $this->Structures->hook();
if ($hookLink) {
    require ($hookLink);
}

$this->Structures->build($atimStructure, $finalOptions);