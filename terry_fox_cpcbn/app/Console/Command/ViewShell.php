<?php
class ViewShell extends AppShell{
	
	var $uses	= array('User');
	var $commands = array();
	
	public function main(){
		$this->out('Log in with a user/password combination of a user from the administror group.');
		$username = $this->in('user');
		$pwd = $this->prompt_silent();
		$pwd = Security::hash($pwd, null, true);
		
		$user = $this->User->find('first', array('conditions' => array('User.username' => $username, 'User.password' => $pwd, 'User.flag_active' => 1)));
		if(empty($user)){
			$this->error('Invalid username/password');
			exit;
		}else if($user['User']['group_id'] != 1){
			$this->error('This user is not part of the administration group.');
			exit;
		}

		$this->commands['exit'] = function($self){
			exit;
		};
		$this->commands['help'] = function($self){
			$self->help();
		};
		$this->commands['store'] = function($self){
			$views = $self->getViews();
			
			if($views){
				try{
					$self->User->query('DROP TABLE console_stored_views');
				}catch(Exception $e){
					//table doesn't exists
				}
				$self->User->query('CREATE TABLE console_stored_views (name VARCHAR(50) NOT NULL DEFAULT "", command TEXT, is_table BOOLEAN NOT NULL DEFAULT false)Engine=InnoDb');
				
				$db_conf = new DATABASE_CONFIG();
					
				foreach($views as $result){
					$create = $self->User->query('SHOW CREATE TABLE '.$result);
					if(isset($create[0][0]['Create View'])){
						$index = strpos($create[0][0]['Create View'], " VIEW ");
						$create_view_str = str_replace("`$db_conf->default['database']`.", '', $create[0][0]['Create View']);
						$create_view_str = "CREATE ".substr($create_view_str, $index + 1);
						$self->User->query('INSERT INTO console_stored_views VALUES ("'.$result.'", "'.$create_view_str.'", 0)');
					}else if(isset($create[0][0]['Create Table'])){
						$self->User->query('INSERT INTO console_stored_views VALUES ("'.$result.'", "", 1)');
					}else{
						$self->out('Error: View and Table were found.');
						exit;
					}
				}
				$self->out('Views have been stored. Any previous entries in console_stored_views have been deleted.');
			}else{
				$self->out('No views found.');
			}
		};
		$this->commands['delete'] = function($self){
			$views = $self->getViews();
			foreach($views as $view){
				try{
					$self->User->query('DROP TABLE '.$view);
				}catch(Exception $e){
					//not a table
					$self->User->query('DROP VIEW '.$view);
				}
			}
			$self->out('Views have been deleted.');
		};
		$this->commands['rebuild'] = function($self){
			$views = $self->getViews();
			if($views){
				$self->out('Cannot rebuild views. They already exist.');
			}else{
				$results = $self->User->query('SELECT command FROM console_stored_views WHERE is_table=false');
				$results = Set::flatten($results);
				foreach($results as $result){
					$self->User->query($result);
				}
				$results = $self->User->query('SELECT name FROM console_stored_views WHERE is_table=true');
				$results = Set::flatten($results);
				foreach($results as $result){
					$self->User->query('CREATE TABLE '.$result.' (SELECT * FROM '.$result.'_view)');
					$desc = $self->User->query('DESC '.$result);
					$fields = array();
					$field = array_shift($desc);
					$pkey = $field['COLUMNS']['Field'];
					foreach($desc as $field){
						if($field['COLUMNS']['Type'] != 'text'){
							$fields[] = $field['COLUMNS']['Field'];
						}
					}
					$self->User->query('ALTER TABLE '.$result.' ADD PRIMARY KEY('.$pkey.'), ADD KEY ('.implode('), ADD KEY (', $fields).')');
				}
				$self->out('Views have been rebuilt.');
			}
		};
		$this->commands['rebuild-all'] = function($self){
			$self->commands['store']($self);
			$self->commands['delete']($self);
			$self->commands['rebuild']($self);
		};

		
		$this->help();
		
		while(true){
			if($command = $this->in('')){
				if(isset($this->commands[$command])){
					$this->commands[$command]($this);
				}else{
					$this->out('Unknown command. Type "help" to get a list of available commands.');
				}
			}
		}
	}
	
	
	function help(){
		$this->out('Available commands:');
		$this->out(sprintf('-%-12s Stores the view commands.', 'store'));
		$this->out(sprintf('-%-12s Delete the views.', 'delete'));
		$this->out(sprintf('-%-12s Rebuilds the views from the stored table.', 'rebuild'));
		$this->out(sprintf('-%-12s Runs store, delete and rebuild sequentially.', 'rebuild-all'));
		$this->out(sprintf('-%-12s Exits the application.', 'exit'));
		$this->out(sprintf('-%-12s Prints this message.', 'help'));
	}
	
	function getViews(){
		$results = $this->User->query("SHOW TABLES LIKE 'view_%'");
		return Set::flatten($results);
	}
	
}