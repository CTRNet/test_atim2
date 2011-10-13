<?php
	ob_start();
?>
<div style="display: table;">
	<div style="display: table-row;" id="firstStorageRow">
	</div>
	<div style="display: table-row;">
		<div style="display: table-cell; padding: 10px;">
			<span class="button" id="btnPickStorage"><?php echo(__("pick a storage to drag and drop to", true)); ?></span>
		</div>
	</div>
	<div style="display: table-row;" id="secondStorageRow">
	</div>
</div>
<?php 
$content = ob_get_clean();

$structures->build($empty_structure, array(
	'type' => 'detail', 
	'extras' => $content, 
	'links' => array(
		'top' => '/storagelayout/storage_masters/storageLayout/'.$atim_menu_variables['StorageMaster.id'],
		'bottom' => array(
			'undo' => '/storagelayout/storage_masters/storageLayout/'.$atim_menu_variables['StorageMaster.id']
		)
	)
));
?>

<style type="text/css">
.dragme{
	list-style-type:none;
	clear: both;
}
.handle{
	cursor: move;
	vertical-align: top;
}
.mycell{
	padding: 5px;
}
.StorageMaster{
	color: #cc0000;
}
.AliquotMaster{
	color: #00cc00;
}
.TmaSlide{
	color: #0000cc;
}
</style>

<script>
var removeString = "<?php echo(__("remove")); ?>";
var unclassifyString = "<?php echo(__("unclassify")); ?>";
var detailString = "<?php echo(__("detail")); ?>";
var loadingStr = "<?php __("loading"); ?>";
var storageLayout = true;
var STR_NAVIGATE_UNSAVED_DATA = "<?php __('STR_NAVIGATE_UNSAVED_DATA') ?>";
</script>
