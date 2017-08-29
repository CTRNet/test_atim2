<?php
$structureLinks = array(
    'index' => array(
        'detail' => '/Administrate/Structure/detail/%%Structure.id%%'
    )
);

$this->Structures->build($atimStructure, array(
    'links' => $structureLinks
));