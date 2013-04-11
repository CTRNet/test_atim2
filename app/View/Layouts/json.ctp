<?php
AppController::atimSetCookie(isset($skip_expiration_cookie) && $skip_expiration_cookie);
$this->json['page'] = $this->json['page'];
echo json_encode($this->json);
