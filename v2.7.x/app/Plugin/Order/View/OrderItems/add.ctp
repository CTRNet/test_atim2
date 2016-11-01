<?php
AppController::addInfoMsg(__('add_order_items_info'));
$structure_links = array(
	'top' => '/Order/OrderItems/add/' . $atim_menu_variables['Order.id'] . '/' . $atim_menu_variables['OrderLine.id'] . '/',
	'bottom' => array('cancel' => empty($atim_menu_variables['OrderLine.id']) ? '/Order/Orders/detail/' . $atim_menu_variables['Order.id'] . '/' : '/Order/OrderLines/detail/' . $atim_menu_variables['Order.id'] . '/' . $atim_menu_variables['OrderLine.id'] . '/')
);

$structure_override = array();

$final_atim_structure = $atim_structure;
$final_options = array(
	'settings' => array(
		'header' => __((empty($atim_menu_variables['OrderLine.id']) ? 'add items to order' : 'add items to line'),
			null),
		'paste_disabled_fields' => array('AliquotMaster.barcode'),
		'pagination' => false,
		'add_fields' => true,
		'del_fields' => true
	),
	'links' => $structure_links,
	'override' => $structure_override,
	'type' => 'addgrid'
);

// CUSTOM CODE
$hook_link = $this->Structures->hook();
if ($hook_link) {
	require($hook_link);
}

// BUILD FORM
$this->Structures->build($final_atim_structure, $final_options);

?>
<script type="text/javascript">
    var copyStr = "<?php echo(__("
    copy;;
    ", null)); ?>";
    var pasteStr = "<?php echo(__("
paste;;
")); ?>";
    var copyingStr = "<?php echo(__("
copying;;
")); ?>";
    var pasteOnAllLinesStr = "<?php echo(__("
paste;;
on;
all;
lines
")); ?>";
    ;
    var copyControl = true;
</script>