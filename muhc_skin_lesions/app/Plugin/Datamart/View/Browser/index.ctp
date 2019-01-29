<?php
$structureLinks = array(
    "index" => array(
        'detail' => "/Datamart/Browser/browse/%%BrowsingIndex.root_node_id%%",
        'edit' => "/Datamart/Browser/edit/%%BrowsingIndex.id%%",
        'save' => array(
            'link' => "/Datamart/Browser/save/%%BrowsingIndex.id%%",
            'icon' => 'disk'
        ),
        'delete' => "/Datamart/Browser/delete/%%BrowsingIndex.id%%"
    ),
    "bottom" => array(
        "new" => "/Datamart/Browser/browse/"
    )
);

$settings = array(
    'header' => array(
        'title' => __('temporary browsing'),
        'description' => __('unsaved browsing trees that are automatically deleted when there are more than %d', $tmpBrowsingLimit)
    ),
    'form_bottom' => false,
    'actions' => false,
    'pagination' => false
);

$this->Structures->build($atimStructure, array(
    'data' => $tmpBrowsing,
    'type' => 'index',
    'links' => $structureLinks,
    'settings' => $settings
));

$settings = array(
    'header' => array(
        'title' => __('saved browsing'),
        'description' => __('saved browsing trees')
    ),
    'form_top' => false
);
unset($structureLinks['index']['save']);
$this->Structures->build($atimStructure, array(
    'data' => $this->request->data,
    'type' => 'index',
    'links' => $structureLinks,
    'settings' => $settings
));