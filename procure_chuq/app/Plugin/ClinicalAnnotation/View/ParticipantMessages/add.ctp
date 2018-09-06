<?php
$structureLinks = array(
    'top' => '/ClinicalAnnotation/ParticipantMessages/add/' . $atimMenuVariables['Participant.id'] . '/',
    'bottom' => array(
        'cancel' => $urlToCancel
    )
);

// Set form structure and option

$finalAtimStructure = $atimStructure;
$finalOptions = array(
    'links' => $structureLinks,
    'extras' => $this->Form->text('participant_ids', array(
        "type" => "hidden",
        "id" => false,
        "value" => $participantIds
    )) . $this->Form->text('url_to_cancel', array(
        "type" => "hidden",
        "id" => false,
        "value" => $urlToCancel
    ))
);
if (! $atimMenuVariables['Participant.id']) {
    $finalOptions['settings'] = array(
        'header' => array(
            'title' => __('use/event creation'),
            'description' => __('you are about to create a message for %d participant(s)', substr_count($participantIds, ',') + 1)
        ),
        'confirmation_msg' => __('batch_edit_confirmation_msg')
    );
}

// CUSTOM CODE
$hookLink = $this->Structures->hook();
if ($hookLink) {
    require ($hookLink);
}

// BUILD FORM
$this->Structures->build($finalAtimStructure, $finalOptions);