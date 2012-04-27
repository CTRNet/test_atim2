<?php
class QcNdSardoController extends AdministrateAppController {
	
	var $uses = array(
		'administrate.QcNdSardoTxConfSurgeries',
	);
	
	static $site_to_tx_ctrl = array(
		'Ovaire'	=> 7,
		'Prostate'	=> 8,
		'Sein'		=> 9,
		''			=> 3,
		'Autre'		=> 3	
	);
	
	function index(){
		$data = array();
		foreach(array('', 'Autre', 'Ovaire', 'Prostate', 'Sein') as $site){
			$data[$site] = $this->QcNdSardoTxConfSurgeries->find('all', array('conditions' => array('site' => $site), 'order' => array('name')));
		}
		$data['Non classé'] = &$data[''];
		
		$this->Structures->set('qc_nd_sardo_surg_conf_name,qc_nd_sardo_conf_surg_ov', 'qc_nd_sardo_conf_surg_ov');
		$this->Structures->set('qc_nd_sardo_surg_conf_name,qc_nd_sardo_conf_surg_prost', 'qc_nd_sardo_conf_surg_prost');
		$this->Structures->set('qc_nd_sardo_surg_conf_name,qc_nd_sardo_conf_surg_breast', 'qc_nd_sardo_conf_surg_breast');
		$this->Structures->set('qc_nd_sardo_surg_conf_name', 'qc_nd_sardo_surg_conf_name');
		$this->set('data', $data);
	}
	
	function edit($id){
		$data = $this->QcNdSardoTxConfSurgeries->findById($id);
		assert($data) or die('not found');
		$tx_detail_model = new AppModel(array('table' => 'txd_surgeries', 'alias' => 'CustomTxDetail'));
		
		if($this->data){
			$default = array(
				'site'			=> '', 
				'laterality'	=> '',
				'm_type'		=> '',
				'method'		=> ''
			);
			$to_save = array_merge($default, $this->data['QcNdSardoTxConfSurgeries']);
			$this->QcNdSardoTxConfSurgeries->id = $id;
			$this->QcNdSardoTxConfSurgeries->save($to_save);
			$tx_details = $tx_detail_model->find('all', array('conditions' => array('CustomTxDetail.qc_nd_precision' => $data['QcNdSardoTxConfSurgeries']['name'])));
			$tx_master_model = AppModel::getInstance('clinicalannotation', 'TreatmentMaster', true);
			foreach($tx_details as $tx_detail){
				$tx_master_model->data = array();
				$tx_master_model->id = $tx_detail['CustomTxDetail']['treatment_master_id'];
				$tx_master_model->save(array(
					'TreatmentMaster' => array('treatment_control_id' => self::$site_to_tx_ctrl[$to_save['site']]),
					'TreatmentDetail' => array(
						'qc_nd_laterality'	=> $to_save['laterality'],
						'qc_nd_type'		=> $to_save['m_type'],
						'qc_nd_method'		=> $to_save['method']
					)
				));
			}
			
			$this->atimFlash('your data has been saved', '/administrate/qc_nd_sardo/index/');
		}else{
			$this->set('data', $data);
			$this->Structures->set('qc_nd_sardo_conf_surg_ov', 'qc_nd_sardo_conf_surg_ov');
			$this->Structures->set('qc_nd_sardo_conf_surg_prost', 'qc_nd_sardo_conf_surg_prost');
			$this->Structures->set('qc_nd_sardo_conf_surg_breast', 'qc_nd_sardo_conf_surg_breast');
			$this->Structures->set('qc_nd_sardo_surg_conf_site', 'qc_nd_sardo_surg_conf_site');
			$tx_count = $tx_detail_model->find('count', array('conditions' => array('CustomTxDetail.qc_nd_precision' => $data['QcNdSardoTxConfSurgeries']['name'])));
			AppController::addWarningMsg('Sauvegarder ce formulaire affectera les chirurgies liées. ('.$tx_count.')');
		}
	}
}
