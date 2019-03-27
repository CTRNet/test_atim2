<?php
$this->request->data = array(
    array(
        'Merge' => array(
            'title' => __('collection')
        ),
        'custom' => array(
            'link' => '/Administrate/Merge/mergeCollections/'
        )
    ),
    array(
        'Merge' => array(
            'title' => __('participant')
        ),
        'custom' => array(
            'link' => '/Administrate/Merge/mergeParticipants/'
        )
    )
);
$this->Structures->build($atimStructure, array(
    'links' => array(
        'index' => array(
            'detail' => '%%custom.link%%'
        )
    ),
    'settings' => array(
        'pagination' => false
    )
));