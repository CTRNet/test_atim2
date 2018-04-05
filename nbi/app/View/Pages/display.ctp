<?php
$atimContent = array();

$atimContent['page'] = '
		<h3>' . __($data['Page']['language_title'], true) . '</h3>
		' . $data['Page']['language_body'] . '
	';
if (isset($data['err_trace'])) {
    $atimContent['page'] .= "<br/>" . $data['err_trace'];
}

echo $this->Structures->generateContentWrapper($atimContent);