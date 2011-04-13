<?php 
	$links = array(
		'top' => '/administrate/dropdowns/configure/'.$atim_menu_variables['StructurePermissibleValuesCustom.control_id'].'/',
		'radiolist' => array(
			'StructurePermissibleValuesCustom.id'=>'%%StructurePermissibleValuesCustom.id%%'
		),
		'bottom' => array(
			'cancel' => '/administrate/dropdowns/view/'.$atim_menu_variables['StructurePermissibleValuesCustom.control_id'].'/'
		)
	);
	$desc = __('dropdown_config_desc', true);
	$structures->build($atim_structure, array('type' => 'index', 'settings' => array('header' => array('title' => '', 'description' => $desc), 'form_inputs' => false, 'pagination' => false), 'links' => $links));

?>
<script>
	var dropdownConfig = true;
	var alphabeticalOrderingStr = "<?php __('alphabetical ordering'); ?>";
	var alphaOrderChecked = <?php echo $alpha_order ? "true" : "false"; ?>;
</script>