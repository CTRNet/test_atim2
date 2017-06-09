<?php
$links = array(
    'top' => '/Administrate/Dropdowns/configure/' . $atimMenuVariables['StructurePermissibleValuesCustom.control_id'] . '/',
    'radiolist' => array(
        'StructurePermissibleValuesCustom.id' => '%%StructurePermissibleValuesCustom.id%%'
    ),
    'bottom' => array(
        'cancel' => '/Administrate/Dropdowns/view/' . $atimMenuVariables['StructurePermissibleValuesCustom.control_id'] . '/'
    )
);

$desc = __('dropdown_config_desc');
$this->Structures->build($atimStructure, array(
    'type' => 'editgrid',
    'settings' => array(
        'header' => array(
            'title' => '',
            'description' => $desc
        ),
        'pagination' => false
    ),
    'links' => $links
));

?>
<script>
	var dropdownConfig = true;
	var alphabeticalOrderingStr = "<?php echo __('alphabetical ordering'); ?>";
	var alphaOrderChecked = <?php echo $alphaOrder ? "true" : "false"; ?>;
</script>