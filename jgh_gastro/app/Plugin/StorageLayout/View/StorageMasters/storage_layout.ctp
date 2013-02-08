<?php
	ob_start();
?>
<div style="display: table; vertical-align: top;">
	<div style="display: table-row;" id="firstStorageRow">
		<div style="display: table-cell;" class='loading'>--- <?php echo __('loading'); ?>---</div>
	</div>
	<div style="display: table-row;">
		<div style="display: table-cell; padding: 10px 0;">
			<span class="button" id="btnPickStorage" style="width: 80%;"><?php echo(__("pick a storage to drag and drop to")); ?></span>
		</div>
	</div>
	<div style="display: table-row;" id="secondStorageRow">
	</div>
</div>
<?php 
$content = ob_get_clean();

$this->Structures->build($empty_structure, array(
	'type' => 'detail', 
	'extras' => $content, 
	'links' => array(
		'top' => '/StorageLayout/StorageMasters/storageLayout/'.$atim_menu_variables['StorageMaster.id'],
		'bottom' => array(
			'undo' => '/StorageLayout/StorageMasters/storageLayout/'.$atim_menu_variables['StorageMaster.id']
		)
	)
));
?>

<script>
var removeString = "<?php echo(__("remove")); ?>";
var unclassifyString = "<?php echo(__("unclassify")); ?>";
var detailString = "<?php echo(__("detail")); ?>";
var loadingStr = "<?php echo __("loading"); ?>";
var storageLayout = true;
var STR_NAVIGATE_UNSAVED_DATA = "<?php echo __('STR_NAVIGATE_UNSAVED_DATA') ?>";
var STR_VALIDATION_ERROR = "<?php echo __('validation error'); ?>";
var STR_STORAGE_CONFLICT_MSG = "<?php echo __('storage_conflict_msg'); ?>";
</script>
