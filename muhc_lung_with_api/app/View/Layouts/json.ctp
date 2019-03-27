<?php
AppController::atimSetCookie(isset($skipExpirationCookie) && $skipExpirationCookie);
$this->json['page'] = $this->Shell->validationHtml() . $this->json['page'];
if (isset($_SESSION['query']['previous']) && is_array($_SESSION['query']['previous']) && count($_SESSION['query']['previous']) != 0) {
    $this->json['sqlLog'] = $_SESSION['query']['previous'];
    $this->json['sqlLogInformations'] = __('Controller') . ': ' . $this->params['controller'] . ', ' . __('Action') . ': ' . $this->params['action'];
}
echo json_encode($this->json);