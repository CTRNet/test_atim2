<?php

class StructuresController extends AdministrateAppController {

	public $uses = array('Structure');

	public $paginate = array('Structure' => array('limit' => PAGINATION_AMOUNT, 'order' => 'Structure.alias ASC'));

	public function index() {
		$this->hook();

		$this->request->data = $this->paginate($this->Structure);
	}

	public function detail($structure_id) {
		$this->set('atim_menu_variables', array('Structure.id' => $structure_id));

		$this->hook();

		$this->request->data = $this->Structure->find('first',
			array('conditions' => array('Structure.id' => $structure_id)));
	}

	public function edit($structure_id) {
		$this->set('atim_menu_variables', array('v.id' => $structure_id));

		$this->hook();

		if (!empty($this->request->data)) {
			if ($this->Structure->save($this->request->data)) {
				$this->atimFlash(__('your data has been updated'), '/Administrate/Structure/detail/' . $structure_id);
			}
		} else {
			$this->request->data = $this->Structure->find('first',
				array('conditions' => array('Structure.id' => $structure_id)));
		}
	}
}