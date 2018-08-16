<?php

/**
 * Class ViewShell
 */
class ViewShell extends AppShell
{

    public $uses = array(
        'User'
    );

    public $commands = array();

    public function main()
    {
        $this->out('Log in with a user/password combination of a user from the administror group.');
        $username = $this->in('user');
        $pwd = $this->promptSilent();
        $pwd = Security::hash($pwd, null, true);
        
        $user = $this->User->find('first', array(
            'conditions' => array(
                'User.username' => $username,
                'User.password' => $pwd,
                'User.flag_active' => 1
            )
        ));
        if (empty($user)) {
            $this->error('Invalid username/password');
            exit();
        } elseif ($user['User']['group_id'] != 1) {
            $this->error('This user is not part of the administration group.');
            exit();
        }
        
        $this->commands['exit'] = function ($self) {
            exit();
        };
        $this->commands['help'] = function ($self) {
            $self->help();
        };
        $this->commands['store'] = function ($self) {
            $views = $self->getViews();
            
            if ($views) {
                try {
                    $self->User->query('DROP TABLE console_stored_views');
                } catch (Exception $e) {
                    // table doesn't exists
                }
                $self->User->query('CREATE TABLE console_stored_views (name VARCHAR(50) NOT NULL DEFAULT "", command TEXT)Engine=InnoDb');
                
                $dbConf = new DATABASE_CONFIG();
                
                foreach ($views as $result) {
                    $create = $self->User->query('SHOW CREATE TABLE ' . $result);
                    $index = strpos($create[0][0]['Create View'], " VIEW ");
                    $createViewStr = str_replace('`' . $dbConf->default['database'] . '`.', '', $create[0][0]['Create View']);
                    $createViewStr = "CREATE " . substr($createViewStr, $index + 1);
                    $self->User->query('INSERT INTO console_stored_views VALUES ("' . $result . '", "' . $createViewStr . '")');
                }
                $self->out('Views have been stored. Any previous entries in console_stored_views have been deleted.');
            } else {
                $self->out('No views found.');
            }
        };
        $this->commands['delete'] = function ($self) {
            $views = $self->getViews();
            foreach ($views as $view) {
                $self->User->query('DROP VIEW ' . $view);
            }
            $self->out('Views have been deleted.');
        };
        $this->commands['rebuild'] = function ($self) {
            $views = $self->getViews();
            if ($views) {
                $self->out('Cannot rebuild views. They already exist.');
            } else {
                $results = $self->User->query('SELECT command FROM console_stored_views', false);
                $results = Set::flatten($results);
                foreach ($results as $result) {
                    $self->User->query($result);
                }
                $self->out('Views have been rebuilt.');
            }
        };
        $this->commands['rebuild-all'] = function ($self) {
            $self->commands['store']($self);
            $self->commands['delete']($self);
            $self->commands['rebuild']($self);
        };
        
        $this->help();
        
        while (true) {
            if ($command = $this->in('')) {
                if (isset($this->commands[$command])) {
                    $this->commands[$command]($this);
                } else {
                    $this->out('Unknown command. Type "help" to get a list of available commands.');
                }
            }
        }
    }

    public function help()
    {
        $this->out('Available commands:');
        $this->out(sprintf('-%-12s Stores the view commands.', 'store'));
        $this->out(sprintf('-%-12s Delete the views.', 'delete'));
        $this->out(sprintf('-%-12s Rebuilds the views from the stored table.', 'rebuild'));
        $this->out(sprintf('-%-12s Runs store, delete and rebuild sequentially.', 'rebuild-all'));
        $this->out(sprintf('-%-12s Exits the application.', 'exit'));
        $this->out(sprintf('-%-12s Prints this message.', 'help'));
    }

    /**
     *
     * @return array
     */
    public function getViews()
    {
        $results = $this->User->query("SHOW TABLES LIKE 'view_%'");
        $results = Set::flatten($results);
        foreach ($results as $index => $result) {
            $create = $this->User->query('SHOW CREATE TABLE ' . $result);
            if (! isset($create[0][0]['Create View'])) {
                unset($results[$index]);
            }
        }
        return $results;
    }
}