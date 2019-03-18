<?php
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
<noscript>
	<style>
body * {
	display: none;
}

.noJavaScript {
	color: red;
	font-weight: bold;
	text-align: center;
	display: block;
}
</style>
	<p class="noJavaScript">This page needs Javascript activated to work.</p>
</noscript>	
	<?php
$header = $this->Shell->header(array(
    'atim_menu_for_header' => $atimMenuForHeader,
    'atim_sub_menu_for_header' => $atimSubMenuForHeader,
    'atim_menu' => $atimMenu,
    'atim_menu_variables' => $atimMenuVariables
));
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
echo $this->Html->css('d3/nv.d3.css') . "\n"; // Chart
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
?>
		
		<script>
			var root_url = "<?php echo($this->request->webroot); ?>";
			var webroot_dir = root_url + "/app/webroot/";
			var locale = "<?php echo $locale; ?>";
			var STR_OR = "<?php echo __('or'); ?>";
			var STR_SPECIFIC = "<?php echo __('specific'); ?>";
			var STR_RANGE = "<?php echo __('range'); ?>";
			var STR_TO = "<?php echo __('to'); ?>";
			var STR_DELETE_CONFIRM = "<?php echo __( 'core_are you sure you want to delete this data?') ?>";
			var STR_YES = "<?php echo __('yes'); ?>";
			var STR_NO = "<?php echo __('no'); ?>";
			var STR_COPY = "<?php echo __("copy", null); ?>";
			var STR_PASTE = "<?php echo __("paste"); ?>";
			var STR_PASTE_ON_ALL_LINES = "<?php echo __("paste on all lines"); ?>";
			var STR_PASTE_ON_ALL_LINES_OF_ALL_SECTIONS = "<?php echo __("paste on all lines of all sections"); ?>";
			var STR_LAB_BOOK = "<?php echo __("lab book"); ?>";
			var STR_LOADING = "<?php echo __('loading'); ?>";
			var STR_OK = "<?php echo __('ok'); ?>";
			var STR_CANCEL = "<?php echo __('cancel'); ?>";
			var STR_LOADING = "<?php echo __('loading'); ?>";
			var STR_BACK = "<?php echo __('back'); ?>";
			var STR_NODE_SELECTION = "<?php echo __('nodes selection'); ?>";
			var DEBUG_MODE = "<?php echo Configure::read('debug'); ?>";
			var csvWarning = "<?php echo __('csv file warning') ?>";
			var maxUploadFileSize = "<?php echo Configure::read('maxUploadFileSize'); ?>";
			var maxUploadFileSizeError = "<?php echo __('the file size should be less than %d bytes', Configure::read('maxUploadFileSize')) ?>";
			var loadSearchDataMessage = Array("<?php echo __('previous search') ?>", "<?php echo __('reset search') ?>");
                        var here = "<?php echo __('here'); ?>";
                        var DUPLICATED_ALIQUOT = "<?php echo __('this aliquot is registered in another place'); ?>";
            <?php if (isset($_SESSION['js_post_data'])){echo ($_SESSION['js_post_data']); unset($_SESSION['js_post_data']);}?>
		</script>
<!--[if IE 7]>
	<?php

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
echo $this->Html->script('d3/d3.js') . "\n"; // Chart
echo $this->Html->script('saveSvgAsPng.js') . "\n"; // Chart
if ($this->params['plugin'] == 'Datamart' && $this->params['controller'] == 'Reports' && $this->params['action'] == 'manageReport') {
    echo $this->Html->script('d3/nv.d3.js') . "\n"; // Chart
}
?>

	<script type="text/javascript">
		$(function(){
			initJsControls();
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