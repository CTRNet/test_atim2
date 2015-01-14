<?php
	// Call custom model function to generate aliquot barcodes.
	$this->AliquotMaster->generateAliquotBarcode($batch_ids);
	$this->AliquotMaster->generateAliquotLabel($view_sample, $aliquot_control, $batch_ids)