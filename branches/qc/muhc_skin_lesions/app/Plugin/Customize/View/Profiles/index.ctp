<?php
$structureLinks = array(
    'bottom' => array(
        'edit' => '/Customize/Profiles/edit'
    )
);

$this->Structures->build($atimStructure, array(
    'type' => 'detail',
    'links' => $structureLinks
));