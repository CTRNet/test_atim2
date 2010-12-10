<?php
	$structures->build($atim_structure, array(
		'type' => 'add', 
		'settings' => array('header' => __('select a realiquoting type', true)),
		'links' => array('top' => '/inventorymanagement/aliquot_masters/realiquot/')
		));
?>
<script>
var realiquotInit = true;
</script>