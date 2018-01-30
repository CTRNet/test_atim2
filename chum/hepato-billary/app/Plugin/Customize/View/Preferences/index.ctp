<?php
$structureLinks = array(
    'bottom' => array(
        'edit' => '/Customize/Preferences/edit'
    )
);

$this->Structures->build($atimStructure, array(
    'type' => 'detail',
    'links' => $structureLinks
));