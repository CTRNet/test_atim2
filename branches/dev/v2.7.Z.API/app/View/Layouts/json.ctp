<?php
AppController::atimSetCookie(isset($skipExpirationCookie) && $skipExpirationCookie);
$this->json['page'] = $this->Shell->validationHtml() . $this->json['page'];
echo json_encode($this->json);
