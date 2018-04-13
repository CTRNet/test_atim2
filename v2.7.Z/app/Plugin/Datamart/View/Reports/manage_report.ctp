<?php
$chartSetting ='""';
$charts ="";
$chartJS = '""';
if (isset($this->request->data['data'])) {
    $charts = (isset($this->request->data['charts'])) ? $this->request->data['charts'] : "";
    $chartSetting = (isset($this->request->data['setting'])) ? $this->request->data['setting'] : '""';
    $chartJS = json_encode($charts) . "\r\n";
    $this->request->data = $this->request->data['data'];
}

if (isset($searchFormStructure)) {

    // ------------------------------------------
    // DISPLAY SEARCH FORM
    // ------------------------------------------

    $structureLinks = array(
        'top' => array(
            'search' => '/Datamart/Reports/manageReport/' . $atimMenuVariables['Report.id']
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
        foreach ($resultFormStructureAccuracy as $structureModel => $structureFieldsData) {
            foreach ($structureFieldsData as $structureField => $structureFieldAccuracy) {
                $resultFormStructure['Accuracy'][$structureModel][$structureField] = $structureFieldAccuracy;
            }
        }
    }

    if ($csvCreation) {

        // ** EXPORT REPORT AS CSV **

        $k1 = array_keys($this->request->data);
        $k2 = array_keys($this->request->data[$k1[0]]);
        if (!is_array($this->request->data[$k1[0]][$k2[0]]) || !empty($resultColumnsNames)) {
            // cast find first data into find all
            $this->request->data[0] = $this->request->data;
        }
        if (!empty($resultColumnsNames)) {
            $settings['columns_names'] = $resultColumnsNames;
        }
        $settings['all_fields'] = true;
        $this->Structures->build($resultFormStructure, array(
            'type' => 'csv',
            'data' => $this->request->data,
            'settings' => $settings
        ));
        exit();
    } elseif (isset($linkedDatamartStructureModelName) && isset($linkedDatamartStructureKeyName)) {

        if ($chartJS != '""' && (isset($chartSetting['top']) && !$chartSetting['top'])) {
            drawCharts($this, $charts, $chartSetting);
        }

        // ** DISPLAY REPORT LINKED TO DATAMART STRUCTURE AND ACTIONS **
        // Report
        
        if (!empty($this->request->data)) {
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
                'header' => __('report data table'),
                'sorting' => array(
                    $atimMenuVariables['Report.id'],
                    '0'
                )
            );
            if (!empty($resultHeader)) {
                $settings['header'] = $resultHeader;
            }

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

            if ($chartJS != '""' && (!isset($chartSetting['top']) || $chartSetting['top'])) {
                drawCharts($this, $charts, $chartSetting);
            }            
            
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
        }else{
            if ($chartJS != '""' && (!isset($chartSetting['top']) || $chartSetting['top'])) {
                drawCharts($this, $charts, $chartSetting);
            }
        }
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
        if (!empty($resultHeader))
            $settings['header'] = $resultHeader;
        if (!empty($resultColumnsNames))
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

function drawCharts($thisHelper, $charts, $chartSetting)
{
    $emptyStructure = array(
        'Structure' =>
        array(
            array(
                'id' => 210,
                'alias' => 'empty',
                'description' => false,
                'CodingIcdCheck' => false
            ),
            'CodingIcdCheck' => false
        ),
        'Sfs' => array(),
        'Accuracy' => array()
    );
    
    if (is_array($charts)) {
        $settings = array(
            'form_bottom' => false,
            'form_inputs' => false,
            'actions' => false,
            'pagination' => false,
            'header' => __('diagram'),
        );
        $title = array();
        $type = array();
        foreach ($charts as $c=>$chart){
            $title[]=$chart['title'];
            $type[]=$chart['type'];
        }
        $thisHelper->Structures->build($emptyStructure, array(
            'type' => 'chart',
            'chartSettings' => $chartSetting,
            'chartsType' => $type,
            'number' => (is_array($charts))?count($charts):0,
            'titles' => $title,
            'settings' => $settings,
        ));
    }

}
?>
<script type="text/javascript">
    var datamartActions = true;
    var errorYouMustSelectAnAction = "<?php echo __("you must select an action"); ?>";
    var errorYouNeedToSelectAtLeastOneItem = "<?php echo __("you need to select at least one item"); ?>";
    var menuItems = '<?php echo $linkedDatamartStructureActions; ?>';
    var STR_SELECT_AN_ACTION = "<?php echo __('select an action'); ?>";

    var charts = <?php echo $chartJS; ?>;
    var chartsSettings = <?php echo json_encode($chartSetting); ?>;
</script>
<?php
echo $this->Html->script('charts.js') . "\n"; //Chart