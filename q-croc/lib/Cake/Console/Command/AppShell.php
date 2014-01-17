<?php
/**
 * AppShell file
 *
 * PHP 5
 *
 * CakePHP(tm) : Rapid Development Framework (http://cakephp.org)
 * Copyright (c) Cake Software Foundation, Inc. (http://cakefoundation.org)
 *
 * Licensed under The MIT License
 * For full copyright and license information, please see the LICENSE.txt
 * Redistributions of files must retain the above copyright notice.
 *
 * @copyright     Copyright (c) Cake Software Foundation, Inc. (http://cakefoundation.org)
 * @link          http://cakephp.org CakePHP(tm) Project
 * @since         CakePHP(tm) v 2.0
 * @license       MIT License (http://www.opensource.org/licenses/mit-license.php)
 */

App::uses('Shell', 'Console');

/**
 * Application Shell
 *
 * Add your application-wide methods in the class below, your shells
 * will inherit them.
 *
 * @package       app.Console.Command
 */
class AppShell extends Shell {
	//ATiM -- all functions here are from ATiM
	/**
	 * Prompts for password and returns it.
	 * http://stackoverflow.com/questions/187736/command-line-password-prompt-in-php
	 * @param string $prompt
	 * @return void|string
	 */
	 function prompt_silent($prompt = "Enter Password:") {
	 	if (preg_match('/^win/i', PHP_OS)) {
	 		$vbscript = sys_get_temp_dir() . 'prompt_password.vbs';
	 		file_put_contents(
	 				$vbscript, 'wscript.echo(InputBox("'
					. addslashes($prompt)
						. '", "", "password here"))');
			$command = "cscript //nologo " . escapeshellarg($vbscript);
			$password = rtrim(shell_exec($command));
			unlink($vbscript);
			return $password;
	 	} else {
	 		$command = "/usr/bin/env bash -c 'echo OK'";
	 		if (rtrim(shell_exec($command)) !== 'OK') {
	 			trigger_error("Can't invoke bash");
	 			return;
	 		}
	 		$command = "/usr/bin/env bash -c 'read -s -p \""
	 	       			. addslashes($prompt)
	 					. "\" mypassword && echo \$mypassword'";
	 		$password = rtrim(shell_exec($command));
	 		echo "\n";
	 		return $password;
	 	}
	 }
}
