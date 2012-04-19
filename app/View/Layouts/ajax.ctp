<?php
AppController::atimSetCookie(isset($skip_expiration_cookie) && $skip_expiration_cookie);
echo $this->Shell->validationHtml();
echo $content_for_layout;
