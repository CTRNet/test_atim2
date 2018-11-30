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

// 1 ** DISPLAY STORAGE FORM **

// Set links and settings
$structureLinks = array();
$settings = array();

// Basic
$structureLinks['bottom']['edit'] = '/StorageLayout/StorageMasters/edit/' . $atimMenuVariables['StorageMaster.id'];
// TODO: See issue#2702 $structureLinks['bottom']['add storage event to stored aliquots'] = '/InventoryManagement/AliquotMasters/addInternalUseToManyAliquots/' . $atimMenuVariables['StorageMaster.id'];
if ($isTma) {
    // No children storage could be added to a TMA block
    // Add button to create slide
    $structureLinks['bottom']['add tma slide'] = '/StorageLayout/TmaSlides/add/' . $atimMenuVariables['StorageMaster.id'];
} else {
    $structureLinks['bottom']['add to storage'] = $addLinks;
    $settings = array(
        'actions' => false
    );
}
$layoutUrl = str_replace('/detail/', '/storageLayout/', $this->here);

if (! empty($parentStorageId)) {
    $structureLinks['bottom']['see parent storage'] = '/StorageLayout/StorageMasters/detail/' . $parentStorageId;
}
$structureLinks['bottom']['delete'] = '/StorageLayout/StorageMasters/delete/' . $atimMenuVariables['StorageMaster.id'];

// Clean up based on form type
if ($isFromTreeViewOrLayout == 1) {
    // Display Detail From Tree view
    unset($structureLinks['bottom']['see parent storage']);
    unset($structureLinks['bottom']['search']);
    $settings = array(
        'header' => __($isTma ? 'TMA-blc' : 'storage')
    );
} elseif ($isFromTreeViewOrLayout == 2) {
    // Display Detail From Storage Layout
    $structureLinks = array();
    $structureLinks['bottom']['access to all data'] = '/StorageLayout/StorageMasters/detail/' . $atimMenuVariables['StorageMaster.id'];
    $settings = array(
        'header' => __($isTma ? 'TMA-blc' : 'storage')
    );
} elseif ($isTma) {
    // Main TMA Display
    $settings = array(
        'actions' => false
    );
}

$settings['no_sanitization']['StorageMaster'] = array(
    'layout_description'
);

// Set override
$structureOverride = array();

$finalAtimStructure = $atimStructure;
$finalOptions = array(
    'links' => $structureLinks,
    'override' => $structureOverride,
    'settings' => $settings
);

// CUSTOM CODE
$hookLink = $this->Structures->hook();
if ($hookLink) {
    require ($hookLink);
}

// BUILD FORM
$this->Structures->build($finalAtimStructure, $finalOptions);

if (! $isFromTreeViewOrLayout) {
    if ($isTma) {
        // 2 ** DISPLAY TMA SLIDES **
        
        $finalAtimStructure = array();
        $finalOptions = array(
            'links' => $structureLinks,
            'settings' => array(
                'header' => __('slides', null),
                'actions' => false
            ),
            'extras' => array(
                'end' => $this->Structures->ajaxIndex('StorageLayout/TmaSlides/listAll/' . $atimMenuVariables['StorageMaster.id'] . '/')
            )
        );
        
        // CUSTOM CODE
        $hookLink = $this->Structures->hook();
        if ($hookLink) {
            require ($hookLink);
        }
        
        // BUILD FORM
        $this->Structures->build($finalAtimStructure, $finalOptions);
    }
    
    // display layout
    $finalAtimStructure = array();
    if ($displayLayout) {
        $finalOptions['extras'] = '
				<div style="display: table; vertical-align: top;">
					<div style="display: table-row;" id="firstStorageRow" data-storage-url="' . $layoutUrl . '" data-ctrls="false">
						<div style="display: table-cell;" class="loading">---' . __('loading') . '---</div>
					</div>
				</div>';
        
        $finalOptions['links']['bottom'] = array_merge($finalOptions['links']['bottom'], array(
            'move storage content' => array(
                'link' => '/StorageLayout/StorageMasters/storageLayout/' . $atimMenuVariables['StorageMaster.id'],
                'icon' => 'edit'
            ),
            'export as CSV file (comma-separated values)' => sprintf("javascript:setCsvPopup('StorageLayout/StorageMasters/storageLayout/" . $atimMenuVariables['StorageMaster.id'] . "/0/1/');", 0)
        ));
    } else {
        $finalOptions['extras'] = __('no layout exists');
    }
    $finalOptions['settings']['header'] = __('storage layout');
    $finalOptions['settings']['actions'] = true;
    $hookLink = $this->Structures->hook();
    if ($hookLink) {
        require ($hookLink);
    }
    $this->Structures->build($finalAtimStructure, $finalOptions);
}
?>

<script>
var removeString = "<?php echo(__("remove")); ?>";
var unclassifyString = "<?php echo(__("unclassify")); ?>";
var detailString = "<?php echo(__("detail")); ?>";
var loadingStr = "<?php echo __("loading"); ?>";
var storageLayout = "detail";
</script>