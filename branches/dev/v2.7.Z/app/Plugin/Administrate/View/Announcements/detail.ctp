<?php
$structure_links = array(
    'bottom' => array(
        'edit' => '/Administrate/Announcements/edit/%%Announcement.id%%/',
        'delete' => '/Administrate/Announcements/delete/%%Announcement.id%%/'
    )
);

// CUSTOM CODE
$hook_link = $this->Structures->hook();
if ($hook_link) {
    require ($hook_link);
}

$this->Structures->build($atim_structure, array(
    'links' => $structure_links
));
?>