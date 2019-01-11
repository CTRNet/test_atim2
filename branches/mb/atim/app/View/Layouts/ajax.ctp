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
AppController::atimSetCookie(isset($skipExpirationCookie) && $skipExpirationCookie);
echo $this->Shell->validationHtml();
$content = $this->fetch('content');
if (isset($_SESSION['query']['previous'])) {
    $log = "";
    foreach ($_SESSION['query']['previous'] as $key => $value) {
        $log .= $value;
    }
    $content .= '<div id="ajaxSqlLog" style="display: none"><div id="ajaxSqlLogInformation" style="display: none">' . __('Controller') . ': ' . $this->params['controller'] . ', ' . __('Action') . ': ' . $this->params['action'] . '</div>' . $log . '</div>';
}
echo $content;