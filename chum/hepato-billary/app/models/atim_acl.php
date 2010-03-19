<?php
if (!class_exists('AclNode')) {
	uses('model' . DS . 'db_acl');
	uses('controller'.DS.'components' . DS . 'acl');
}

class AtimAcl extends DbAcl {
/**
 * Constructor
 *
 */
	function __construct() {
		parent::__construct();
		if (!class_exists('AclNode')) {
			uses('model' . DS . 'db_acl');
		}
		$this->Aro =& ClassRegistry::init(array('class' => 'AtimAro', 'alias' => 'Aro'));
		$this->Aco =& ClassRegistry::init(array('class' => 'AtimAco', 'alias' => 'Aco'));
	}
	
/**
 * Checks if the given $aro has access to action $action in $aco
 *
 * @param string $aro ARO
 * @param string $aco ACO
 * @param string $action Action (defaults to *)
 * @return boolean Success (true if ARO has access to action in ACO, false otherwise)
 * @access public
 */
	function check($aro, $aco, $action = "*") {
		if ($aro == null || $aco == null) {
			return false;
		}

		$permKeys = $this->_getAcoKeys($this->Aro->Permission->schema());
		$aroPath = $this->Aro->node($aro);
		$acoPath = $this->Aco->node($aco);

		if (empty($aroPath) || empty($acoPath)) {
			//trigger_error("DbAcl::check() - Failed ARO/ACO node lookup in permissions check.  Node references:\nAro: " . print_r($aro, true) . "\nAco: " . print_r($aco, true), E_USER_WARNING);
			return false;
		}

		if ($acoPath == null || $acoPath == array()) {
			//trigger_error("DbAcl::check() - Failed ACO node lookup in permissions check.  Node references:\nAro: " . print_r($aro, true) . "\nAco: " . print_r($aco, true), E_USER_WARNING);
			return false;
		}

		$aroNode = $aroPath[0];
		$acoNode = $acoPath[0];

		if ($action != '*' && !in_array('_' . $action, $permKeys)) {
			//trigger_error(sprintf(__("ACO permissions key %s does not exist in DbAcl::check()", true), $action), E_USER_NOTICE);
			return false;
		}

		$inherited = array();
		$acoIDs = Set::extract($acoPath, '{n}.' . $this->Aco->alias . '.id');

		$count = count($aroPath);
		for ($i = 0 ; $i < $count; $i++) {
			$permAlias = $this->Aro->Permission->alias;

			$perms = $this->Aro->Permission->find('all', array(
				'conditions' => array(
					"{$permAlias}.aro_id" => $aroPath[$i][$this->Aro->alias]['id'],
					"{$permAlias}.aco_id" => $acoIDs
				),
				'order' => array($this->Aco->alias . '.lft' => 'desc'),
				'recursive' => 0
			));

			if (empty($perms)) {
				continue;
			} else {
				$perms = Set::extract($perms, '{n}.' . $this->Aro->Permission->alias);
				foreach ($perms as $perm) {
					if ($action == '*') {

						foreach ($permKeys as $key) {
							if (!empty($perm)) {
								if ($perm[$key] == -1) {
									return false;
								} elseif ($perm[$key] == 1) {
									$inherited[$key] = 1;
								}
							}
						}

						if (count($inherited) === count($permKeys)) {
							return true;
						}
					} else {
						switch ($perm['_' . $action]) {
							case -1:
								return false;
							case 0:
								continue;
							break;
							case 1:
								return true;
							break;
						}
					}
				}
			}
		}
		return false;
	}

}

class AtimAco extends Aco {

/**
 * Retrieves the Aro/Aco node for this model
 *
 * @param mixed $ref Array with 'model' and 'foreign_key', model object, or string value
 * @return array Node found in database
 * @access public
 */
	function node($ref = null) {
		$db =& ConnectionManager::getDataSource($this->useDbConfig);
		$type = $this->alias;
		$result = null;

		if (!empty($this->useTable)) {
			$table = $this->useTable;
		} else {
			$table = Inflector::pluralize(Inflector::underscore($type));
		}

		if (empty($ref)) {
			return null;
		} elseif (is_string($ref)) {
			$path = explode('/', $ref);
			$start = $path[0];
			unset($path[0]);

			$queryData = array(
				'conditions' => array(
					$db->name("{$type}.lft") . ' <= ' . $db->name("{$type}0.lft"),
					$db->name("{$type}.rght") . ' >= ' . $db->name("{$type}0.rght")),
				'fields' => array('id', 'parent_id', 'model', 'foreign_key', 'alias'),
				'joins' => array(array(
					'table' => $db->fullTableName($this),
					'alias' => "{$type}0",
					'type' => 'LEFT',
					'conditions' => array("{$type}0.alias" => $start)
				)),
				'order' => $db->name("{$type}.lft") . ' DESC'
			);
			
			$join_conditions = array();
			
			foreach ($path as $i => $alias) {
				$j = $i - 1;

				$queryData['joins'][] = array(
					'table' => $db->fullTableName($this),
					'alias' => "{$type}{$i}",
					'type'  => 'LEFT',
					'conditions' => array(
						//$db->name("{$type}{$i}.lft") . ' > ' . $db->name("{$type}{$j}.lft"),
						//$db->name("{$type}{$i}.rght") . ' < ' . $db->name("{$type}{$j}.rght"),
						$db->name("{$type}{$i}.alias") . ' = ' . $db->value($alias, 'string')
					)
				);
				
				$join_conditions[] = $db->name("{$type}{$i}.lft") . ' > ' . $db->name("{$type}{$j}.lft").' AND '.$db->name("{$type}{$i}.rght") . ' < ' . $db->name("{$type}{$j}.rght") . ' AND ' . $db->name("{$type}{$i}.parent_id") . ' = ' . $db->name("{$type}{$j}.id");
				
				$queryData['conditions'] = join(' AND ', $join_conditions)
					.' AND ('
						.' ('
							.$db->name("{$type}.lft") . ' <= ' . $db->name("{$type}0.lft")
							. ' AND ' . $db->name("{$type}.rght") . ' >= ' . $db->name("{$type}0.rght")
						.') OR ('
							.$db->name("{$type}.lft") . ' <= ' . $db->name("{$type}{$i}.lft")
							. ' AND ' . $db->name("{$type}.rght") . ' >= ' . $db->name("{$type}{$i}.rght")
						.')'
					.' )'
				;
			}
			$result = $db->read($this, $queryData, -1);
			$path = array_values($path);

			if (
				!isset($result[0][$type]) ||
				(!empty($path) && $result[0][$type]['alias'] != $path[count($path) - 1]) ||
				(empty($path) && $result[0][$type]['alias'] != $start)
			) {
				return false;
			}
		} elseif (is_object($ref) && is_a($ref, 'Model')) {
			$ref = array('model' => $ref->alias, 'foreign_key' => $ref->id);
		} elseif (is_array($ref) && !(isset($ref['model']) && isset($ref['foreign_key']))) {
			$name = key($ref);

			if (PHP5) {
				$model = ClassRegistry::init(array('class' => $name, 'alias' => $name));
			} else {
				$model =& ClassRegistry::init(array('class' => $name, 'alias' => $name));
			}

			if (empty($model)) {
				trigger_error("Model class '$name' not found in AclNode::node() when trying to bind {$this->alias} object", E_USER_WARNING);
				return null;
			}

			$tmpRef = null;
			if (method_exists($model, 'bindNode')) {
				$tmpRef = $model->bindNode($ref);
			}
			if (empty($tmpRef)) {
				$ref = array('model' => $name, 'foreign_key' => $ref[$name][$model->primaryKey]);
			} else {
				if (is_string($tmpRef)) {
					return $this->node($tmpRef);
				}
				$ref = $tmpRef;
			}
		}
		if (is_array($ref)) {
			if (is_array(current($ref)) && is_string(key($ref))) {
				$name = key($ref);
				$ref = current($ref);
			}
			foreach ($ref as $key => $val) {
				if (strpos($key, $type) !== 0 && strpos($key, '.') === false) {
					unset($ref[$key]);
					$ref["{$type}0.{$key}"] = $val;
				}
			}
			$queryData = array(
				'conditions' => $ref,
				'fields' => array('id', 'parent_id', 'model', 'foreign_key', 'alias'),
				'joins' => array(array(
					'table' => $db->fullTableName($this),
					'alias' => "{$type}0",
					'type' => 'LEFT',
					'conditions' => array(
						$db->name("{$type}.lft") . ' <= ' . $db->name("{$type}0.lft"),
						$db->name("{$type}.rght") . ' >= ' . $db->name("{$type}0.rght")
					)
				)),
				'order' => $db->name("{$type}.lft") . ' DESC'
			);
			$result = $db->read($this, $queryData, -1);

			if (!$result) {
				trigger_error("AclNode::node() - Couldn't find {$type} node identified by \"" . print_r($ref, true) . "\"", E_USER_WARNING);
			}
		}
		return $result;
	}
	
}

class AtimAro extends Aro {

/**
 * Retrieves the Aro/Aco node for this model
 *
 * @param mixed $ref Array with 'model' and 'foreign_key', model object, or string value
 * @return array Node found in database
 * @access public
 */
	function node($ref = null) {
		$db =& ConnectionManager::getDataSource($this->useDbConfig);
		$type = $this->alias;
		$result = null;

		if (!empty($this->useTable)) {
			$table = $this->useTable;
		} else {
			$table = Inflector::pluralize(Inflector::underscore($type));
		}

		if (empty($ref)) {
			return null;
		} elseif (is_string($ref)) {
			$path = explode('/', $ref);
			$start = $path[0];
			unset($path[0]);

			$queryData = array(
				'conditions' => array(
					$db->name("{$type}.lft") . ' <= ' . $db->name("{$type}0.lft"),
					$db->name("{$type}.rght") . ' >= ' . $db->name("{$type}0.rght")),
				'fields' => array('id', 'parent_id', 'model', 'foreign_key', 'alias'),
				'joins' => array(array(
					'table' => $db->fullTableName($this),
					'alias' => "{$type}0",
					'type' => 'LEFT',
					'conditions' => array("{$type}0.alias" => $start)
				)),
				'order' => $db->name("{$type}.lft") . ' DESC'
			);
			
			$join_conditions = array();
			
			foreach ($path as $i => $alias) {
				$j = $i - 1;

				$queryData['joins'][] = array(
					'table' => $db->fullTableName($this),
					'alias' => "{$type}{$i}",
					'type'  => 'LEFT',
					'conditions' => array(
						//$db->name("{$type}{$i}.lft") . ' > ' . $db->name("{$type}{$j}.lft"),
						//$db->name("{$type}{$i}.rght") . ' < ' . $db->name("{$type}{$j}.rght"),
						$db->name("{$type}{$i}.alias") . ' = ' . $db->value($alias, 'string')
					)
				);
				
				$join_conditions[] = $db->name("{$type}{$i}.lft") . ' > ' . $db->name("{$type}{$j}.lft").' AND '.$db->name("{$type}{$i}.rght") . ' < ' . $db->name("{$type}{$j}.rght") . ' AND ' . $db->name("{$type}{$i}.parent_id") . ' = ' . $db->name("{$type}{$j}.id");
				
				$queryData['conditions'] = join(' AND ', $join_conditions)
					.' AND ('
						.' ('
							.$db->name("{$type}.lft") . ' <= ' . $db->name("{$type}0.lft")
							. ' AND ' . $db->name("{$type}.rght") . ' >= ' . $db->name("{$type}0.rght")
						.') OR ('
							.$db->name("{$type}.lft") . ' <= ' . $db->name("{$type}{$i}.lft")
							. ' AND ' . $db->name("{$type}.rght") . ' >= ' . $db->name("{$type}{$i}.rght")
						.')'
					.' )'
				;
			}
			$result = $db->read($this, $queryData, -1);
			$path = array_values($path);

			if (
				!isset($result[0][$type]) ||
				(!empty($path) && $result[0][$type]['alias'] != $path[count($path) - 1]) ||
				(empty($path) && $result[0][$type]['alias'] != $start)
			) {
				return false;
			}
		} elseif (is_object($ref) && is_a($ref, 'Model')) {
			$ref = array('model' => $ref->alias, 'foreign_key' => $ref->id);
		} elseif (is_array($ref) && !(isset($ref['model']) && isset($ref['foreign_key']))) {
			$name = key($ref);

			if (PHP5) {
				$model = ClassRegistry::init(array('class' => $name, 'alias' => $name));
			} else {
				$model =& ClassRegistry::init(array('class' => $name, 'alias' => $name));
			}

			if (empty($model)) {
				trigger_error("Model class '$name' not found in AclNode::node() when trying to bind {$this->alias} object", E_USER_WARNING);
				return null;
			}

			$tmpRef = null;
			if (method_exists($model, 'bindNode')) {
				$tmpRef = $model->bindNode($ref);
			}
			if (empty($tmpRef)) {
				$ref = array('model' => $name, 'foreign_key' => $ref[$name][$model->primaryKey]);
			} else {
				if (is_string($tmpRef)) {
					return $this->node($tmpRef);
				}
				$ref = $tmpRef;
			}
		}
		if (is_array($ref)) {
			if (is_array(current($ref)) && is_string(key($ref))) {
				$name = key($ref);
				$ref = current($ref);
			}
			foreach ($ref as $key => $val) {
				if (strpos($key, $type) !== 0 && strpos($key, '.') === false) {
					unset($ref[$key]);
					$ref["{$type}0.{$key}"] = $val;
				}
			}
			$queryData = array(
				'conditions' => $ref,
				'fields' => array('id', 'parent_id', 'model', 'foreign_key', 'alias'),
				'joins' => array(array(
					'table' => $db->fullTableName($this),
					'alias' => "{$type}0",
					'type' => 'LEFT',
					'conditions' => array(
						$db->name("{$type}.lft") . ' <= ' . $db->name("{$type}0.lft"),
						$db->name("{$type}.rght") . ' >= ' . $db->name("{$type}0.rght")
					)
				)),
				'order' => $db->name("{$type}.lft") . ' DESC'
			);
			$result = $db->read($this, $queryData, -1);

			if (!$result) {
				trigger_error("AclNode::node() - Couldn't find {$type} node identified by \"" . print_r($ref, true) . "\"", E_USER_WARNING);
			}
		}
		return $result;
	}
}


?>