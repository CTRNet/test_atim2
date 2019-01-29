<?php
$structureLinks = array(
    'top' => '/Customize/Profiles/edit',
    'bottom' => array(
        'cancel' => '/Customize/Profiles/index'
    )
);

$this->Structures->build($atimStructure, array(
    'links' => $structureLinks
));