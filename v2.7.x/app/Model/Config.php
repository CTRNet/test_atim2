<?php
App::uses('AppModel', 'Model');

class Config extends AppModel {

	/**
	 * Get Configuration
	 *
	 * @param int $groupId Group ID
	 * @param int $userId USer ID
	 *
	 * @return array|null
	 */
	public function getConfig($groupId, $userId) {
		$configResults = $this->find('first', array(
			'conditions' => array(
				'Config.user_id' => $userId,
				'Config.group_id' => $groupId
			)
		));
		if ($configResults) {
			return $configResults;
		}

		$configResults = $this->find('first', array(
			'conditions' => array(
				array('OR' => array('Config.bank_id' => 0, 'Config.bank_id IS NULL')),
				array('OR' => array('Config.group_id' => 0, 'Config.group_id IS NULL')),
				'Config.user_id' => $userId
			)
		));
		if ($configResults) {
			return $configResults;
		}

		$configResults = $this->find('first', array(
			'conditions' => array(
				array('OR' => array('Config.bank_id' => 0, 'Config.bank_id IS NULL')),
				'Config.group_id' => $groupId,
				array('OR' => array('Config.user_id' => 0, 'Config.user_id IS NULL'))
			)
		));
		if ($configResults) {
			return $configResults;
		}

		return $this->find('first', array(
			'conditions' => array(
				array('OR' => array('Config.bank_id' => 0, 'Config.bank_id IS NULL')),
				array('OR' => array('Config.group_id' => 0, 'Config.group_id IS NULL')),
				array('OR' => array('Config.user_id' => 0, 'Config.user_id IS NULL'))
			)
		));
	}

	/**
	 * Set Configuration
	 *
	 * @param array $config Configuration
	 *
	 * @return bool
	 *
	 * @throws Exception
	 */
	public function setConfig($config) {
		if (!$config) {
			throw new Exception('No valid configuration');
		}

		Configure::write('Config.language', $config['Config']['config_language']);
		foreach ($config['Config'] as $configKey => $configData) {
			if (strpos($configKey, '_') !== false) {

				// break apart CONFIG key
				$configKey = explode('_', $configKey);
				$configFormat = array_shift($configKey);
				$configKey = implode('_', $configKey);

				// if a DEFINE or CONFIG, set new setting for APP
				if ($configFormat == 'define') {
					$uppercaseConfigKey = strtoupper($configKey);
					define($uppercaseConfigKey, $configData);
				} elseif ($configFormat == 'config') {
					Configure::write($configKey, $configData);
				}
			}
		}
		return true;
	}

	/**
	 * Modifications before Save
	 *
	 * @param array $configResults Config
	 * @param array &$requestData Request Data
	 * @param int $groupId Group ID
	 * @param int $userId User ID
	 *
	 * @return void
	 */
	public function preSave($configResults, &$requestData, $groupId, $userId) {
		if ($configResults['Config']['user_id'] != 0) {
			//own config, edit, otherwise will create a new one
			$this->id = $configResults['Config']['id'];
		} else {
			$requestData['Config']['user_id'] = $userId;
			$requestData['Config']['group_id'] = $groupId;
			$this->addWritableField(array('user_id', 'group_id', 'bank_id'));
		}

		//fixes a cakePHP 2.0 issue with integer enums
		$requestData['Config']['define_time_format'] = $requestData['Config']['define_time_format'] == 24 ? 2 : 1;
	}
}
