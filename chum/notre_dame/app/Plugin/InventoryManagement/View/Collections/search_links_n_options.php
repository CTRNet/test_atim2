<?php
$structureLinks = array(
    'index' => array(
        'detail' => '/InventoryManagement/Collections/detail/%%ViewCollection.collection_id%%',
        'copy for new collection' => array(
            'link' => '/InventoryManagement/Collections/add/0/%%ViewCollection.collection_id%%',
            'icon' => 'duplicate'
        )
    ),
    'bottom' => array(
        'add collection' => '/InventoryManagement/Collections/add'
    )
);
$finalOptions = array(
    'type' => 'index',
    'data' => $this->request->data,
    'links' => $structureLinks,
    'settings' => $settings
);
// CUSTOM CODE
$hookLink = $this->Structures->hook();
if ($hookLink) {
    require ($hookLink);
}