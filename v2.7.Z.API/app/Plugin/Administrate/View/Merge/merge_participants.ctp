<?php
if (isset($validationError)) {
    $this->validationErrors = array(
        'model' => array(
            $validationError
        )
    );
}

$links = array(
    'top' => '/Administrate/Merge/mergeParticipants/',
    'bottom' => array(
        'cancel' => '/Administrate/Merge/index/'
    )
);
$this->Structures->build(array(), array(
    'type' => 'detail',
    'settings' => array(
        'header' => array(
            'title' => __('merge participant'),
            'description' => __('merge_part_desc')
        ),
        'actions' => false,
        'form_bottom' => false
    ),
    'extras' => array(
        'end' => $this->Structures->generateSelectItem('ClinicalAnnotation/Participants/search/', 'from')
    ),
    'links' => $links
));
$this->Structures->build(array(), array(
    'type' => 'detail',
    'settings' => array(
        'header' => array(
            'title' => __('into participant'),
            'description' => __('merge_part_into_desc'),
            'form_bottom' => true
        ),
        'confirmation_msg' => __('merge_confirmation_msg')
    ),
    'extras' => array(
        'end' => $this->Structures->generateSelectItem('ClinicalAnnotation/Participants/search/', 'to')
    ),
    'links' => $links
));