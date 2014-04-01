<?php 

if($order_data['Order']['qc_gastro_central_bank_order']) {
	$this->request->data['Shipment']['qc_gastro_central_bank_order'] = $order_data['Order']['qc_gastro_central_bank_order'];
	$this->Shipment->addWritableField(array('qc_gastro_central_bank_order'));
}

?>