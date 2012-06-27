<?php

class ViewAliquotUseCustom extends ViewAliquotUse {
	var $base_model = "AliquotInternalUse";
	var $useTable = 'view_aliquot_uses';
	var $name = 'ViewAliquotUse'; 	
		
	function __construct(){
		parent::__construct();
		
		parent::$models_details['SourceAliquot'][parent::USE_CODE] = "CONCAT(SampleMaster.sample_label, ' (', SampleMaster.sample_code,')')";
		
		parent::$models_details['Realiquoting'][parent::USE_CODE] = "CONCAT(AliquotMasterChildren.aliquot_label,' (',AliquotMasterChildren.barcode,')')";
		
		parent::$models_details['OrderItem'][parent::USE_CODE] = "CONCAT(Shipment.shipment_code, ' - ', '".__('recipient', true).": ', Shipment.recipient)";
	}

}

?>
