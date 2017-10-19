<?php
$structureLinks = array(
    'bottom' => array(
        'edit' => '/Administrate/Groups/edit/%%Group.id%%',
        'delete' => '/Administrate/Groups/delete/%%Group.id%%'
    )
);
if (! $displayEditButton)
    unset($structureLinks['bottom']['delete'], $structureLinks['bottom']['edit']);

$this->Structures->build($atimStructure, array(
    'links' => $structureLinks
));
?>
