<?php
 /**
 *
 * ATiM - Advanced Tissue Management Application
 * Copyright (c) Canadian Tissue Repository Network (http://www.ctrnet.ca)
 *
 * Licensed under GNU General Public License
 * For full copyright and license information, please see the LICENSE.txt
 * Redistributions of files must retain the above copyright notice.
 *
 * @author        Canadian Tissue Repository Network <info@ctrnet.ca>
 * @copyright     Copyright (c) Canadian Tissue Repository Network (http://www.ctrnet.ca)
 * @link          http://www.ctrnet.ca
 * @since         ATiM v 2
 * @license       http://www.gnu.org/licenses  GNU General Public License
 */

/**
 * Class AtimAro
 */
class AtimAro extends Aro
{

    /**
     * Retrieves the Aro/Aco node for this model
     *
     * @param mixed $ref Array with 'model' and 'foreign_key', model object, or string value
     * @return array Node found in database
     * @access public
     */
    public function node($ref = null)
    {
        $db = ConnectionManager::getDataSource($this->useDbConfig);
        $type = $this->alias;
        $result = null;
        
        if (! empty($this->useTable)) {
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
                    $db->name("{$type}.rght") . ' >= ' . $db->name("{$type}0.rght")
                ),
                'fields' => array(
                    'id',
                    'parent_id',
                    'model',
                    'foreign_key',
                    'alias'
                ),
                'joins' => array(
                    array(
                        'table' => $db->fullTableName($this),
                        'alias' => "{$type}0",
                        'type' => 'LEFT',
                        'conditions' => array(
                            "{$type}0.alias" => $start
                        )
                    )
                ),
                'order' => $db->name("{$type}.lft") . ' DESC'
            );
            
            $joinConditions = array();
            
            foreach ($path as $i => $alias) {
                $j = $i - 1;
                
                $queryData['joins'][] = array(
                    'table' => $db->fullTableName($this),
                    'alias' => "{$type}{$i}",
                    'type' => 'LEFT',
                    'conditions' => array(
                        // $db->name("{$type}{$i}.lft") . ' > ' . $db->name("{$type}{$j}.lft"),
                        // $db->name("{$type}{$i}.rght") . ' < ' . $db->name("{$type}{$j}.rght"),
                        $db->name("{$type}{$i}.alias") . ' = ' . $db->value($alias, 'string')
                    )
                );
                
                $joinConditions[] = $db->name("{$type}{$i}.lft") . ' > ' . $db->name("{$type}{$j}.lft") . ' AND ' . $db->name("{$type}{$i}.rght") . ' < ' . $db->name("{$type}{$j}.rght") . ' AND ' . $db->name("{$type}{$i}.parent_id") . ' = ' . $db->name("{$type}{$j}.id");
                
                $queryData['conditions'] = join(' AND ', $joinConditions) . ' AND (' . ' (' . $db->name("{$type}.lft") . ' <= ' . $db->name("{$type}0.lft") . ' AND ' . $db->name("{$type}.rght") . ' >= ' . $db->name("{$type}0.rght") . ') OR (' . $db->name("{$type}.lft") . ' <= ' . $db->name("{$type}{$i}.lft") . ' AND ' . $db->name("{$type}.rght") . ' >= ' . $db->name("{$type}{$i}.rght") . ')' . ' )';
            }
            $result = $db->read($this, $queryData, - 1);
            $path = array_values($path);
            
            if (! isset($result[0][$type]) || (! empty($path) && $result[0][$type]['alias'] != $path[count($path) - 1]) || (empty($path) && $result[0][$type]['alias'] != $start)) {
                return false;
            }
        } elseif (is_object($ref) && is_a($ref, 'Model')) {
            $ref = array(
                'model' => $ref->alias,
                'foreign_key' => $ref->id
            );
        } elseif (is_array($ref) && ! (isset($ref['model']) && isset($ref['foreign_key']))) {
            $name = key($ref);
            
            $model = ClassRegistry::init(array(
                'class' => $name,
                'alias' => $name
            ));
            
            if (empty($model)) {
                trigger_error("Model class '$name' not found in AclNode::node() when trying to bind {$this->alias} object", E_USER_WARNING);
                return null;
            }
            
            $tmpRef = null;
            if (method_exists($model, 'bindNode')) {
                $tmpRef = $model->bindNode($ref);
            }
            if (empty($tmpRef)) {
                $ref = array(
                    'model' => $name,
                    'foreign_key' => $ref[$name][$model->primaryKey]
                );
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
                'fields' => array(
                    'id',
                    'parent_id',
                    'model',
                    'foreign_key',
                    'alias'
                ),
                'joins' => array(
                    array(
                        'table' => $db->fullTableName($this),
                        'alias' => "{$type}0",
                        'type' => 'LEFT',
                        'conditions' => array(
                            $db->name("{$type}.lft") . ' <= ' . $db->name("{$type}0.lft"),
                            $db->name("{$type}.rght") . ' >= ' . $db->name("{$type}0.rght")
                        )
                    )
                ),
                'order' => $db->name("{$type}.lft") . ' DESC'
            );
            $result = $db->read($this, $queryData, - 1);
            
            if (! $result) {
                trigger_error("AclNode::node() - Couldn't find {$type} node identified by \"" . print_r($ref, true) . "\"", E_USER_WARNING);
            }
        }
        return $result;
    }
}