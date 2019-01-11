<?php
$addLinks = array();
foreach ($reviewControls as $reviewControl) {
    $addLinks[__($reviewControl['SampleControl']['sample_type']) . ' - ' . __($reviewControl['SpecimenReviewControl']['review_type'])] = '/InventoryManagement/SpecimenReviews/add/' . $atimMenuVariables['Collection.id'] . '/' . $atimMenuVariables['SampleMaster.id'] . '/' . $reviewControl['SpecimenReviewControl']['id'];
}
ksort($addLinks);

$structureLinks = array(
    'index' => array(),
    'bottom' => array()
);
$structureLinks['index']['detail'] = '/InventoryManagement/SpecimenReviews/detail/' . $atimMenuVariables['Collection.id'] . '/' . $atimMenuVariables['SampleMaster.id'] . '/%%SpecimenReviewMaster.id%%';
$structureLinks['index']['edit'] = '/InventoryManagement/SpecimenReviews/edit/' . $atimMenuVariables['Collection.id'] . '/' . $atimMenuVariables['SampleMaster.id'] . '/%%SpecimenReviewMaster.id%%';
$structureLinks['index']['delete'] = '/InventoryManagement/SpecimenReviews/delete/' . $atimMenuVariables['Collection.id'] . '/' . $atimMenuVariables['SampleMaster.id'] . '/%%SpecimenReviewMaster.id%%';
if (! empty($addLinks)) {
    $structureLinks['bottom']['add'] = $addLinks;
}

$finalAtimStructure = $atimStructure;
$finalOptions = array(
    'type' => 'index',
    'links' => $structureLinks
);

// CUSTOM CODE
$hookLink = $this->Structures->hook();
if ($hookLink) {
    require ($hookLink);
}

// BUILD FORM
$this->Structures->build($finalAtimStructure, $finalOptions);