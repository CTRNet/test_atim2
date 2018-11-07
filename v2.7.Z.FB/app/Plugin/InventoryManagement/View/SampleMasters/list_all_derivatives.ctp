<?php
if (isset($derivativesData)) {
    $structureLinks = array();
    $structureLinks['index']['detail'] = '/InventoryManagement/SampleMasters/detail/%%Collection.id%%/%%SampleMaster.id%%';
    $structureLinks['index']['edit'] = '/InventoryManagement/SampleMasters/edit/%%Collection.id%%/%%SampleMaster.id%%';
    $structureLinks['index']['delete'] = '/InventoryManagement/SampleMasters/delete/%%Collection.id%%/%%SampleMaster.id%%';
    
    $hookLink = $this->Structures->hook();
    if ($hookLink) {
        require ($hookLink);
    }
    
    $i = 0;
    $arrSize = count($derivativesData);
    $hookLink = $this->Structures->hook('unit');
    foreach ($derivativesData as $sampleControlId => $derivatives) {
        $finalAtimStructure = $derivativesStructures[$sampleControlId];
        $finalOptions = array(
            'type' => 'index',
            'links' => $structureLinks,
            'dropdown_options' => array(),
            'data' => $derivatives,
            'settings' => array(
                'language_heading' => __($derivatives[0]['SampleControl']['sample_type']),
                'header' => array(),
                'actions' => ++ $i == $arrSize,
                'pagination' => false
            )
        );
        
        // CUSTOM CODE
        if ($hookLink) {
            require ($hookLink);
        }
        
        // BUILD FORM
        $this->Structures->build($finalAtimStructure, $finalOptions);
    }
} else {
    
    // Display empty form
    
    $finalAtimStructure = $noDataStructure;
    $finalOptions = array(
        'type' => 'index',
        'data' => array(),
        'settings' => array(
            'pagination' => false
        )
    );
    
    // CUSTOM CODE
    $hookLink = $this->Structures->hook('empty');
    if ($hookLink) {
        require ($hookLink);
    }
    
    // BUILD FORM
    $this->Structures->build($finalAtimStructure, $finalOptions);
}