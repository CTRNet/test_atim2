<?php
	// Call custom model function to generate aliquot barcodes.
	$this->AliquotMaster->generateAliquotBarcode($batch_ids);
	$this->AliquotMaster->generateAliquotLabel($sample_master_data, $aliquot_control, $batch_ids);