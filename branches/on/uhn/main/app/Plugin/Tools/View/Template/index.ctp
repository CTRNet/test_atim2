<?php
$structureLinks = array(
    'index' => array(
        'edit' => '/Tools/Template/edit/%%Template.id%%',
        'delete' => '/Tools/Template/delete/%%Template.id%%'
    )
);

$finalAtimStructure = $atimStructure;
$finalOptions = array(
    'links' => $structureLinks,
    'settings' => array(
        'pagination' => true
    )
);

// CUSTOM CODE
$hookLink = $this->Structures->hook();
if ($hookLink) {
    require ($hookLink);
}

// BUILD FORM
$this->Structures->build($finalAtimStructure, $finalOptions);
