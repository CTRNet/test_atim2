<?php
	
	// --------------------------------------------------------------------------------
	// generate default barcodes 
	// -------------------------------------------------------------------------------- 	

	$query_to_update = "UPDATE aliquot_masters SET aliquot_masters.barcode = concat(trim(aliquot_masters.aliquot_label),'_',cast(aliquot_masters.id as char)) WHERE aliquot_masters.barcode IS NULL OR aliquot_masters.barcode LIKE ''";"";
	$this->AliquotMaster->tryCatchQuery($query_to_update);
	$this->AliquotMaster->tryCatchQuery(str_replace("aliquot_masters", "aliquot_masters_revs", $query_to_update));


?>
