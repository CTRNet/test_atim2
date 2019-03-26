<?php
if (isset($linkedRecordsHeaders)) {
    
    // Manage all lists display
    
    if ($linkedRecordsHeaders) {
        $counter = 0;
        foreach ($linkedRecordsProperties as $newListHeader => $value) {
            $model = $value[4];
            if (isset($studyLLData[$model]) && $studyLLData[$model]['active']==1){
                $counter ++;
                $finalOptions = array(
                    'type' => 'detail',
                    'links' => array(),
                    'settings' => array(
                        'header' => __($newListHeader, null),
                        'actions' => ($counter == sizeof($linkedRecordsHeaders)) ? true : false
                    ),
                    'extras' => array(
                        'end' => $this->Structures->ajaxIndex('Study/StudySummaries/listAllLinkedRecords/' . $atimMenuVariables['StudySummary.id'] . "/$newListHeader")
                    )
                );
                $finalAtimStructure = array();

                $hookLink = $this->Structures->hook();
                if ($hookLink) {
                    require ($hookLink);
                }

                $this->Structures->build($finalAtimStructure, $finalOptions);
            }
        }
        
        $formOptions = array(
            'type' => 'detail',
            'settings' => array(
                'form_bottom' => true
            ),
            'links' => array(
                'bottom' => array(
                    'cancel' => '/Study/StudySummaries/detail/'.$atimMenuVariables['StudySummary.id']
                )
                
            )
        );
        $this->Structures->build($emptyStructure, $formOptions);
    } else {
        $finalOptions = array(
            'type' => 'detail',
            'extras' => '<div>' . __('core_no_data_available') . '</div>'
        );
        $finalAtimStructure = array();
        
        $this->Structures->build($finalAtimStructure, $finalOptions);
    }
} else {
    
    // Specific list display
    
    if (! AppController::checkLinkPermission($permissionLink)) {
        $finalOptions = array(
            'type' => 'detail',
            'extras' => '<div>' . __('You are not authorized to access that location.') . '</div>'
        );
        $finalAtimStructure = array();
        $this->Structures->build($finalAtimStructure, $finalOptions);
    } else {
        $finalAtimStructure = $atimStructure;
        $finalOptions = array(
            'type' => 'index',
            'links' => array(
                'index' => array(
                    'detail' => $detailsUrl
                )
            ),
            'settings' => array(
                'pagination' => true,
                'actions' => false
            ),
            'override' => array()
        );
        $finalAtimStructure = $atimStructure;
        
        $hookLink = $this->Structures->hook('specific_list');
        if ($hookLink) {
            require ($hookLink);
        }
        
        $this->Structures->build($finalAtimStructure, $finalOptions);
    }
}