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

    function index($group_id, $user_id)
    {
        $this->set('atim_menu_variables', array(
            'Group.id' => $group_id,
            'User.id' => $user_id
        ));
        
        $this->hook();
        
        $this->request->data = $this->paginate($this->UserLog, array(
            'UserLog.user_id' => $user_id
        ));
    }
}