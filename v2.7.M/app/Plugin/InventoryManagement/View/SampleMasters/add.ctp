<?php
 /**
 *
 * ATiM - Advanced Tissue Management Application
 * Copyright (c) Canadian Tissue Repository Network (http://www.ctrnet.ca)
 *
 * Licensed under GNU General Public License
 * For full copyright and license information, please see the LICENSE.txt
 * Redistributions of files must retain the above copyright notice.
 *
 * @author        Canadian Tissue Repository Network <info@ctrnet.ca>
 * @copyright     Copyright (c) Canadian Tissue Repository Network (http://www.ctrnet.ca)
 * @link          http://www.ctrnet.ca
 * @since         ATiM v 2
 * @license       http://www.gnu.org/licenses  GNU General Public License
 */
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
$dropdownOptions = array(
    'SampleMaster.parent_id' => $sampleParentId,
    'DerivativeDetail.lab_book_master_id' => (isset($labBooksList) && (! empty($labBooksList))) ? $labBooksList : array(
        '' => ''
    )
);

$structureOverride = array();
if (isset($templateNodeDefaultValues)) {
    $templateNodeDefaultValues = array_filter($templateNodeDefaultValues, function ($var) {
        return (! ($var == '' || is_null($var)));
    });
    $structureOverride = array_merge($structureOverride, $templateNodeDefaultValues);
}
$args = AppController::getInstance()->passedArgs;
if (isset($args['templateInitId'])) {
    $templateInitDefaultValues = Set::flatten(AppController::getInstance()->Session->read('Template.init_data.' . $args['templateInitId']));
    $templateInitDefaultValues = array_filter($templateInitDefaultValues, function ($var) {
        return (! ($var == '' || is_null($var)));
    });
    $structureOverride = array_merge($structureOverride, $templateInitDefaultValues);
}
if (! $isSpecimen) {
    $structureOverride = array_merge($structureOverride, array(
        'SampleMaster.parent_id' => key($sampleParentId)
    ));
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
var labBookFields = new Array(<?php echo '"'.implode('", "', $labBookFields).'"'; ?>);
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