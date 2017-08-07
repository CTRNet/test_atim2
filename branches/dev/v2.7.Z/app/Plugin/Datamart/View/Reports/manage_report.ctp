<?php
if (isset($searchFormStructure)) {
    
    // ------------------------------------------
    // DISPLAY SEARCH FORM
    // ------------------------------------------
    
    $structureLinks = array(
        'top' => array(
            'search' => '/Datamart/Reports/manageReport/' . $atimMenuVariables['Report.id']
        ),
        'bottom' => array(
            'reload form' => '/Datamart/Reports/manageReport/' . $atimMenuVariables['Report.id']
        )
    );
    
    $structureOverride = array();
    
    $finalAtimStructure = $searchFormStructure;
    $finalOptions = array(
        'type' => 'search',
        'links' => $structureLinks,
        'override' => $structureOverride
    );
    
    // CUSTOM CODE
    $hookLink = $this->Structures->hook();
    if ($hookLink) {
        require ($hookLink);
    }
    
    // BUILD FORM
    $this->Structures->build($finalAtimStructure, $finalOptions);
} else {
    
    // ------------------------------------------
    // DISPLAY RESULT FORM / EXPORT REPORT (CSV)
    // ------------------------------------------
    
    if ($csvCreation) {
        
        // ** EXPORT REPORT AS CSV **
        
        $k1 = array_keys($this->request->data);
        $k2 = array_keys($this->request->data[$k1[0]]);
        if (! is_array($this->request->data[$k1[0]][$k2[0]]) || ! empty($resultColumnsNames)) {
            // cast find first data into find all
            $this->request->data[0] = $this->request->data;
        }
        if (! empty($resultColumnsNames)) {
            $settings['columns_names'] = $resultColumnsNames;
        }
        $settings['all_fields'] = true;
        $this->Structures->build($resultFormStructure, array(
            'type' => 'csv',
            'data' => $this->request->data,
            'settings' => $settings
        ));
        exit();
    } else 
        if (isset($linkedDatamartStructureModelName) && isset($linkedDatamartStructureKeyName)) {
            
            // ** DISPLAY REPORT LINKED TO DATAMART STRUCTURE AND ACTIONS **
            
            // Report
            
            $structureLinks = array(
                'top' => '#',
                'checklist' => array(
                    "$linkedDatamartStructureModelName.$linkedDatamartStructureKeyName][" => "%%$linkedDatamartStructureModelName.$linkedDatamartStructureKeyName%%"
                )
            );
            if (isset($linkedDatamartStructureLinks))
                $structureLinks['index'] = array(
                    'details' => $linkedDatamartStructureLinks
                );
            
            $addToBatchsetHiddenField = $this->Form->input('Report.datamart_structure_id', array(
                'type' => 'hidden',
                'value' => $linkedDatamartStructureId
            ));
            
            $settings = array(
                'form_bottom' => false,
                'form_inputs' => false,
                'actions' => false,
                'pagination' => false,
                'sorting' => array(
                    $atimMenuVariables['Report.id'],
                    '0'
                )
            );
            if (! empty($resultHeader))
                $settings['header'] = $resultHeader;
            
            $this->Structures->build($resultFormStructure, array(
                'type' => 'index',
                'data' => $this->request->data,
                'settings' => $settings,
                'links' => $structureLinks,
                'extras' => array(
                    'end' => $addToBatchsetHiddenField
                )
            ));
            
            // Actions
            
            $structureLinks = array(
                'top' => '#'
            );
            if ($displayNewSearch)
                $structureLinks['bottom']['new search'] = array(
                    'link' => '/Datamart/Reports/manageReport/' . $atimMenuVariables['Report.id'],
                    'icon' => 'search'
                );
            
            $this->Structures->build(array(), array(
                'type' => 'add',
                'settings' => array(
                    'form_top' => false,
                    'header' => __('actions', null)
                ),
                'links' => $structureLinks,
                'data' => array(),
                'extras' => array(
                    'end' => '<div id="actionsTarget"></div>'
                )
            ));
        } else {
            
            // ** DISPLAY BASIC REPORT **
            
            $structureLinks = array(
                'bottom' => array(
                    'export as CSV file (comma-separated values)' => sprintf("javascript:setCsvPopup('Datamart/Reports/manageReport/" . $atimMenuVariables['Report.id'] . "/1/');", 0)
                )
            );
            if ($displayNewSearch)
                $structureLinks['bottom']['new search'] = array(
                    'link' => '/Datamart/Reports/manageReport/' . $atimMenuVariables['Report.id'],
                    'icon' => 'search'
                );
            
            $settings = array(
                'form_inputs' => false,
                'pagination' => false,
                'sorting' => array(
                    $atimMenuVariables['Report.id'],
                    '0'
                )
            );
            if (! empty($resultHeader))
                $settings['header'] = $resultHeader;
            if (! empty($resultColumnsNames))
                $settings['columns_names'] = $resultColumnsNames;
                
                // BUILD FORM
            $this->Structures->build($resultFormStructure, array(
                'type' => $resultFormType,
                'links' => $structureLinks,
                'settings' => $settings
            ));
        }
}

if (isset($linkedDatamartStructureActions)) {
    $linkedDatamartStructureActions = json_encode(stringCorrection(Sanitize::clean($linkedDatamartStructureActions)));
} else {
    $linkedDatamartStructureActions = "";
}
?>
<script type="text/javascript">
var datamartActions = true;
var errorYouMustSelectAnAction = "<?php echo __("you must select an action"); ?>";
var errorYouNeedToSelectAtLeastOneItem = "<?php echo __("you need to select at least one item"); ?>";
var menuItems = '<?php echo $linkedDatamartStructureActions; ?>';
var STR_SELECT_AN_ACTION = "<?php echo __('select an action'); ?>";
</script>
