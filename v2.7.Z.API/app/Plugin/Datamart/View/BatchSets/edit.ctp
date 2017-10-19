<?php
$structureLinks = array(
    'top' => '/Datamart/BatchSets/edit/' . $atimMenuVariables['BatchSet.id'],
    'bottom' => array(
        'cancel' => '/Datamart/BatchSets/listall/' . $atimMenuVariables['BatchSet.id']
    )
);

$this->Structures->build($atimStructure, array(
    'links' => $structureLinks
));