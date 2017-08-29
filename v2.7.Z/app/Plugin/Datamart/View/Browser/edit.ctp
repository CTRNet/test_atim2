<?php
$structureLinks = array(
    "top" => "/Datamart/Browser/edit/" . $indexId,
    "bottom" => array(
        "cancel" => "/Datamart/Browser/index/"
    )
);
$this->Structures->build($atimStructure, array(
    'type' => 'edit',
    'links' => $structureLinks
));