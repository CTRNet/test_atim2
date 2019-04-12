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
$structureLinks = array(
    'top' => '/InventoryManagement/SpecimenReviews/add/' . $atimMenuVariables['Collection.id'] . '/' . $atimMenuVariables['SampleMaster.id'] . '/' . $atimMenuVariables['SpecimenReviewControl.id'] . '/',
    'bottom' => array(
        'cancel' => '/InventoryManagement/SpecimenReviews/listAll/' . $atimMenuVariables['Collection.id'] . '/' . $atimMenuVariables['SampleMaster.id'] . '/'
    )
);

// 1- SPECIMEN REVIEW

$structureSettings = array(
    'actions' => ($isAliquotReviewDefined ? false : true),
    'tabindex' => '1000',
    'header' => __($reviewControlData['SampleControl']['sample_type'], null) . ' - ' . __($reviewControlData['SpecimenReviewControl']['review_type'], null),
    'form_bottom' => ($isAliquotReviewDefined ? false : true)
);

$finalAtimStructure = $specimenReviewStructure;
$finalOptions = array(
    'settings' => $structureSettings,
    'links' => $structureLinks,
    'data' => $specimenReviewData
);

$hookLink = $this->Structures->hook('specimen_review');
if ($hookLink) {
    require ($hookLink);
}

$this->Structures->build($finalAtimStructure, $finalOptions);

if ($isAliquotReviewDefined) {
    // 2- SEPARATOR & HEADER
    
    $structureSettings = array(
        'actions' => false,
        'tabindex' => '2000',
        'header' => __('aliquot review', null),
        'form_top' => false,
        'form_bottom' => false
    );
    
    $this->Structures->build($emptyStructure, array(
        'settings' => $structureSettings
    ));
    
    // 3- ALIQUOT REVIEW
    
    $structureSettings = array(
        'tabindex' => '3000',
        'pagination' => false,
        'add_fields' => true,
        'del_fields' => true,
        'form_top' => false
    );
    
    $dropdownOptions['AliquotReviewMaster.aliquot_master_id'] = $aliquotList;
    
    $finalAtimStructure = $aliquotReviewStructure;
    $finalOptions = array(
        'links' => $structureLinks,
        'data' => $aliquotReviewData,
        'type' => 'addgrid',
        'settings' => $structureSettings,
        'dropdown_options' => $dropdownOptions
    );
    
    $hookLink = $this->Structures->hook('aliquot_review');
    if ($hookLink) {
        require ($hookLink);
    }
    
    $this->Structures->build($finalAtimStructure, $finalOptions);
}

?>

<div id="debug"></div>
<script type="text/javascript">
var copyStr = "<?php echo(__("copy", null)); ?>";
var pasteStr = "<?php echo(__("paste")); ?>";
var copyingStr = "<?php echo(__("copying")); ?>";
var pasteOnAllLinesStr = "<?php echo(__("paste on all lines")); ?>";
var copyControl = true;
</script>