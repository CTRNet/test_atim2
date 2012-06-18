<?php
if(isset($this->passedArgs['mixedNoDef'])){
	$protocol_model = AppModel::getInstance('protocol', 'ProtocolMaster', true);
	$qc_nd_protocol_behavior_model = AppModel::getInstance('protocol', 'QcNdProtocolBehavior', true);
	$ds = $qc_nd_protocol_behavior_model->getDataSource();
	$sub_query = $ds->buildStatement(array(
			'fields'	=> array('protocol_master_id'),
			'table'		=> $qc_nd_protocol_behavior_model->table,
			'alias'		=> 'QcNdProtocolBehavior',
			'order'		=> null,
			'limit'		=> null,
			'group'		=> null,
			'conditions' => array(),
		), $qc_nd_protocol_behavior_model
	);
	
	$sub_query = 'ProtocolMaster.id NOT IN('.$sub_query.') ';
	$sub_query_expression = $ds->expression($sub_query);
	$this->data = $protocol_model->find('all', array('conditions' => array($sub_query_expression)));
	$this->set('mixedNoDef', true);
	
	$search_id = "foo";
}