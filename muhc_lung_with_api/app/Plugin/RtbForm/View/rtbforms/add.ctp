<?php
$structureLinks = array(
    'top' => '/rtbform/rtbforms/add/',
    'bottom' => array(
        'cancel' => '/rtbform/rtbforms/index/'
    )
);

$this->Structures->build($atimStructure, array(
    'links' => $structureLinks
));