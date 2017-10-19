<?php
if ($isAjax) {
    ob_start();
}

$structureLinks = array(
    'top' => '/InventoryManagement/SampleMasters/add/' . $atimMenuVariables['Collection.id'] . '/' . $sampleControlData['SampleControl']['id'] . '/' . $parentSampleMasterId
);

if ($isAjax) {
    $structureLinks['top'] .= '/1';
} else {
    $structureLinks['bottom'] = array(
        'cancel' => empty($parentSampleMasterId) ? '/InventoryManagement/Collections/detail/' . $atimMenuVariables['Collection.id'] : '/InventoryManagement/SampleMasters/detail/' . $atimMenuVariables['Collection.id'] . '/' . $parentSampleMasterId . '/'
    );
}

$sampleParentId = (isset($parentSampleDataForDisplay) && (! empty($parentSampleDataForDisplay))) ? $parentSampleDataForDisplay : array(
    '' => ''
);
$structureOverride = $isSpecimen ? array() : array(
    'SampleMaster.parent_id' => key($sampleParentId)
);
$dropdownOptions = array(
    'SampleMaster.parent_id' => $sampleParentId,
    'DerivativeDetail.lab_book_master_id' => (isset($labBooksList) && (! empty($labBooksList))) ? $labBooksList : array(
        '' => ''
    )
);

$args = AppController::getInstance()->passedArgs;
if (isset($args['templateInitId'])) {
    $structureOverride = array_merge(Set::flatten(AppController::getInstance()->Session->read('Template.init_data.' . $args['templateInitId'])), $structureOverride);
}

$finalAtimStructure = $atimStructure;
$finalOptions = array(
    'links' => $structureLinks,
    'override' => $structureOverride,
    'dropdown_options' => $dropdownOptions
);

// CUSTOM CODE
$hookLink = $this->Structures->hook();
if ($hookLink) {
    require ($hookLink);
}

// BUILD FORM
$this->Structures->build($finalAtimStructure, $finalOptions);
?>
<script>
var labBookFields = new Array"<?php echo implode('", "', $labBookFields); ?>");
</script>

<?php
if ($isAjax) {
    $display = $this->Shell->validationErrors() . ob_get_contents();
    ob_end_clean();
    $this->layout = 'json';
    $this->json = array(
        'goToNext' => false,
        'page' => $display,
        'id' => null
    );
}