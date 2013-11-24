<?php
/**
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
 * @package       app.View.Layouts
 * @since         CakePHP(tm) v 0.10.0.1076
 * @license       http://www.opensource.org/licenses/mit-license.php MIT License
 */
?>
<!DOCTYPE html>
<html>
<head>
	
	<title><?php echo $page_title.' &laquo; '.__('core_appname', true); ?></title>
	<link rel="shortcut icon" href="<?php echo($this->webroot); ?>img/favicon.ico"/>

	<?php 
		echo $this->Html->css('style');
		echo $this->Html->charset('UTF-8');
	 ?>

	
</head>

<body class="flash">

    <div class="wrapper">
		<a href="<?php echo $url; ?>"> 
        	<?php echo $message; ?>
        	<br/>
	        <small><?php __('click to continue'); ?></small>
		</a>
    </div>
    <?php
    	echo $this->element('sql_dump');
    ?>
    
</body>
</html>
