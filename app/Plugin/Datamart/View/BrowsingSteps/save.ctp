<?php
$form = $this->Structures->build($atimStructure, array(
    'type' => 'add',
    'links' => array(
        'top' => '/Datamart/BrowsingSteps/save/' . $nodeId
    ),
    'settings' => array(
        'header' => __('save browsing steps'),
        'return' => true
    )
));

$form = $this->Shell->validationErrors() . ob_get_contents() . $form;
$this->validationErrors = null;
$this->layout = 'json';
$this->json = array(
    'type' => 'form',
    'page' => $form
);