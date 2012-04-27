<?php
class MenusControllerCustom extends MenusController {

	function index($set_of_menus=NULL){
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
		$count = $protocol_model->find('count', array($sub_query_expression));
		if($count > 0){
			
			AppController::addWarningMsg(sprintf('Protocoles mixtes sans définition: %d. Cliquez <a href="%s">ici</a> pour les voir.', $count, $this->webroot.'protocol/protocol_masters/search/0/mixedNoDef:'));
		}
		parent::index($set_of_menus);
	}
		
}

?>
