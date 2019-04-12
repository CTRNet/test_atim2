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
		<h3>' . __($data['Page']['language_title'], true) . '</h3>
		' . $data['Page']['language_body'] . '
	';
if (isset($data['err_trace'])) {
    $atimContent['page'] .= "<br/>" . $data['err_trace'];
}

echo $this->Structures->generateContentWrapper($atimContent);