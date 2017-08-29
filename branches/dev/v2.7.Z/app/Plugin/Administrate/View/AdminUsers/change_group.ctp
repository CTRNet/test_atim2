<?php
$finalOptions = array(
    'type' => 'edit',
    'links' => array(
        'top' => sprintf('/Administrate/AdminUsers/changeGroup/%d/%d/', $atimMenuVariables['Group.id'], $atimMenuVariables['User.id']),
        'bottom' => array(
            'cancel' => sprintf('/Administrate/AdminUsers/detail/%d/%d/', $atimMenuVariables['Group.id'], $atimMenuVariables['User.id'])
        )
    )
);

$finalAtimStructure = $atimStructure;

$this->Structures->build($finalAtimStructure, $finalOptions);