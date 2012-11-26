<?php

class ViewAliquotUseCustom extends ViewAliquotUse {
	var $base_model = "AliquotInternalUse";
	var $useTable = 'view_aliquot_uses';
	var $name = 'ViewAliquotUse'; 	
		
	function __construct(){
		parent::__construct();
		
		parent::$models_details['SourceAliquot'][parent::USE_CODE] = "CONCAT(SampleControl.sample_type, ' [', SampleMaster.sample_code,']')";
		parent::$models_details['SourceAliquot'][parent::JOINS] =
			array(
				AliquotMaster::joinOnAliquotDup('SourceAliquot.aliquot_master_id'),
				AliquotMaster::$join_aliquot_control_on_dup,
				array('table' => 'sample_masters', 'alias' => 'sample_derivative', 'type' => 'INNER', 'conditions' => array('SourceAliquot.sample_master_id = sample_derivative.id')),
				array('table' => 'sample_controls', 'alias' => 'SampleControl', 'type' => 'INNER', 'conditions' => array('sample_derivative.sample_control_id = SampleControl.id')),
				array('table' => 'derivative_details', 'alias' => 'DerivativeDetail', 'type' => 'INNER', 'conditions' => array('sample_derivative.id = DerivativeDetail.sample_master_id')),
				array('table' => 'sample_masters', 'alias' => 'sample_source', 'type' => 'INNER', 'conditions' => array('aliquot_masters_dup.sample_master_id = sample_source.id')));
				
		parent::$models_details['Realiquoting'][parent::USE_CODE] = "CONCAT(AliquotMasterChildren.aliquot_label,' [',AliquotMasterChildren.barcode,']')";
		
		parent::$models_details['OrderItem'][parent::USE_CODE] = "CONCAT(Shipment.shipment_code, ' - ', Shipment.recipient)";
	}

}

?>
