<?php
$this->Structures->build($atimStructure, array(
    'type' => 'add',
    'links' => array(
        'top' => 'javascript:savePreset();'
    ),
    'settings' => array(
        'header' => __('save preset'),
        'tabindex' => 100
    )
));