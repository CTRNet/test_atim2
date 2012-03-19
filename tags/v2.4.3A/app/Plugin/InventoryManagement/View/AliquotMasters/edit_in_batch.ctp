<?php
$filtered_ids = array_filter($this->request->data['ViewAliquot']['aliquot_master_id']);
$this->Structures->build($atim_structure, array(
	'type'		=> 'batchedit',
	'links'		=> array('top' => '/InventoryManagement/AliquotMasters/editInBatch/', 'bottom' => array('cancel' => $cancel_link)),
	'override'	=> array('AliquotMaster.in_stock'	=> ''),
	'settings'	=> array('header' => array('title' => __('aliquots').' - '.__('batch edit'), 'description' => __('you are about to edit %d element(s)', count($filtered_ids)))),
	'extras'	=> $this->Form->text('aliquot_ids', array("type" => "hidden", "id" => false, "value" => implode(',', $filtered_ids))).
			$this->Form->text('cancel_link', array("type" => "hidden", "id" => false, "value" => $cancel_link))
				
));