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
 *
 *
 * CakePHP(tm) : Rapid Development Framework (http://cakephp.org)
 * Copyright (c) Cake Software Foundation, Inc. (http://cakefoundation.org)
 *
 * Licensed under The MIT License
 * For full copyright and license information, please see the LICENSE.txt
 * Redistributions of files must retain the above copyright notice.
 *
 * @copyright Copyright (c) Cake Software Foundation, Inc. (http://cakefoundation.org)
 * @link http://cakephp.org CakePHP(tm) Project
 * @package app.View.Layouts
 * @since CakePHP(tm) v 0.10.0.1076
 * @license http://www.opensource.org/licenses/mit-license.php MIT License
 */
?>
<!DOCTYPE html>
<html>
<head>

<title><?php echo $pageTitle.' &laquo; '.__('core_appname'); ?></title>
<link rel="shortcut icon"
	href="<?php echo($this->request->webroot); ?>img/favicon.ico" />

	<?php
echo $this->Html->css('style');
echo $this->Html->charset('UTF-8');
?>

	
</head>

<body class="flash">

	<div class="wrapper">
		<a href="<?php echo $url; ?>"> 
        	<?php echo $message; ?>
        	<br /> <small><?php echo __('click to continue'); ?></small>
		</a>
	</div>
</body>
</html>