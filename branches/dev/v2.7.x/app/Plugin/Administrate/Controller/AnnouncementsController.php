<?php

class AnnouncementsController extends AdministrateAppController {

	public $uses = array('Administrate.Announcement');

	public $paginate = array(
		'Announcement' => array(
			'limit' => PAGINATION_AMOUNT,
			'order' => 'Announcement.date_start DESC'
		)
	);

	public function beforeFilter() {
		parent::beforeFilter();
		$this->set('atim_menu', $this->Menus->get('/Administrate/Announcements/index/%%Group.id%%/%%User.id%%/'));

	}

	public function add($group_id = 0, $user_id = 0) {
		$this->set('atim_menu_variables', array('Group.id' => $group_id, 'User.id' => $user_id));

		$this->hook();

		if (!empty($this->request->data)) {
			$this->request->data['Announcement']['group_id'] = $group_id;
			$this->request->data['Announcement']['user_id'] = $user_id;
			if ($this->Announcement->save($this->request->data)) {

				$hook_link = $this->hook('postsave_process');
				if ($hook_link) {
					require($hook_link);
				}
				$this->atimFlash(__('your data has been updated'),
					'/Administrate/Announcements/detail/' . $group_id . '/' . $user_id . '/' . $this->Announcement->id);
			}
		}
	}

	public function index($group_id = 0, $user_id = 0) {
		$this->set('atim_menu_variables', array('Group.id' => $group_id, 'User.id' => $user_id));
		$this->request->data = $this->paginate($this->Announcement,
			array('Announcement.group_id' => $group_id, 'Announcement.user_id' => $user_id));
		$this->hook();
	}

	public function detail($group_id = 0, $user_id = 0, $announcement_id = null) {
		$this->set('atim_menu_variables',
			array('Group.id' => $group_id, 'User.id' => $user_id, 'Announcement.id' => $announcement_id));
		$this->hook();
		$this->request->data = $this->Announcement->find('first', array(
			'conditions' => array(
				'Announcement.group_id' => $group_id,
				'Announcement.user_id' => $user_id,
				'Announcement.id' => $announcement_id
			)
		));
	}

	public function edit($group_id = 0, $user_id = 0, $announcement_id = null) {
		$this->set('atim_menu_variables',
			array('Group.id' => $group_id, 'User.id' => $user_id, 'Announcement.id' => $announcement_id));

		$this->hook();

		if (!empty($this->request->data)) {
			$this->Announcement->id = $announcement_id;
			if ($this->Announcement->save($this->request->data)) {
				$hook_link = $this->hook('postsave_process');
				if ($hook_link) {
					require($hook_link);
				}
				$this->atimFlash(__('your data has been updated'),
					'/Administrate/Announcements/detail/' . $group_id . '/' . $user_id . '/' . $announcement_id . '/');
			}
		} else {
			$this->request->data = $this->Announcement->find('first', array(
				'conditions' => array(
					'Announcement.group_id' => $group_id,
					'Announcement.user_id' => $user_id,
					'Announcement.id' => $announcement_id
				)
			));
		}
	}

	public function delete($group_id = 0, $user_id = 0, $announcement_id = null) {
		$this->hook();

		if ($this->Announcement->atimDelete($announcement_id)) {
			$this->atimFlash(__('your data has been deleted'),
				'/Administrate/Announcements/index/' . $group_id . '/' . $user_id . '/');
		} else {
			$this->atimFlash(__('error deleting data - contact administrator'),
				'/Administrate/Announcements/index/' . $group_id . '/' . $user_id . '/');
		}
	}

}