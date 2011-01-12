<?php

	$options = array(
		'type'	=> 'add',
		'settings' => array(
			'header' 		=> __('plasma', true),
			'actions' 		=> false,
			'form_bottom'	=> false
		),
		'links' => array(
			'top' => '/inventorymanagement/bc_ttr_batch_entry/blood/'.$sample_id.'/')
	);
	
	$structures->build($bc_ttr_be_plasma, $options);
	
	$options['settings']['form_top'] = false;
	$options['settings']['header'] = __('blood cell', true);
	$structures->build($bc_ttr_be_blood_cells, $options);
	
	
	$options['settings']['header'] = __('dna card', true);
	$options['settings']['form_bottom'] = true;
	$structures->build($bc_ttr_be_whatman, $options);