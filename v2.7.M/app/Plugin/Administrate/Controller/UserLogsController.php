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
 * Class UserLogsController
 */
class UserLogsController extends AdministrateAppController
{

    public $uses = array(
        'UserLog'
    );

    public $paginate = array(
        'UserLog' => array(
            'order' => 'UserLog.visited DESC'
        )
    );

    /**
     *
     * @param $groupId
     * @param $userId
     */
    public function index($groupId, $userId)
    {
        $this->set('atimMenuVariables', array(
            'Group.id' => $groupId,
            'User.id' => $userId
        ));
        
        $this->hook();
        
        $this->request->data = $this->paginate($this->UserLog, array(
            'UserLog.user_id' => $userId
        ));
    }
}