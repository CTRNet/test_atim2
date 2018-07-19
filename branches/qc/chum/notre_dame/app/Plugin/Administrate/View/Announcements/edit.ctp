<?php
$structureLinks = array(
    'top' => '/Administrate/Announcements/edit/' . $atimMenuVariables['Announcement.id'],
    'bottom' => array(
        'cancel' => '/Administrate/Announcements/detail/' . $atimMenuVariables['Announcement.id']
    )
);

$this->Structures->build($atimStructure, array(
    'links' => $structureLinks
));