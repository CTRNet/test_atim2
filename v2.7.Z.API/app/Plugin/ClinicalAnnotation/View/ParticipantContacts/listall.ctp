<?php
$structure_links = array(
	'top' => null,
	'index' => '/ClinicalAnnotation/ParticipantContacts/detail/' . $atimMenuVariables['Participant.id'] . '/%%ParticipantContact.id%%',
	'bottom' => array(
		'add' => '/ClinicalAnnotation/ParticipantContacts/add/' . $atimMenuVariables['Participant.id'] . '/'
	)
);

// Set form structure and option
$finalAtimStructure = $atimStructure;
$finalOptions = array('type' => 'index', 'links' => $structure_links);

// CUSTOM CODE
$hookLink = $this->Structures->hook();
if ($hookLink) {
	require($hookLink);
}

// BUILD FORM
$this->Structures->build($finalAtimStructure, $finalOptions);