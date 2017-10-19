<?php
$structureLinks = array();
$this->Structures->build($atimStructure, array(
    'type' => 'detail',
    'data' => $this->request->data[0],
    'settings' => array(
        'actions' => false
    )
));

unset($this->request->data[0]);
$this->Structures->build($atimStructure, array(
    'type' => 'index',
    'data' => $this->request->data,
    'settings' => array(
        'header' => __('previous versions'),
        'pagination' => false
    )
));