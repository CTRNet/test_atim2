<?php

class AnnouncementsController extends CustomizeAppController {

	public $uses = array('Announcement');

	public $paginate = array(
		'Announcement' => array(
			'limit' => PAGINATION_AMOUNT,
			'order' => 'Announcement.date DESC'
		)
	);

	function index() {
		;

		$conditions = array();
		$conditions[] = 'date_start<=NOW()';
		$conditions[] = 'date_end>=NOW()';
		$conditions[] = '(group_id="0" OR group_id="' . $_SESSION['Auth']['User']['group_id'] . '")';
		$conditions = array_filter($conditions);

		$this->hook();

		$this->request->data = $this->paginate($this->Announcement, $conditions);
	}

	function detail($announcement_id = null) {
		$this->set('atim_menu_variables', array('Announcement.id' => $announcement_id));

		$this->hook();

		$this->request->data = $this->Announcement->find('first',
			array('conditions' => array('Announcement.id' => $announcement_id)));
	}

}