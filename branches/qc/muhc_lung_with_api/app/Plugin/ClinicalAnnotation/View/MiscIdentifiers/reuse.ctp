<?php
$finalAtimStructure = $atimStructure;
$finalOptions = array(
    'type' => 'index',
    'settings' => array(
        'pagination' => false,
        'form_inputs' => false,
        'header' => array(
            'title' => $title,
            'description' => __('select an identifier to assign to the current participant')
        )
    ),
    'links' => array(
        'radiolist' => array(
            'MiscIdentifier.selected_id' => '%%MiscIdentifier.id%%'
        ),
        'bottom' => array(
            'cancel' => '/ClinicalAnnotation/Participants/profile/' . $atimMenuVariables['Participant.id']
        ),
        'top' => '/ClinicalAnnotation/MiscIdentifiers/reuse/' . $atimMenuVariables['Participant.id'] . '/' . $atimMenuVariables['MiscIdentifierControl.id'] . '/1/'
    )
);

$hookLink = $this->Structures->hook();
if ($hookLink) {
    require ($hookLink);
}
$this->Structures->build($atimStructure, $finalOptions);