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
AppController::atimSetCookie(isset($skipExpirationCookie) && $skipExpirationCookie);
$this->json['page'] = $this->Shell->validationHtml() . $this->json['page'];
if (isset($_SESSION['query']['previous']) && is_array($_SESSION['query']['previous']) && count($_SESSION['query']['previous']) != 0) {
    $this->json['sqlLog'] = $_SESSION['query']['previous'];
    $this->json['sqlLogInformations'] = __('Controller') . ': ' . $this->params['controller'] . ', ' . __('Action') . ': ' . $this->params['action'];
}
echo json_encode($this->json);