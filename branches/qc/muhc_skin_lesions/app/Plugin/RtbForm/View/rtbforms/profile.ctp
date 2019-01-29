<?php
$structureLinks = array(
    'bottom' => array(
        'search' => '/rtbform/rtbforms/index/',
        'edit' => '/rtbform/rtbforms/edit/%%Rtbform.id%%/',
        'delete' => '/rtbform/rtbforms/delete/%%Rtbform.id%%/'
    )
);

$this->Structures->build($atimStructure, array(
    'links' => $structureLinks
));