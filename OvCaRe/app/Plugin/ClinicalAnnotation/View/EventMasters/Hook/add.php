<?php 
	
	if($multi_add) {
		$final_options['settings']['add_fields'] = true;
		$final_options['settings']['del_fields'] = true;
		$final_options['settings']['paste_disabled_fields'] = array('EventDetail.test','EventDetail.result');
		$final_options['type'] = 'addgrid';
	}
	
?>
<script type="text/javascript">
var copyStr = "<?php echo(__("copy", null)); ?>";
var pasteStr = "<?php echo(__("paste")); ?>";
var copyingStr = "<?php echo(__("copying")); ?>";
var pasteOnAllLinesStr = "<?php echo(__("paste on all lines")); ?>";
var copyControl = true;
</script>	
<?php 
	
