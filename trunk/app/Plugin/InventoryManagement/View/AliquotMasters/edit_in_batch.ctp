<?php
$aliquot_ids = array();
if(isset($this->request->data['ViewAliquot']['aliquot_master_id'])){
	$aliquot_ids = implode(',', array_filter($this->request->data['ViewAliquot']['aliquot_master_id']));
}else{
	$aliquot_ids = $this->request->data['aliquot_ids'];
}
$this->Structures->build($atim_structure, array(
	'type'		=> 'batchedit',
	'links'		=> array('top' => '/InventoryManagement/AliquotMasters/editInBatch/', 'bottom' => array('cancel' => $cancel_link)),
	'override'	=> array('AliquotMaster.in_stock'	=> ''),
	'settings'	=> array('header' => array('title' => __('aliquots').' - '.__('batch edit'), 'description' => __('you are about to edit %d element(s)', substr_count($aliquot_ids, ',') + 1))),
	'extras'	=> $this->Form->text('aliquot_ids', array("type" => "hidden", "id" => false, "value" => $aliquot_ids)).
			$this->Form->text('cancel_link', array("type" => "hidden", "id" => false, "value" => $cancel_link))
				
));