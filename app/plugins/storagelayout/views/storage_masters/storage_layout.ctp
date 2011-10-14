<?php
	ob_start();
?>
<div style="display: table; vertical-align: top;">
	<div style="display: table-row;" id="firstStorageRow">
		<div style="display: table-cell;" class='loading'>--- <?php __('loading'); ?>---</div>
	</div>
	<div style="display: table-row;">
		<div style="display: table-cell; padding: 10px 0;">
			<span class="button" id="btnPickStorage" style="width: 80%;"><?php echo(__("pick a storage to drag and drop to", true)); ?></span>
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
	/*vertical-align: top;*/
}
.mycell{
	padding: 5px;
}
.dragme{
	margin: 1px;
	padding: 2px;
	border-radius: 3px;
	cursor: move;
	backgroun-color: #ddd;
	background: -webkit-gradient(linear, left top, left bottom, from(#ddd), color-stop(50%, #eee), to(#bbb)); /* for webkit browsers */
	background: -moz-linear-gradient(top,  #ddd,  #eee, #bbb); /* for firefox 3.6+ */
}
ul.trash_n_unclass{
	margin-left: 10px;
}
li.trash_n_unclass{
	margin: 0 5px 5px 5px;
}
h4.ui-widget-header{
	height: 20px; 
	line-height: 20px; 
	font-size: 130%;"
}
span.help.storage{
	display: inline-block;
	height: 16px;
	width: 16px;
	float: right;
	margin: 2px;
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
