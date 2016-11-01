<?php
/**
 * SoftDeletable Behavior class file.
 *
 * @filesource
 * @author Mariano Iglesias
 * @link http://cake-syrup.sourceforge.net/ingredients/soft-deletable-behavior/
 * @version    $Revision: 38 $
 * @license    http://www.opensource.org/licenses/mit-license.php The MIT License
 * @package app
 * @subpackage app.models.behaviors
 *
 * @updated Alex Slotty Oct 2016
 *
 */

/**
 * Model behavior to support soft deleting records.
 *
 * @package app
 * @subpackage app.models.behaviors
 */
class SoftDeletableBehavior extends ModelBehavior {

	/**
	 * Contain settings indexed by model name.
	 *
	 * @var array
	 * @access private
	 */
	public $__settings = array();

	/**
	 * Initiate behaviour for the model using settings.
	 *
	 * @param Model $model Model using the behaviour
	 * @param array $config Settings to override for model.
	 *
	 * @return void
	 */
	public function setup(Model $model, $config = array()) {
		$default = array(
			'field' => 'deleted', /*'field_date' => 'deleted_date',*/
			'delete' => true,
			'find' => true
		);

		if (!isset($this->__settings[$model->alias])) {
			$this->__settings[$model->alias] = $default;
		}

		$this->__settings[$model->alias] = am($this->__settings[$model->alias], is_array($config) ? $config : array());
	}

	/**
	 * Run before a model is deleted, used to do a soft delete when needed.
	 *
	 * @param Model $model Model about to be deleted
	 * @param bool $cascade If true records that depend on this record will also be deleted
	 *
	 * @return bool Set to true to continue with delete, false otherwise
	 */
	public function beforeDelete(Model $model, $cascade = true) {
		if ($this->__settings[$model->alias]['delete'] && $model->hasField($this->__settings[$model->alias]['field'])) {
			$attributes = $this->__settings[$model->alias];
			$id = $model->id;

			$data = array(
				$model->alias => array(
					$attributes['field'] => 1
				)
			);

			if (isset($attributes['field_date']) && $model->hasField($attributes['field_date'])) {
				$data[$model->alias][$attributes['field_date']] = date('Y-m-d H:i:s');
			}

			foreach (am(array_keys($data[$model->alias]), array('field', 'field_date', 'find', 'delete')) as $field) {
				unset($attributes[$field]);
			}

			if (!empty($attributes)) {
				$data[$model->alias] = am($data[$model->alias], $attributes);
			}

			$model->id = $id;
			$deleted = $model->save($data, false, array_keys($data[$model->alias]));

			if ($deleted && $cascade) {
				$this->_atimDeleteDependent($model, $id, $cascade);
				$model->_deleteLinks($id);
			}

			return false;
		}

		return true;
	}

	/**
	 * Cascades model deletes through associated hasMany and hasOne child records.
	 * Altered model._atimDeleteDependent to ignore tables withoud the "delete" field.
	 *
	 * @param Model $model Model
	 * @param int $id Id
	 * @param bool $cascade Set to true to delete records that depend on this record
	 *
	 * @return void
	 */
	protected function _atimDeleteDependent(Model $model, $id, $cascade) {
		if (!empty($model->__backAssociation)) {
			$savedAssociatons = $model->__backAssociation;
			$model->__backAssociation = array();
		}
		if ($cascade === true) {
			foreach (array_merge($model->hasMany, $model->hasOne) as $assoc => $data) {
				if ($data['dependent'] === true) {

					$associatedModel = $model->{$assoc};

					if ($data['foreignKey'] === false && $data['conditions'] && in_array($model->name,
							$associatedModel->getAssociated('belongsTo'))
					) {
						$associatedModel->recursive = 0;
						$conditions = array($model->escapeField(null, $model->name) => $id);
					} else {
						$associatedModel->recursive = -1;
						$conditions = array($associatedModel->escapeField($data['foreignKey']) => $id);
						if ($data['conditions']) {
							$conditions = array_merge((array)$data['conditions'], $conditions);
						}
					}

					if (isset($data['exclusive']) && $data['exclusive']) {
						$associatedModel->deleteAll($conditions);
					} else {
						$records = $associatedModel->find('all', array(
							'conditions' => $conditions,
							'fields' => $associatedModel->primaryKey
						));

						if (!empty($records)) {
							foreach ($records as $record) {
								$schema = $associatedModel->schema();
								if (isset($schema["deleted"])) {
									$associatedModel->delete($record[$associatedModel->alias][$associatedModel->primaryKey]);
								}
							}
						}
					}
				}
			}
		}
		if (isset($savedAssociatons)) {
			$model->__backAssociation = $savedAssociatons;
		}
	}

	/**
	 * Permanently deletes a record.
	 *
	 * @param Model &$model Model from where the method is being executed.
	 * @param mixed $id ID of the soft-deleted record.
	 * @param bool $cascade Also delete dependent records
	 *
	 * @return bool Result of the operation.
	 */
	public function hardDelete(&$model, $id, $cascade = true) {
		$onFind = $this->__settings[$model->alias]['find'];
		$onDelete = $this->__settings[$model->alias]['delete'];
		$this->enableSoftDeletable($model, false);

		$deleted = $model->del($id, $cascade);

		$this->enableSoftDeletable($model, 'delete', $onDelete);
		$this->enableSoftDeletable($model, 'find', $onFind);

		return $deleted;
	}

	/**
	 * Set if the beforeFind() or beforeDelete() should be overriden for specific model.
	 *
	 * @param Model &$model Model about to be deleted.
	 * @param mixed $methods If string, method (find / delete) to enable on, if array array of method names, if
	 *     boolean, enable it for find method
	 * @param bool $enable If specified method should be overridden.
	 *
	 * @return void
	 *
	 */
	public function enableSoftDeletable(&$model, $methods, $enable = true) {
		if (is_bool($methods)) {
			$enable = $methods;
			$methods = array('find', 'delete');
		}

		if (!is_array($methods)) {
			$methods = array($methods);
		}

		foreach ($methods as $method) {
			$this->__settings[$model->alias][$method] = $enable;
		}
	}

	/**
	 * Permanently deletes all records that were soft deleted.
	 *
	 * @param Model &$model Model from where the method is being executed.
	 * @param bool $cascade Also delete dependent records
	 *
	 * @return bool Result of the operation.
	 */
	public function purge(&$model, $cascade = true) {
		$purged = false;

		if ($model->hasField($this->__settings[$model->alias]['field'])) {
			$onFind = $this->__settings[$model->alias]['find'];
			$onDelete = $this->__settings[$model->alias]['delete'];
			$this->enableSoftDeletable($model, false);

			$purged = $model->deleteAll(array($this->__settings[$model->alias]['field'] => '1'), $cascade);

			$this->enableSoftDeletable($model, 'delete', $onDelete);
			$this->enableSoftDeletable($model, 'find', $onFind);
		}

		return $purged;
	}

	/**
	 * Restores a soft deleted record, and optionally change other fields.
	 *
	 * @param Model &$model Model from where the method is being executed.
	 * @param mixed $id ID of the soft-deleted record.
	 * @param array $attributes Other fields to change (in the form of field => value)
	 *
	 * @return bool Result of the operation.
	 */
	public function undelete(&$model, $id = null, $attributes = array()) {
		if ($model->hasField($this->__settings[$model->alias]['field'])) {
			if (empty($id)) {
				$id = $model->id;
			}

			$data = array(
				$model->alias => array(
					$model->primaryKey => $id,
					$this->__settings[$model->alias]['field'] => '0'
				)
			);

			if (isset($this->__settings[$model->alias]['field_date']) && $model->hasField($this->__settings[$model->alias]['field_date'])) {
				$data[$model->alias][$this->__settings[$model->alias]['field_date']] = null;
			}

			if (!empty($attributes)) {
				$data[$model->alias] = am($data[$model->alias], $attributes);
			}

			$onFind = $this->__settings[$model->alias]['find'];
			$onDelete = $this->__settings[$model->alias]['delete'];
			$this->enableSoftDeletable($model, false);

			$model->id = $id;
			$result = $model->save($data, false, array_keys($data[$model->alias]));

			$this->enableSoftDeletable($model, 'find', $onFind);
			$this->enableSoftDeletable($model, 'delete', $onDelete);

			return ($result !== false);
		}

		return false;
	}

	/**
	 * Run before a model is about to be find, used only fetch for non-deleted records.
	 *
	 * @param Model $model Model about to be deleted.
	 * @param array $query Data used to execute this query, i.e. conditions, order, etc.
	 *
	 * @return mixed Set to false to abort find operation, or return an array with data used to execute query
	 */
	public function beforeFind(Model $model, $query) {
		if ($this->__settings[$model->alias]['find'] && $model->hasField($this->__settings[$model->alias]['field'])) {
			$Db = ConnectionManager::getDataSource($model->useDbConfig);
			$include = false;

			if (!empty($query['conditions']) && is_string($query['conditions'])) {
				$include = true;

				$fields = array(
					$Db->name($model->alias) . '.' . $Db->name($this->__settings[$model->alias]['field']),
					$Db->name($this->__settings[$model->alias]['field']),
					$model->alias . '.' . $this->__settings[$model->alias]['field'],
					$this->__settings[$model->alias]['field']
				);

				foreach ($fields as $field) {
					if (preg_match('/^' . preg_quote($field) . '[\s=!]+/i',
							$query['conditions']) || preg_match('/\\x20+' . preg_quote($field) . '[\s=!]+/i',
							$query['conditions'])
					) {
						$include = false;
						break;
					}
				}
			} else {
				if (empty($query['conditions']) || (!in_array($this->__settings[$model->alias]['field'],
							array_keys($query['conditions'])) && !in_array($model->alias . '.' . $this->__settings[$model->alias]['field'],
							array_keys($query['conditions']))) || isset($query['conditions'][0])
				) {
					$include = true;
				}
			}

			if ($include) {
				if (empty($query['conditions'])) {
					$query['conditions'] = array();
				}

				if (is_string($query['conditions'])) {
					$query['conditions'] = $Db->name($model->alias) . '.' . $Db->name($this->__settings[$model->alias]['field']) . '!= 1 AND ' . $query['conditions'];
				} else {
					array_push($query['conditions'],
						$model->alias . '.' . $this->__settings[$model->alias]['field'] . ' != 1');
				}
			}

			//Add the deleted != 1 condition for hasMany relationships
			foreach ($model->hasMany as $key => &$hasMany) {
				if (isset($hasMany['conditions']) && $hasMany['conditions'] != "") {
					array_push($hasMany['conditions'], $key . ".deleted != 1");
				} else {
					$hasMany['conditions'] = array($key . ".deleted != 1");
				}
			}
		}

		return $query;
	}

	/**
	 * Run before a model is saved, used to disable beforeFind() override.
	 *
	 * @param Model $model Model about to be saved.
	 * @param array $options Options
	 *
	 * @return bool True if the operation should continue, false if it should abort
	 */
	public function beforeSave(Model $model, $options = Array()) {
		if ($this->__settings[$model->alias]['find']) {
			if (!isset($this->__backAttributes)) {
				$this->__backAttributes = array($model->alias => array());
			} else {
				if (!isset($this->__backAttributes[$model->alias])) {
					$this->__backAttributes[$model->alias] = array();
				}
			}

			$this->__backAttributes[$model->alias]['find'] = $this->__settings[$model->alias]['find'];
			$this->__backAttributes[$model->alias]['delete'] = $this->__settings[$model->alias]['delete'];
			$this->enableSoftDeletable($model, false);
		}

		return true;
	}

	/**
	 * Run after a model has been saved, used to enable beforeFind() override.
	 *
	 * @param Model $model Model just saved.
	 * @param bool $created True if this save created a new record
	 * @param array $options Options
	 *
	 * @return void
	 */
	public function afterSave(Model $model, $created, $options = array()) {
		if (isset($this->__backAttributes[$model->alias]['find'])) {
			$this->enableSoftDeletable($model, 'find', $this->__backAttributes[$model->alias]['find']);
			$this->enableSoftDeletable($model, 'delete', $this->__backAttributes[$model->alias]['delete']);
			unset($this->__backAttributes[$model->alias]['find']);
			unset($this->__backAttributes[$model->alias]['delete']);
		}
	}
}