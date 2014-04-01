<?php

class ShipmentCustom extends Shipment
{
	var $name = 'Shipment';
	var $useTable = 'shipments';
  
	function validates($options = array()){
		$errors = parent::validates($options);
		
		if(array_key_exists('Shipment', $this->data) && array_key_exists('qc_gastro_central_bank_order', $this->data['Shipment']) && $this->data['Shipment']['qc_gastro_central_bank_order']) {
			$empty_fields = array(
				'shipped_by',
				'recipient',
				'delivery_phone_number',
				'facility',
				'delivery_department_or_door',
				'delivery_street_address',
				'delivery_city',
				'delivery_province',
				'delivery_postal_code',
				'delivery_country');
			foreach($empty_fields as $new_field) {
				if(strlen($this->data['Shipment'][$new_field])) {
					$errors = false;
					$this->validationErrors[$new_field][] = __('this field should be empty for central biobank order', true);
				}
			}
		}
		return $errors;
	}
}











?>