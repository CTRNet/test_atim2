<?php
$structureLinks = array(
    'top' => "/Administrate/Announcements/add/$linkedModel/" . (isset($atimMenuVariables['User.id']) ? $atimMenuVariables['Group.id'] . '/' . $atimMenuVariables['User.id'] . '/' : $atimMenuVariables['Bank.id']) . '/',
    'bottom' => array(
        'cancel' => "/Administrate/Announcements/index/$linkedModel/" . (isset($atimMenuVariables['User.id']) ? $atimMenuVariables['Group.id'] . '/' . $atimMenuVariables['User.id'] . '/' : $atimMenuVariables['Bank.id']) . '/'
    )
);

// CUSTOM CODE
$hookLink = $this->Structures->hook();
if ($hookLink) {
    require ($hookLink);
}

$this->Structures->build($atimStructure, array(
    'links' => $structureLinks
));
