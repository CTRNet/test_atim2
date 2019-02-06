<?php
if (! $isMainForm) {
    
    // Sub Form to display either Aliquots, sub-storages or tma slides list
    
    $structureSettings = array(
        'actions' => false
    );
    
    $structureLinks = array(
        'index' => array(
            'detail' => array(
                'link' => $detailUrl,
                'icon' => $icon
            )
        )
    );
    
    $finalAtimStructure = $atimStructure;
    $finalOptions = array(
        'type' => 'index',
        'settings' => $structureSettings,
        'links' => $structureLinks
    );
    
    // CUSTOM CODE
    $hookLink = $this->Structures->hook('list');
    if ($hookLink) {
        require ($hookLink);
    }
    
    // BUILD FORM
    $this->Structures->build($finalAtimStructure, $finalOptions);
} else {
    
    // Main form to display one to many lists
    
    if (isset($addLinks)) {
        $structureLinks = array(
            'bottom' => array(
                'add to storage' => $addLinks
            )
        );
    } else {
        $structureLinks = array();
    }
    
    $modelsNbr = sizeof($modelsToDispay);
    $formCounter = 0;
    foreach ($modelsToDispay as $model => $header) {
        $formCounter ++;
        $structureSettings = array(
            'actions' => ($formCounter == $modelsNbr) ? true : false,
            'header' => array(
                'title' => __($header),
                'description' => null
            )
        );
        
        $finalOptions = array(
            'type' => 'detail',
            'data' => array(),
            'settings' => $structureSettings,
            'links' => $structureLinks,
            'extras' => $this->Structures->ajaxIndex('StorageLayout/StorageMasters/contentListView/' . $atimMenuVariables['StorageMaster.id'] . '/' . $model)
        );
        $finalAtimStructure = $emptyStructure;
        
        // CUSTOM CODE
        $hookLink = $this->Structures->hook();
        if ($hookLink)
            require ($hookLink);
            
            // BUILD FORM
        $this->Structures->build($finalAtimStructure, $finalOptions);
    }
}