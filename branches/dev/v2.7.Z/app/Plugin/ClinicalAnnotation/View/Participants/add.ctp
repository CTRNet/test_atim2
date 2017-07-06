<?php
$structureLinks = array(
    'top' => '/ClinicalAnnotation/Participants/add',
    'bottom' => array(
        'cancel' => '/ClinicalAnnotation/Participants/search'
    )
);

// Set form structure and option
$finalAtimStructure = $atimStructure;
$finalOptions = array(
    'links' => $structureLinks
);

// CUSTOM CODE
$hookLink = $this->Structures->hook();
if ($hookLink) {
    require ($hookLink);
}
//debug($finalAtimStructure);
//debug(get_defined_vars( ));
// BUILD FORM
$this->Structures->build($finalAtimStructure, $finalOptions);