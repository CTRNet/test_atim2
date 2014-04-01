<?php 

	// To validate shipment
	$this->request->data['Shipment']['qc_gastro_central_bank_order'] = $shipment_data['Shipment']['qc_gastro_central_bank_order'];
	$this->Shipment->addWritableField(array('qc_gastro_central_bank_order'));

?>