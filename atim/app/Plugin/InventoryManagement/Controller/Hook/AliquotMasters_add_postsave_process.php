<?php

// --------------------------------------------------------------------------------
// generate default barcodes
// --------------------------------------------------------------------------------
// $queryToUpdate = "UPDATE sample_masters , sample_controls , aliquot_masters SET aliquot_masters.barcode = concat(trim(aliquot_masters.aliquot_label),'_',REPLACE(sample_controls.sample_type,' ','_'),cast(aliquot_masters.id as char)) WHERE sample_masters.sample_control_id = sample_controls.id AND aliquot_masters.sample_master_id = sample_masters.id AND aliquot_masters.barcode IS NULL OR aliquot_masters.barcode LIKE ''";"";
// echo $sampleControlId;
$sampleControlTxt = $sampleMasterData['ViewSample']['sample_type'];
// echo $sampleControlTxt;

$queryToUpdate = "UPDATE aliquot_masters SET aliquot_masters.barcode = concat(trim(aliquot_masters.aliquot_label),'_','" . str_replace(' ', "_", $sampleControlTxt) . "',cast(aliquot_masters.id as char)) WHERE aliquot_masters.barcode IS NULL OR aliquot_masters.barcode LIKE ''";
"";
$this->AliquotMaster->tryCatchQuery($queryToUpdate);
$this->AliquotMaster->tryCatchQuery(str_replace("aliquot_masters", "aliquot_masters_revs", $queryToUpdate));