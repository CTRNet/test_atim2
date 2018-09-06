<?php
$structureLinks = array(
    'top' => '/InventoryManagement/SampleMasters/edit/' . $atimMenuVariables['Collection.id'] . '/' . $atimMenuVariables['SampleMaster.id'],
    'bottom' => array(
        'cancel' => '/InventoryManagement/SampleMasters/detail/' . $atimMenuVariables['Collection.id'] . '/' . $atimMenuVariables['SampleMaster.id']
    )
);

$structureOverride = array();
$dropdownOptions = array(
    'SampleMaster.parent_id' => (isset($parentSampleDataForDisplay) && (! empty($parentSampleDataForDisplay))) ? $parentSampleDataForDisplay : array(
        '' => ''
    ),
    'DerivativeDetail.lab_book_master_id' => (isset($labBooksList) && (! empty($labBooksList))) ? $labBooksList : array(
        '' => ''
    )
);

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
var labBookFields = new Array(<?php echo '"'.implode('", "', $labBookFields).'"'; ?>);
</script>