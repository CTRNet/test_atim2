<?php 
	$links = array(
		'top' => '/Administrate/dropdowns/configure/'.$atim_menu_variables['StructurePermissibleValuesCustom.control_id'].'/',
		'radiolist' => array(
			'StructurePermissibleValuesCustom.id'=>'%%StructurePermissibleValuesCustom.id%%'
		),
		'bottom' => array(
			'cancel' => '/Administrate/dropdowns/view/'.$atim_menu_variables['StructurePermissibleValuesCustom.control_id'].'/'
		)
	);
	
	$desc = __('dropdown_config_desc');
	$this->Structures->build($atim_structure, array('type' => 'editgrid', 'settings' => array('header' => array('title' => '', 'description' => $desc), 'pagination' => false), 'links' => $links));

?>
<script>
	var dropdownConfig = true;
	var alphabeticalOrderingStr = "<?php echo __('alphabetical ordering'); ?>";
	var alphaOrderChecked = <?php echo $alpha_order ? "true" : "false"; ?>;
</script>