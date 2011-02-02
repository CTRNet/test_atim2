<?php

	$structures->build($atim_structure, array(
		'type' => 'add', 
		'links' => array('top' => '/inventorymanagement/sample_masters/batchDerivative'),
		'settings' => array(
			'header' => __('select a derivative type', true)),
		'extras' => '<input type="hidden" name="data[SampleMaster][ids]" value="'.$ids.'"/>'));