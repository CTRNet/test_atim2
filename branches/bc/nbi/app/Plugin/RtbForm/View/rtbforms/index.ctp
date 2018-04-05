<?php
$structureLinks = array(
    'top' => array(
        'search' => '/rtbform/rtbforms/search/' . AppController::getNewSearchId()
    ),
    'bottom' => array(
        'add' => '/rtbform/rtbforms/add/'
    )
);

$this->Structures->build($atimStructure, array(
    'type' => 'search',
    'links' => $structureLinks
));