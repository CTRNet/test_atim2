<?php

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

    function index($groupId, $userId)
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