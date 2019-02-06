<?php
$this->Structures->build($atimStructure, array(
    'type' => 'edit',
    'links' => array(
        'top' => '/Datamart/BrowsingSteps/edit/' . $atimMenuVariables['SavedBrowsingIndex.id'],
        'bottom' => array(
            'cancel' => '/Datamart/BrowsingSteps/listall/',
            'reset' => array(
                'link' => '/Datamart/BrowsingSteps/edit/' . $atimMenuVariables['SavedBrowsingIndex.id'],
                'icon' => 'redo'
            )
        )
    )
));