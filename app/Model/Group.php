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
 * Class Group
 */
class Group extends AppModel
{

    public $actsAs = array(
        'Acl' => array(
            'requester'
        )
    );

    public $hasMany = array(
        'User'
    );

    /**
     *
     * @return null
     */
    public function parentNode()
    {
        return null;
    }

    /**
     *
     * @param array $variables
     * @return array|bool
     */
    public function summary($variables = array())
    {
        $return = false;
        
        if (isset($variables['Group.id'])) {
            $result = $this->find('first', array(
                'conditions' => array(
                    'Group.id' => $variables['Group.id']
                )
            ));
            $return = array(
                'menu' => array(
                    null,
                    $result['Group']['name']
                ),
                'title' => array(
                    null,
                    $result['Group']['name']
                ),
                'data' => $result,
                'structure alias' => 'groups'
            );
        }
        
        return $return;
    }

    public function bindToPermissions()
    {
        $this->bindModel(array(
            'hasOne' => array(
                'Aro' => array(
                    'className' => 'Aro',
                    'foreignKey' => 'foreign_key',
                    'conditions' => 'Aro.model="Group"'
                )
            )
        ));
        
        $this->Aro->unbindModel(array(
            'hasAndBelongsToMany' => array(
                'Aco'
            )
        ));
        
        $this->Aro->bindModel(array(
            'hasMany' => array(
                'Permission' => array(
                    'className' => 'Permission',
                    'foreign_key' => 'aco_id'
                )
            )
        ));
    }

    /**
     * Checks if at least one permission for that group is granted
     *
     * @param $groupId
     * @return bool
     */
    public function hasPermissions($groupId)
    {
        $data = $this->find('first', array(
            'joins' => array(
                array(
                    'table' => 'aros',
                    'alias' => 'aros',
                    'type' => 'inner',
                    'conditions' => array(
                        'Group.id = aros.foreign_key',
                        'aros.model="Group"'
                    )
                ),
                array(
                    'table' => 'aros_acos',
                    'alias' => 'aros_acos',
                    'type' => 'inner',
                    'conditions' => array(
                        'aros.id = aros_acos.aro_id',
                        'OR' => array(
                            'aros_acos._create' => 1,
                            'aros_acos._read' => 1,
                            'aros_acos._update' => 1,
                            'aros_acos._delete' => 1
                        )
                    )
                )
            ),
            'conditions' => array(
                'Group.id' => $groupId
            )
        ));
        return ! empty($data);
    }

    /**
     *
     * @return array|null
     */
    public function getList()
    {
        return $this->find('list', array(
            'fields' => array(
                'Group.name'
            ),
            'order' => array(
                'Group.name'
            )
        ));
    }
}