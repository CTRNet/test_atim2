<?php
if ($typeOfList) {
    
    // Specific batch sets list
    
    $structureLinks = array(
        'index' => array(
            'detail' => '/Datamart/BatchSets/listall/%%BatchSet.id%%',
            'edit' => '/Datamart/BatchSets/edit/%%BatchSet.id%%',
            'save' => array(
                'link' => '/Datamart/BatchSets/save/%%BatchSet.id%%',
                'icon' => 'disk'
            ),
            'delete' => '/Datamart/BatchSets/delete/%%BatchSet.id%%'
        ),
        'bottom' => array()
    );
    if ($typeOfList != 'temporary') {
        unset($structureLinks['index']['save']);
    }
    
    $finalAtimStructure = $atimStructure;
    $finalOptions = array(
        'type' => 'index',
        'links' => $structureLinks,
        'settings' => array(
            'pagination' => true,
            'actions' => false
        ),
        'override' => array()
    );
    
    $hookLink = $this->Structures->hook('specific');
    if ($hookLink) {
        require ($hookLink);
    }
    
    $this->Structures->build($finalAtimStructure, $finalOptions);
} else {
    
    // Manage list display
    
    $structureLinks = array(
        'index' => array(),
        'bottom' => array(
            'delete in batch' => array(
                'link' => '/Datamart/BatchSets/deleteInBatch',
                'icon' => 'delete noPrompt'
            )
        )
    );
    
    $listData = array(
        'temporary' => 'temporary batch sets',
        'saved' => 'saved batch sets',
        'all' => 'all batch sets'
    );
    
    $counter = 0;
    foreach ($listData as $typeOfList => $header) {
        $counter ++;
        
        $finalAtimStructure = array();
        $finalOptions = array(
            'type' => 'detail',
            'links' => $structureLinks,
            'settings' => array(
                'header' => __($header, null),
                'actions' => ($counter == sizeof($listData)) ? true : false
            ),
            'extras' => $this->Structures->ajaxIndex('Datamart/BatchSets/index/' . $typeOfList)
        );
        
        $displayNextForm = true;
        
        // CUSTOM CODE
        $hookLink = $this->Structures->hook('all');
        if ($hookLink) {
            require ($hookLink);
        }
        
        // BUILD FORM
        if ($displayNextForm)
            $this->Structures->build($finalAtimStructure, $finalOptions);
    }
}