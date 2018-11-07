<?php
$finalAtimStructure = $atimStructure;
$finalOptions = array(
    'type' => 'index',
    'settings' => array(
        'pagination' => false
    ),
    'links' => array(
        'index' => array(
            'manage' => array(
                'link' => '/Administrate/ReusableMiscIdentifiers/manage/%%MiscIdentifierControl.id%%',
                'icon' => 'edit'
            )
        )
    )
);

$hookLink = $this->Structures->hook();
if ($hookLink) {
    require ($hookLink);
}

$this->Structures->build($finalAtimStructure, $finalOptions);