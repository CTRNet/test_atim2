<?php
if (! isset($channel)) :
    $channel = array();





endif;
if (! isset($channel['title'])) :
    $channel['title'] = $titleForLayout;





endif;

echo $this->Rss->document($this->Rss->channel(array(), $channel, $this->fetch('content')));