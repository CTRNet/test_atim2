<?php
$structureLinks = array(
    'bottom' => array(
        'edit' => '/Administrate/Announcements/edit/%%Announcement.id%%/',
        'delete' => '/Administrate/Announcements/delete/%%Announcement.id%%/'
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