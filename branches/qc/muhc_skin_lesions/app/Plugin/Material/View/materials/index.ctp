<?php
$structureLinks = array(
    'top' => array(
        'search' => '/Material/Materials/search/' . AppController::getNewSearchId()
    ),
    'bottom' => array(
        'add' => '/Material/Materials/add/'
    )
);

$this->Structures->build($atimStructure, array(
    'type' => 'search',
    'links' => $structureLinks
));