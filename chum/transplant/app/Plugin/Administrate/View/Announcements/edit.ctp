<?php
$structureLinks = array(
    'top' => '/Administrate/Announcements/edit/' . $atimMenuVariables['Announcement.id'],
    'bottom' => array(
        'cancel' => '/Administrate/Announcements/detail/' . $atimMenuVariables['Announcement.id']
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