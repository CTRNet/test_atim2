<?php

$structureLinks = array(
    'index' => array(
        'detail' => '/Administrate/FormBuilders/detail/' . '/%%FormBuilder.id%%'
    )
);

$structureOptions = array(
    'links' => $structureLinks,
    'type' => 'index',
    'settings' =>array(
        'pagination' => 0
    )
);

$this->Structures->build($atimStructure, $structureOptions);
