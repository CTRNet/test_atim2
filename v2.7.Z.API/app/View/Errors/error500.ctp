<?php
$atimContent = array();
$errorMessage = __('a system error has been detected');

if (Configure::read('debug') > 0 && isset($name)) {
    $errorMessage = $name;
} elseif (strpos($message, 'server has gone away') > - 1) {
    $errorMessage = __('database server has gone away(Query should be limited)');
} elseif (strpos($message, 'An Internal Error Has Occurred') > - 1) {
    $errorMessage = $message;
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