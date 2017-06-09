<?php
$structureLinks = array(
    'top' => '/Administrate/Announcements/edit/%%Announcement.id%%/',
    'bottom' => array(
        'cancel' => '/Administrate/Announcements/detail/%%Announcement.id%%/'
    )
);

$this->Structures->build($atimStructure, array(
    'links' => $structureLinks
));
?>
