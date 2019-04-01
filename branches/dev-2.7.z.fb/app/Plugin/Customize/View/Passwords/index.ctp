<?php
$structureLinks = array(
    'top' => '/Customize/Passwords/index'
);
$this->Structures->build($atimStructure, array(
    'type' => 'edit',
    'links' => $structureLinks,
    'settings' => array(
        'stretch' => false
    )
));