<?php
$structureLinks = array(
    'bottom' => array(
        'edit' => '/Administrate/Announcements/edit/%%Announcement.id%%/',
        'delete' => '/Administrate/Announcements/delete/%%Announcement.id%%/'
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