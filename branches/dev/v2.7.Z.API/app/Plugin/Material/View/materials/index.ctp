<?php
$structureLinks = array(
    'top' => array(
        'search' => '/material/materials/search/' . AppController::getNewSearchId()
    ),
    'bottom' => array(
        'add' => '/material/materials/add/'
    )
);

$this->Structures->build($atimStructure, array(
    'type' => 'search',
    'links' => $structureLinks
));
?>