<?php
$this->Structures->build($atimStructure, array(
    'type' => 'batchedit',
    'links' => array(
        'top' => '/ClinicalAnnotation/Participants/batchEdit'
    ),
    'settings' => array(
        'header' => array(
            'title' => __('participants') . " - " . __('batch edit'),
            'description' => __('you are about to edit %d element(s)', count(explode(",", $this->request->data[0]['ids'])))
        ),
        'confirmation_msg' => __('batch_edit_confirmation_msg')
    )
));