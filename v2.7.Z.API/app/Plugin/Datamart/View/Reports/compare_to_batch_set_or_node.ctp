<?php
if ($csvCreation) {
    // ------------------------------------------
    // EXPORT REPORT (CSV)
    // ------------------------------------------
    
    $settings = array();
    $this->Structures->build($atimStructureForResults, array(
        'type' => 'csv',
        'data' => $diffResultsData,
        'settings' => $settings
    ));
    exit();
} else {
    
    // ------------------------------------------
    // DISPLAY RESULT FORM
    // ------------------------------------------
    
    $structureLinks = array(
        'top' => '#',
        'checklist' => array(
            "$datamartStructureModelName.$datamartStructureKeyName][" => "%%$datamartStructureModelName.$datamartStructureKeyName%%"
        )
    );
    if (isset($datamartStructureLinks))
        $structureLinks['index'] = array(
            'details' => $datamartStructureLinks
        );
    
    $addToBatchsetHiddenField = $this->Form->input('Report.datamart_structure_id', array(
        'type' => 'hidden',
        'value' => $datamartStructureId
    ));
    
    $this->Structures->build($atimStructureForResults, array(
        'type' => 'index',
        'data' => $diffResultsData,
        'settings' => array(
            'form_bottom' => false,
            'header' => array(
                'title' => __('batchset and node elements distribution description'),
                'description' => __('compare') . ': ' . $header1 . ' & ' . $header2
            ),
            'form_inputs' => false,
            'actions' => false,
            'pagination' => false,
            'sorting' => array(
                $typeOfObjectToCompare,
                $batchSetOrNodeIdToCompare,
                0
            )
        ),
        'links' => $structureLinks,
        'extras' => array(
            'end' => $addToBatchsetHiddenField
        )
    ));
    
    // Actions
    
    $structureLinks = array(
        'top' => '#'
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
}

?>
<script type="text/javascript">
var datamartActions = true;
var errorYouMustSelectAnAction = "<?php echo __("you must select an action"); ?>";
var errorYouNeedToSelectAtLeastOneItem = "<?php echo __("you need to select at least one item"); ?>";
var menuItems = '<?php echo json_encode(Sanitize::clean($datamartStructureActions)); ?>';
var STR_SELECT_AN_ACTION = "<?php echo __('select an action'); ?>";
</script>