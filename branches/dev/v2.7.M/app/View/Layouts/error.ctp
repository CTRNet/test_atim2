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
 * @license MIT License (http://www.opensource.org/licenses/mit-license.php)
 */
$useBuffer = false;
if (! headers_sent()) {
    if (Configure::read('use_compression')) {
        assert(ob_start('ob_gzhandler')) or die('Failed to start compression buffer. Make sure ZLIB is installed properley (http://php.net/zlib) or turn compression off via use_compression in core.php.');
        $useBuffer = true;
    }
    header('Content-type: text/html; charset=utf-8');
    AppController::atimSetCookie(isset($skipExpirationCookie) && $skipExpirationCookie);
}
?>
<!DOCTYPE html>
<html>
<head>
	<?php
$header = $this->Shell->header(array(
    'atim_menu_for_header' => isset($atimMenuForHeader) ? $atimMenuForHeader : null,
    'atim_sub_menu_for_header' => isset($atimSubMenuForHeader) ? $atimSubMenuForHeader : null,
    'atim_menu' => isset($atimMenu) ? $atimMenu : null,
    'atim_menu_variables' => isset($atimMenuVariables) ? $atimMenuVariables : null
));
// var_dump(array($this->params['plugin'],$this->params['action'],$this->params['controller']));

$title = $this->Shell->pageTitle;
?>
	
	<title><?php echo $title ? $title.' &laquo ATiM' : __('core_appname'); ?></title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<!--<meta http-equiv="Pragma" content="no-cache" />
<meta http-equiv="Cache-Control"
	content=" no-store, no-cache, must-revalidate, pre-check=0, post-check=0, max-age=0" />
<meta http-equiv="Expires" content="0" />-->
<?php
// Add this if because the Print and echo functions cause warning in mode debug.
// https://stackoverflow.com/questions/8028957#answer-8028987
if (Configure::read('debug') === 0) {
    header("Cache-Control: no-cache, no-store, must-revalidate"); // HTTP 1.1.
    header("Pragma: no-cache"); // HTTP 1.0.
    header("Expires: 0"); // Proxies.
}
?>
<link rel="shortcut icon"
	href="<?php echo($this->request->webroot); ?>img/favicon.ico" />
	<?php
echo $this->Html->css('style') . "\n";
echo $this->Html->css('jQuery/themes/custom-theme/jquery-ui-1.8.20.custom') . "\n";
echo $this->Html->css('jQuery/popup/popup.css');
echo $this->Html->css('jQuery/fg.menu.css');

// set the locale
if (__('clin_english') == "Anglais") {
    $locale = "fr";
} else {
    $locale = "";
}

echo $this->Html->css('iehacks');
?>
	<![endif]-->
</head>
<body>
	
<?php
echo $header;

echo $this->Session->flash();
echo $this->Session->flash('auth');

// echo $content_for_layout;
echo $this->fetch('content');

echo $this->Shell->footer();

// echo $this->element('sql_dump');

// JS added to end of DOM tree...

echo $this->Html->script('jquery-1.7.2.min') . "\n";
echo $this->Html->script('jquery-ui-1.8.20.custom.min') . "\n";
echo $this->Html->script('jquery.ui-datepicker-fr.js') . "\n";
echo $this->Html->script('jquery.highlight.js') . "\n";
echo $this->Html->script('jquery.popup.js') . "\n";
echo $this->Html->script('jquery.tablednd.js') . "\n";
echo $this->Html->script('jquery.mousewheel.min.js') . "\n";
echo $this->Html->script('jquery.cookie.js') . "\n";
echo $this->Html->script('fg.menu.js') . "\n";
echo $this->Html->script('default') . "\n";
echo $this->Html->script('storage_layout') . "\n";
echo $this->Html->script('copyControl') . "\n";
echo $this->Html->script('ccl') . "\n";
echo $this->Html->script('dropdownConfig') . "\n";
echo $this->Html->script('jquery.fm-menu') . "\n";
echo $this->Html->script('form/jquery.form.js') . "\n";
?>
	
	<script type="text/javascript">
		$(function(){
			//initJsControls();
		});
	</script>
	<div id="default_popup" class='hidden std_popup'></div>
	<div id="hiddenImages">
		<span class="icon16 fetching"></span> <img
			src='<?php echo $this->request->webroot; ?>img/btnBackSel.png' />
	</div>
</body>
</html>
<?php
if ($useBuffer) {
    ob_end_flush();
}