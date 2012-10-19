<?php

class ViewAliquotUseCustom extends ViewAliquotUse {
	var $base_model = "AliquotInternalUse";
	var $useTable = 'view_aliquot_uses';
	var $name = 'ViewAliquotUse'; 	
		
	function __construct(){
		parent::__construct();
		
		//parent::$models_details['SourceAliquot'][parent::USE_CODE] = "CONCAT(SampleMaster.qc_nd_sample_label, ' [', SampleMaster.sample_code,']')";
		parent::$models_details['Realiquoting'][parent::USE_CODE] = "CONCAT(AliquotMasterChildren.qcroc_barcode,' [',AliquotMasterChildren.aliquot_label,']')";

	}

}

?>
