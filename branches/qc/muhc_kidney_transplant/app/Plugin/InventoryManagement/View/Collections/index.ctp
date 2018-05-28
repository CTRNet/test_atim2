<?php
$structureOverride = array();

$dropdown = null;
$displaySearchSection = true;
if (isset($isCclAjax)) {
    $displaySearchSection = false;
    // force participant collection
    foreach ($atimStructure['Sfs'] as &$field) {
        if ($field['field'] == "collection_property") {
            $field['flag_search_readonly'] = true;
            break;
        }
    }
    $structureOverride['ViewCollection.collection_property'] = "participant collection";
    $dropdown['ViewCollection.collection_property'] = array(
        "participant collection" => __("participant collection")
    );
    $last5 = "";
} else {
    $settings = array();
    $finalAtimStructure = $atimStructure;
    include ('search_links_n_options.php');
    $finalOptions['settings']['return'] = true;
    $finalOptions['settings']['pagination'] = false;
    $finalOptions['settings']['actions'] = false;
    if (isset($this->request->query['nolatest'])) {
        $last5 = "";
        $displaySearchSection = false;
    } else {
        $last5 = $this->Structures->build($finalAtimStructure, $finalOptions);
    }
}

$settings = array(
    'header' => array(
        'title' => __('search type', null) . ': ' . __('collections', null),
        'description' => __("more information about the types of samples and aliquots are available %s here", $helpUrl)
    ),
    'actions' => false
);

$finalAtimStructure = $atimStructure;
$finalOptions = array(
    'type' => 'search',
    'links' => array(
        'top' => '/InventoryManagement/Collections/search/' . AppController::getNewSearchId()
    ),
    'override' => $structureOverride,
    'settings' => $settings
);
if ($dropdown !== null) {
    $finalOptions['dropdown_options'] = $dropdown;
}

$finalAtimStructure2 = $emptyStructure;
$finalOptions2 = array(
    'links' => isset($isCclAjax) ? array() : array(
        'bottom' => array(
            'add collection' => '/InventoryManagement/Collections/add'
        )
    ),
    'extras' => '<div class="ajax_search_results"></div><div class="ajax_search_results_default">' . $last5 . '</div>'
);

// CUSTOM CODE
$hookLink = $this->Structures->hook();
if ($hookLink) {
    require ($hookLink);
}

// BUILD FORM
$this->Structures->build($finalAtimStructure, $finalOptions);

if ($displaySearchSection) {
    $this->Structures->build($finalAtimStructure2, $finalOptions2);
}