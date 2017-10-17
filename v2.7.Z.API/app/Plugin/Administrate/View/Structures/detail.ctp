<?php
$structureLinks = array(
    'bottom' => array(
        'edit' => '/Administrate/Structure/edit/%%Structure.id%%'
    )
);

$this->Structures->build($atimStructure, array(
    'links' => $structureLinks
));