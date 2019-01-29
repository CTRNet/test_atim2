<?php
if (isset($validationError)) {
    $this->validationErrors = array(
        'model' => array(
            $validationError
        )
    );
}

$links = array(
    'top' => '/Administrate/Merge/mergeCollections/',
    'bottom' => array(
        'cancel' => '/Administrate/Merge/index/'
    )
);
$this->Structures->build(array(), array(
    'type' => 'detail',
    'settings' => array(
        'header' => array(
            'title' => __('merge collection'),
            'description' => __('merge_coll_desc')
        ),
        'actions' => false,
        'form_bottom' => false
    ),
    'extras' => array(
        'end' => $this->Structures->generateSelectItem('InventoryManagement/Collections/search?nolatest=', 'from')
    ),
    'links' => $links
));
$this->Structures->build(array(), array(
    'type' => 'detail',
    'settings' => array(
        'header' => array(
            'title' => __('into collection'),
            'description' => __('merge_coll_into_desc'),
            'form_bottom' => true
        ),
        'confirmation_msg' => __('merge_confirmation_msg')
    ),
    'extras' => array(
        'end' => $this->Structures->generateSelectItem('InventoryManagement/Collections/search?nolatest=', 'to')
    ),
    'links' => $links
));