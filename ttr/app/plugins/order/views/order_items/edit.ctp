<?php 

	$structure_links = array(
		'top'=>'/order/order_items/edit/'.$atim_menu_variables['Order.id'].'/'.$atim_menu_variables['OrderLine.id'].'/',
		'bottom'=>array('cancel'=>'/order/order_items/listall/'.$atim_menu_variables['Order.id'].'/'.$atim_menu_variables['OrderLine.id'].'/')
	);
	
	$final_atim_structure = $atim_structure; 
	$final_options = array('type' => 'datagrid', 'links'=>$structure_links, 'settings'=> array('pagination' => false));
	
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );	
?>

<script type="text/javascript">
var copyStr = "<?php echo(__('copy', true)); ?>";
var pasteStr = "<?php echo(__('paste', true)); ?>";
var copyingStr = "<?php echo(__('copying', true)); ?>";
var pasteOnAllLinesStr = "<?php echo(__("paste on all lines")); ?>";
</script>
<?php 
echo $javascript->link('copyControl')."\n";
?>
<div id="debug"></div>