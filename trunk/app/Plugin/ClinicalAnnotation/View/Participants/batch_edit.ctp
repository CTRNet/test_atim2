<?php
	$this->Structures->build($atim_structure, 
		array(
			'type' => 'batchedit', 
			'links' => array(
				'top' => '/ClinicalAnnotation/Participants/batchEdit'),
			'settings' => array(
				'header' => array(
					'title' => __('participants')." - ".__('batch edit'),
					'description' => __('you are about to edit %d element(s)', count(explode(",", $this->request->data[0]['ids'])))
				)
			)
		)
	);
?>
