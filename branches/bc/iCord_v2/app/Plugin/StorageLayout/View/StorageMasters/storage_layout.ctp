<?php
ob_start();
?>
<div style="display: table; vertical-align: top;">
	<div style="display: table-row;" id="firstStorageRow"
		data-storage-url="<?php echo $this->here; ?>" data-ctrls="true">
		<div style="display: table-cell;" class='loading'>--- <?php echo __('loading'); ?>---</div>
	</div>
	<div style="display: table-row;">
		<div style="display: table-cell; padding: 10px 0;">
			<span class="button" id="btnPickStorage" style="width: 80%;"><?php echo(__("pick a storage to drag and drop to")); ?></span>
		</div>
	</div>
	<div style="display: table-row;" id="secondStorageRow"></div>
</div>
<?php
$content = ob_get_clean();

$bottom = array(
    'undo' => '/StorageLayout/StorageMasters/storageLayout/' . $atimMenuVariables['StorageMaster.id']
);
if (isset($addLinks)) {
    $bottom['add to storage'] = $addLinks;
}
$bottom['export as CSV file (comma-separated values)'] = sprintf("javascript:setCsvPopup('StorageLayout/StorageMasters/storageLayout/" . $atimMenuVariables['StorageMaster.id'] . "/0/1/');", 0);

$this->Structures->build($emptyStructure, array(
    'type' => 'detail',
    'extras' => $content,
    'links' => array(
        'top' => '/StorageLayout/StorageMasters/storageLayout/' . $atimMenuVariables['StorageMaster.id'],
        'bottom' => $bottom
    )
));
?>

<script>
var removeString = "<?php echo(__("remove")); ?>";
var unclassifyString = "<?php echo(__("unclassify")); ?>";
var detailString = "<?php echo(__("detail")); ?>";
var loadingStr = "<?php echo __("loading"); ?>";
var storageLayout = "storage_layout";
var STR_NAVIGATE_UNSAVED_DATA = "<?php echo __('STR_NAVIGATE_UNSAVED_DATA') ?>";
var STR_VALIDATION_ERROR = "<?php echo __('validation error'); ?>";
var STR_STORAGE_CONFLICT_MSG = "<?php echo __('storage_conflict_msg'); ?>";
</script>