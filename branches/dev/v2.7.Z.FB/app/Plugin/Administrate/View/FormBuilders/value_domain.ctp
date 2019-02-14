<?php
$structureOptions = array(
    'links' => array(
        'top' => "/Administrate/FormBuilders/valueDomain",
    ),
    'type' => 'edit',
    'settings' =>array(
        'header' => __("value domain list"),
    )
);

$this->Structures->build($formBuilderValueDomain, $structureOptions);