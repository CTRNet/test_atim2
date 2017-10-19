<?php
$structureLinks = array(
    'top' => '/Customize/Preferences/edit',
    'bottom' => array(
        'cancel' => '/Customize/Preferences/index'
    )
);

$this->Structures->build($atimStructure, array(
    'links' => $structureLinks
));