<?php
$structureLinks = array(
    'index' => array(
        'edit' => '/StorageLayout/TmaSlideUses/edit/%%TmaSlideUse.id%%',
        'delete' => '/StorageLayout/TmaSlideUses/delete/%%TmaSlideUse.id%%'
    )
);

$finalAtimStructure = $atimStructure;
$finalOptions = array(
    'type' => 'index',
    'links' => $structureLinks
);

// CUSTOM CODE
$hookLink = $this->Structures->hook();
if ($hookLink) {
    require ($hookLink);
}

// BUILD FORM
$this->Structures->build($finalAtimStructure, $finalOptions);