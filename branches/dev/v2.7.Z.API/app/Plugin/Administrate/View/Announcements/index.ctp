<?php
$structureLinks = array(
    'index' => array(
        'detail' => '/Administrate/Announcements/detail/%%Announcement.id%%/'
    ),
    'bottom' => array(
        'add' => "/Administrate/Announcements/add/$linkedModel/" . (isset($atimMenuVariables['User.id']) ? $atimMenuVariables['Group.id'] . '/' . $atimMenuVariables['User.id'] . '/' : $atimMenuVariables['Bank.id'])
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
	