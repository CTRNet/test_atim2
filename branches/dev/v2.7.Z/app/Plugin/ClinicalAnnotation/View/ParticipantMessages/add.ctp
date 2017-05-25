<?php
$structure_links = array(
    'top' => '/ClinicalAnnotation/ParticipantMessages/add/' . $atim_menu_variables['Participant.id'] . '/',
    'bottom' => array(
        'cancel' => $url_to_cancel
    )
);

// Set form structure and option

$final_atim_structure = $atim_structure;
$final_options = array(
    'links' => $structure_links,
    'extras' => $this->Form->text('participant_ids', array(
        "type" => "hidden",
        "id" => false,
        "value" => $participant_ids
    )) . $this->Form->text('url_to_cancel', array(
        "type" => "hidden",
        "id" => false,
        "value" => $url_to_cancel
    ))
);
if (! $atim_menu_variables['Participant.id']) {
    $final_options['settings'] = array(
        'header' => array(
            'title' => __('use/event creation'),
            'description' => __('you are about to create a message for %d participant(s)', substr_count($participant_ids, ',') + 1)
        ),
        'confirmation_msg' => __('batch_edit_confirmation_msg')
    );
}

// CUSTOM CODE
$hook_link = $this->Structures->hook();
if ($hook_link) {
    require ($hook_link);
}

// BUILD FORM
$this->Structures->build($final_atim_structure, $final_options);
?>