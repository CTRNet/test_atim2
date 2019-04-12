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
$errorMessage = __('a system error has been detected');

if (Configure::read('debug') > 0 && isset($name)) {
    $errorMessage = $name;
} elseif (strpos($message, 'server has gone away') > - 1) {
    $errorMessage = __('database server has gone away(Query should be limited)');
} elseif (strpos($message, 'bytes exhausted') > - 1) {
    $errorMessage = __('out of memory error');
} elseif ($this->params['plugin'] == 'Datamart' && $this->params['action'] == 'browse' && $this->params['controller'] == 'Browser') {
    $errorMessage = __('out of memory error');
} elseif ($this->params['plugin'] == 'Datamart' && $this->params['action'] == 'csv' && $this->params['controller'] == 'Browser') {
    $errorMessage = __('Maximum execution time exceeded');
    die();
}

$atimContent['page'] = '
                    <h3>' . __('system error', true) . '</h3>
                    ' . $errorMessage . '
            ';

if (Configure::read('debug') > 0) {
    $atimContent['page'] .= "<br/>" . $this->element('exception_stack_trace');
}

echo $this->Structures->generateContentWrapper($atimContent);