<?php
$structureLinks = array(
    'top' => null,
    'index' => array(
        'detail' => '/ClinicalAnnotation/ParticipantContacts/detail/' . $atimMenuVariables['Participant.id'] . '/%%ParticipantContact.id%%',
        'edit' => '/ClinicalAnnotation/ParticipantContacts/edit/' . $atimMenuVariables['Participant.id'] . '/%%ParticipantContact.id%%',
        'delete' => '/ClinicalAnnotation/ParticipantContacts/delete/' . $atimMenuVariables['Participant.id'] . '/%%ParticipantContact.id%%'
    ),
    'bottom' => array(
        'add' => '/ClinicalAnnotation/ParticipantContacts/add/' . $atimMenuVariables['Participant.id'] . '/'
    )
);

// Set form structure and option
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