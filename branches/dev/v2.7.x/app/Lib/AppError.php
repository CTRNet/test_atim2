<?php

class AppError {

/**
 * Custom Error Handler
 *
 * @param int $code Code of error
 * @param string $description Error description
 * @param string $file File on which error occurred
 * @param int $line Line that triggered the error
 * @param array $context Context
 * @return bool true if error was handled
 */
	public static function handleError($code, $description, $file = null, $line = null, $context = null) {
		if (class_exists("AppController")) {
			$controller = AppController::getInstance();
			if ($code == E_USER_WARNING && strpos($description, "SQL Error:") !== false && $controller->name != 'Pages') {
				$traceMsg = "<table><tr><th>File</th><th>Line</th><th>Function</th></tr>";
				try {
					throw new Exception("");
				} catch (Exception $e) {
					$traceArr = $e->getTrace();
					foreach ($traceArr as $traceLine) {
						if (is_array($traceLine)) {
							$traceMsg .= "<tr><td>" . (isset($traceLine['file']) ? $traceLine['file'] : "") . "</td><td>" . (isset($traceLine['line']) ? $traceLine['line'] : "") . "</td><td>" . $traceLine['function'] . "</td></tr>";
						} else {
							$traceMsg .= "<tr><td></td><td></td><td></td></tr>";
						}
					}
				}
				$traceMsg .= "</table>";
				$controller->redirect('/Pages/err_query?err_msg=' . urlencode($description . $traceMsg));
			}
		}
		return false;
	}
}