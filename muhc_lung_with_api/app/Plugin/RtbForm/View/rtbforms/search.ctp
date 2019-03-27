<?php
$structureLinks = array(
    'index' => array(
        'profile' => '/rtbform/rtbforms/profile/%%Rtbform.id%%'
    ),
    'bottom' => array(
        'add' => '/rtbform/rtbforms/add/',
        'search' => '/rtbform/rtbforms/index/'
    )
);

$this->Structures->build($atimStructure, array(
    'type' => 'index',
    'links' => $structureLinks
));