<?php
	
	// --------------------------------------------------------------------------------
	// generate default barcodes 
	// -------------------------------------------------------------------------------- 	
	//	$query_to_update = "UPDATE sample_masters , sample_controls , aliquot_masters SET  aliquot_masters.barcode = concat(trim(aliquot_masters.aliquot_label),'_',REPLACE(sample_controls.sample_type,' ','_'),cast(aliquot_masters.id as char)) WHERE sample_masters.sample_control_id = sample_controls.id AND aliquot_masters.sample_master_id = sample_masters.id AND aliquot_masters.barcode IS NULL OR aliquot_masters.barcode LIKE ''";"";
	// echo $sample_control_id;
	
	$sample_control_txt = $sample_master_data['ViewSample']['sample_type'];
	// echo $sample_control_txt;

    $query_to_update = "UPDATE aliquot_masters SET aliquot_masters.barcode = concat(trim(aliquot_masters.aliquot_label),'_','".str_replace(' ',"_",$sample_control_txt)."',cast(aliquot_masters.id as char)) WHERE aliquot_masters.barcode IS NULL OR aliquot_masters.barcode LIKE ''";"";
	$this->AliquotMaster->tryCatchQuery($query_to_update);
	$this->AliquotMaster->tryCatchQuery(str_replace("aliquot_masters", "aliquot_masters_revs", $query_to_update));


?>
