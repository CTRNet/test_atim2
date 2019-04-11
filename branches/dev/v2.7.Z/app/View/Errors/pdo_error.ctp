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
$atimContent = array();

$atimContent['page'] = '
		<h3>' . __('system error', true) . '</h3>
		' . __('a system error has been detected') . '
	';

if (Configure::read('debug') > 0) {
    $atimContent['page'] .= "<br/>" . $this->element('exception_stack_trace');
}

echo $this->Structures->generateContentWrapper($atimContent);