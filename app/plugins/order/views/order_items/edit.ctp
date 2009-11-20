<?php 
	$structure_links = array(
		'top'=>'/order/order_items/edit/'.$atim_menu_variables['Order.id'].'/'.$atim_menu_variables['OrderLine.id'].'/',
		'bottom'=>array(
			'cancel'=>'/order/order_lines/detail/'.$atim_menu_variables['Order.id'].'/'.$atim_menu_variables['OrderLine.id'].'/'
		)
	);
	$structures->build( $atim_structure, array('type' => 'datagrid', 'links'=>$structure_links) ); 
?>
<script type="text/javascript">
var copyStr = "<?php echo(__('copy', true)); ?>";
var pasteStr = "<?php echo(__('paste', true)); ?>";
var copyingStr = "<?php echo(__('copying', true)); ?>";
</script>
<?php 
echo $javascript->link('copyControl')."\n";
?>
<div id="debug"></div>