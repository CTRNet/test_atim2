<?php
$structureLinks = array(
    'index' => array(
        'detail' => '/Tools/Template/edit/%%Template.id%%',
        'edit properties' => '/Tools/Template/editProperties/%%Template.id%%',
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